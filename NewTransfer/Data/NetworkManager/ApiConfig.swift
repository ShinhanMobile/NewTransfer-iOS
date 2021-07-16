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
//	#if DEBUG
	var mockResponse: Data { get }	// Mock 통신 용
//	#endif
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

enum BaseServer: String {
	case dev = "https://devNewApp.shinhan.com/"
	case mock = "https://mock/"
	case test = ""
}

struct NetworkServerConfig {

	static var baseUrl = ""		// base url이 mutable임... 어떻게 수정하지
	static var server: BaseServer = .dev

	static func setBaseUrl(by server: BaseServer) {
		baseUrl = server.rawValue
		NetworkServerConfig.server = server
	}
}
