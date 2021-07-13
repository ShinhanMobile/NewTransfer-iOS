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

// 이체 관련 데이터 저장소(수취인 조회 결과)
class TransferDataRepository {
	static let shared = TransferDataRepository()

	private init() {}

	var trxKey: String?							// 거래 일련번호
	var defaultAuthType: DefaultAuthType?		// 기본 인증 타입: 계좌 비밀번호 or 로그인 인증
	var securityAuthType: SecurityAuthType?		// 보안매체 인증 타입
	var transferAmount: String?					// 이체 금액
}

protocol TransferDataRepositoryInjector {
	var transferDataRepository: TransferDataRepository { get }
}

extension TransferDataRepositoryInjector {	// 저장소 사용시 주입 받기
	var transferDataRepository: TransferDataRepository {
		return TransferDataRepository.shared
	}
}

protocol AuthManagerProtocol {
	func executeDefaultAuth() -> Bool
}

class TransferAuthManager: TransferDataRepositoryInjector, AuthManagerProtocol {
	func executeDefaultAuth() -> Bool {
		if transferDataRepository.trxKey == nil {
			return false
		} else {
			return true
		}
	}
}

// ------ Dependency Injection & Inversion of Control

class SampleTransferUseCase {

	var transferAuthManager: AuthManagerProtocol

	init(transferAuthManager: AuthManagerProtocol) {
		self.transferAuthManager = transferAuthManager
	}

	func transferExecute() -> Bool {
		transferAuthManager.executeDefaultAuth() ? print("이체 성공 :)") : print("이체 실패 :(")
		return transferAuthManager.executeDefaultAuth()
	}
}
