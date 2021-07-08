//
//  ApiConfig.swift
//  NewTransfer
//
//  Created by Jongho Lee on 2021/07/08.
//

import Foundation

protocol NetworkApiInterface {
	associatedtype Response: ApiResponsive
	var url: URL { get }
	var method: HttpMethod { get }
	var responseSample: Data { get }	// Mock 통신 용
}

protocol RequestableBody {
	associatedtype Request: ApiRequestable
	init(body: Request)
	var body: Request { get set }
}

protocol ApiRequestable: Encodable {
}

protocol ApiResponsive: Decodable {
}

enum ApiError: Error {
	case unknown
	case httpStatus
	case encodingModel
	case decodingJSON
	case dataNil
//	var errorDescription: String? { "unknownError" }
}

enum HttpMethod: String {
	case GET
	case POST
	case PUT
	case DELETE
}

enum NetworkServerConfig: String {
	case dev = "https://devNewApp.shinhan.com/"
	case mock = "https://mock/"

	static var baseUrl = ""		// base url이 mutable임... 어떻게 수정하지

	static func getBaseUrl(by server: NetworkServerConfig) {
		switch server {
			case .dev:
				baseUrl = dev.rawValue
			case .mock:
				baseUrl = mock.rawValue
		}

	}
}
