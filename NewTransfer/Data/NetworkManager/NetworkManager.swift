//
//  NetworkManager.swift
//  NewTransfer
//
//  Created by Jongho Lee on 2021/07/08.
//

import Foundation

typealias ResultCallback<Response> = (Result<Response, ApiError>) -> Void

protocol URLSessionProtocol {
	func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
}

protocol NetworkProtocol {
	init(session: URLSessionProtocol)
	var session: URLSessionProtocol { get set }
	func fetch<Request: NetworkApiInterface & RequestableBody>(by request: Request, completion: @escaping ResultCallback<Request.Response>)
}

class NetworkManager: NetworkProtocol {

	var session: URLSessionProtocol

	required init(session: URLSessionProtocol = URLSession.shared) {
		self.session = session
	}

	/// network request with httpBody
	func fetch<Request>(by request: Request, completion: @escaping ResultCallback<Request.Response>) where Request : NetworkApiInterface, Request : RequestableBody {

		guard let encodedModel = try? JSONEncoder().encode(request.body) else {
			completion(.failure(.encodingModel))
			return
		}
		var urlRequest = URLRequest(url: request.url)
		urlRequest.httpMethod = request.method.rawValue
		urlRequest.httpBody = encodedModel

		// Mock 통신 session 분기 처리
		if NetworkServerConfig.server == .mock {
			session = MockURLSession<Request>.init(
				result: .success,
				response: request
			)
		}

		let task: URLSessionDataTask = session
			.dataTask(with: urlRequest) { data, urlResponse, error in
				guard let response = urlResponse as? HTTPURLResponse,
					  (200...399).contains(response.statusCode) else {
					completion(.failure(.httpStatus))
					return
				}

				guard let data = data else {
					return completion(.failure(.dataNil))
				}

				guard let model = try? JSONDecoder().decode(Request.Response.self, from: data) else {
					completion(.failure(.decodingJSON))
					return
				}
				completion(.success(model))
			}
		task.resume()
	}
}
