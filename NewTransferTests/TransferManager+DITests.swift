//
//  TransferManager+DITests.swift
//  NewTransferTests
//
//  Created by Jongho Lee on 2021/07/07.
//
import Foundation

import XCTest
@testable import NewTransfer

class TransferManager_DITests: XCTestCase {

	var sut: SampleTransferUseCase!

	override func setUp() {
		super.setUp()

	}

	class TransferAuthManagerSpy: TransferDataRepositoryInjector, AuthManagerProtocol {
		func executeDefaultAuth() -> Bool {
			return true
		}
	}

	func testByRealTransferManager() {
		// given
		sut = .init(transferAuthManager: TransferAuthManager())

		// when
		TransferDataRepository.shared.trxKey = "trxKey"
		let result = sut.transferExecute()

		// then
		XCTAssertTrue(result)
	}

	class TransferManagerSpy: AuthManagerProtocol {
		func executeDefaultAuth() -> Bool {
			return true
		}
	}

	func testByTransferManagerStub() {
		// given
		sut = .init(transferAuthManager: TransferAuthManagerSpy())

		// when
		let result = sut.transferExecute()

		// then
		XCTAssertTrue(result)
	}
}
