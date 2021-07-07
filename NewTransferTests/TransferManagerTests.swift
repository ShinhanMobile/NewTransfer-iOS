//
//  TransferManagerTests.swift
//  NewTransferTests
//
//  Created by Jongho Lee on 2021/07/07.
//

import Foundation

import XCTest
@testable import NewTransfer

class TransferManagerTests: XCTestCase {

	var transferManagerStub: TransferManagerStub = TransferManagerStub()
	var sampleViewController: SampleViewController = SampleViewController()

	override func setUp() {
		super.setUp()
		sampleViewController.transferManager = self.transferManagerStub
	}
}
