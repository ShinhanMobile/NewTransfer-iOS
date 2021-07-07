//
//  TransferManager+DI.swift
//  NewTransfer
//
//  Created by Jongho Lee on 2021/07/07.
//

import Foundation

enum DefaultAuthType {
	case accountPassword
	case loginAuth
}

enum SecurityAuthType {
	case otp
	case motp
	case securityCard
}

protocol AuthManagerProtocol {
	func executeDefaultAuth() -> Bool
}

class TransferManager {
	static let shared = TransferManager()

	private init() {}

	var trxKey: String?							// 거래 일련번호
	var defaultAuthType: DefaultAuthType?		// 기본 인증 타입: 계좌 비밀번호 or 로그인 인증
	var securityAuthType: SecurityAuthType?		// 보안매체 인증 타입
	var transferAmount: String?					// 이체 금액

	func getTrxKey() -> String? {
		return trxKey
	}
}

extension TransferManager: AuthManagerProtocol {
	func executeDefaultAuth() -> Bool {
		if trxKey == nil {
			return false
		} else {
			return true
		}
	}
}

// ------ Dependency Injection & Inversion of Control

class SampleTransferInteractor {

	var transferManager: AuthManagerProtocol

	init(transferManager: AuthManagerProtocol) {
		self.transferManager = transferManager
	}

	func transferExecute() -> Bool {
		transferManager.executeDefaultAuth() ? print("이체 성공 :)") : print("이체 실패 :(")
		return transferManager.executeDefaultAuth()
	}
}
