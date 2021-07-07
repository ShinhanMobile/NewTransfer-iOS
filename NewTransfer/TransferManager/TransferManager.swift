//
//  TransferManager.swift
//  NewTransfer
//
//  Created by Jongho Lee on 2021/07/07.
//

import UIKit

// 수취 조회에서 어떤 인증 & 보안매체 인증 & 추가인증 여부 가 내려온다.
// 1 - 이체에서 singletone 을 대체할 방안
// 2 - 이체 프로세스를 어떻게 관리할 것인가(작업 큐, 의존성 주입?)

enum DefaultAuthType {
	case accountPassword
	case loginAuth
}

enum SecurityAuthType {
	case otp
	case motp
	case securityCard
}

class TransferManager {
	static let shared = TransferManager()

	init() {}
	// private init() {}	// Test용 stub을 만드려면 private을 사용 못함

	var trxKey: String?							// 거래 일련번호
	var defaultAuthType: DefaultAuthType?		// 기본 인증 타입: 계좌 비밀번호 or 로그인 인증
	var securityAuthType: SecurityAuthType?		// 보안매체 인증 타입
	var transferAmount: String?					// 이체 금액

	func getTrxKey() -> String? {
		return trxKey
	}
}

#if TEST
class TransferManagerStub: TransferManager {
	static let sharedStub = TransferManagerStub()

	override init() {}

//	var trxKey: String?							// 거래 일련번호
//	var defaultAuthType: DefaultAuthType?		// 기본 인증 타입: 계좌 비밀번호 or 로그인 인증
//	var securityAuthType: SecurityAuthType?		// 보안매체 인증 타입
//	var transferAmount: String?					// 이체 금액

	override func getTrxKey() -> String? {
		return "TEST"
	}
}
#endif

protocol TransferManagerInjector {
	var transferManager: TransferManager { get }
}

extension TransferManagerInjector {
	var transferManager: TransferManager {
		#if TEST
		return TransferManagerStub.shared
		#else
		return TransferManager.shared
		#endif
	}

//	#if TEST
//	func resetStub() {
//		transferManager = TransferManagerStub.shared
//	}
//	#endif
}


class SampleViewController: UIViewController {
}

extension SampleViewController: TransferManagerInjector {
	func authSample() -> Bool {
		if transferManager.getTrxKey() == "SHB" {
			return true
		} else {
			return false
		}
	}
}
