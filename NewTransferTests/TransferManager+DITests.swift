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

	var sut: SampleTransferInteractor!

	override func setUp() {
		super.setUp()

	}

	func testByRealTransferManager() {
		// given
		sut = .init(transferManager: TransferManager.shared)

		// when
		TransferManager.shared.trxKey = "trxKey"
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
		sut = .init(transferManager: TransferManagerSpy())

		// when
		let result = sut.transferExecute()

		// then
		XCTAssertTrue(result)
	}
}
