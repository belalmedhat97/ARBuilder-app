//
//  ARBUILDERTests.swift
//  ARBUILDERTests
//
//  Created by belal medhat on 04/02/2023.
//

import XCTest
@testable import ARBUILDER
import UniformTypeIdentifiers

final class FileSelectorTest: XCTestCase {
    var fileSelectorManager:FileSelectorProtocol!


    override func setUp() {
        fileSelectorManager = FileSelectorMock(fType:.file,filePath:FileReaderManager.shared.getLocalModel(fileName: "sneaker_airforce", fileType: "usdz")!)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        fileSelectorManager = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testFileSelection(){
        let exp = expectation(description: "select file")
        // when
        fileSelectorManager.pickFile { path, type in
        // then
            XCTAssertNotNil(path)
            XCTAssertEqual(type, UTType.usdz)
            exp.fulfill()

        }
        waitForExpectations(timeout: 5)

    }
}
