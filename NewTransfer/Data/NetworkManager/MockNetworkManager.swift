//
//  MockNetworkManager.swift
//  NewTransfer
//
//  Created by Jongho Lee on 2021/07/12.
//
#if DEBUG
import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
	override init() { }

	var resumeDidCall: () -> Void = {}

	override func resume() {
		resumeDidCall()
	}
}

class MockURLSession<Request>: URLSessionProtocol where Request : NetworkApiInterface {

	enum MockRequestResult {
		case success
		case failure
	}

	var networkResult: MockRequestResult
	var networkResponse: Data

	init(result: MockRequestResult = .success, response: Request) {
		self.networkResult = result
		self.networkResponse = response.mockResponse
	}

	var sessionDataTask: MockURLSessionDataTask?

	// Mock dataTask 를 구현
	func dataTask(with request: URLRequest,
				  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

		// 성공시 callback 으로 넘겨줄 response
		let successResponse = HTTPURLResponse(url: URL(string: "mock~")!,
											  statusCode: 200,
											  httpVersion: "",
											  headerFields: nil)
		// 실패시 callback 으로 넘겨줄 response
		let failureResponse = HTTPURLResponse(url: URL(string: "mock~")!,
											  statusCode: 400,
											  httpVersion: "",
											  headerFields: nil)

		let sessionDataTask = MockURLSessionDataTask()

		// resume() 이 호출되면 completionHandler() 가 호출되도록 합니다.
		sessionDataTask.resumeDidCall = { [weak self] in
			guard let self = self else { return }
			switch self.networkResult {
				case .success:
					completionHandler(self.networkResponse, successResponse, nil)
				case .failure:
					completionHandler(nil, failureResponse, nil)
			}
		}
		self.sessionDataTask = sessionDataTask
		return sessionDataTask
	}
}
#endif
