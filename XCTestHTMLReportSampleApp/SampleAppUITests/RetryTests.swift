//
//  FourthSuite.swift
//
//
//  Created by Tyler Vick on 12/20/21.
//

import Foundation
import XCTest

class RetryTests: XCTestCase {
    private var filePath: URL {
        let sharedDir = NSTemporaryDirectory()
        let persistentFileName = "will_succeed"
        return URL(fileURLWithPath: sharedDir).appendingPathComponent(persistentFileName)
    }

    private func writeFile() throws {
        FileManager.default.createFile(atPath: filePath.path, contents: Data())
    }

    private func shouldSucceed() -> Bool {
        FileManager.default.fileExists(atPath: filePath.path)
    }

    func testJustPass() {
        XCTAssertTrue(true)
    }

    func testJustFail() {
        XCTAssertTrue(false)
    }

    func testInUnknownState() {
        XCTExpectFailure("Expecting a failure here") {
            XCTAssertTrue(false)
        }
    }

    // First iteration will always fail, retry will succeed
    func testRetryOnFailure() throws {
        try XCTContext.runActivity(named: "Retryable Activity") { _ in
            if shouldSucceed() {
                try FileManager.default.removeItem(at: filePath)
            } else {
                try writeFile()
                XCTFail()
            }
        }
    }
}
