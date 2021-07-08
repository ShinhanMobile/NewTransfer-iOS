//
//  RequestSample.swift
//  NewTransfer
//
//  Created by Jongho Lee on 2021/07/08.
//

import Foundation

class SampleTransferApi: NetworkApiInterface, RequestableBody {

	typealias Request = TransferRequest
	typealias Response = TransferResponse

	struct TransferRequest: ApiRequestable {
		let serviceCode: String
	}

	struct TransferResponse: ApiResponsive {
		let success: String
	}

	var body: TransferRequest

	required init(body: TransferRequest) {
		self.body = body
	}

	private let path: String = "transfer/sample"

	var url: URL {
		URL(string: NetworkServerConfig.baseUrl + path)!
	}	// Next Api가 REST 하지 않으면 path가 필요 없을듯

	var method: HttpMethod = .POST

	var responseSample: Data {
		Data(
			"""
			{
				"output": "success"
			}
			""".utf8
		)
	}
}

func sample() {
	NetworkServerConfig.getBaseUrl(by: .mock)	// 서버 mock으로 세팅
	let manager = NetworkManager.init()
	let requestBody = SampleTransferApi.TransferRequest(serviceCode: "SHB")
	let api = SampleTransferApi(body: requestBody)

	manager.fetch(by: api) { (result: Result<SampleTransferApi.Response, ApiError>) in
		switch result {
			case .success(let model):
				print(model)
			case .failure(let error):
				print(error)
		}
	}
}
