//
//  FileSelectorViewModelTest.swift
//  ARBUILDERTests
//
//  Created by belal medhat on 15/04/2023.
//

import XCTest
import Combine
@testable import ARBUILDER
final class FileSelectorViewModelTest: XCTestCase {

    var viewModel:FileSelectorViewModel?
    private var cancellableBag = Set<AnyCancellable>()
    
    override func setUp() {
        // given
    viewModel = FileSelectorViewModel(panelRequesterManager: FileSelectorMock(fType:.file,filePath:FileReaderManager.shared.getLocalModel(fileName: "sneaker_airforce", fileType: "usdz")!))
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        viewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFilePicker(){
        let exp = expectation(description: "select file")
        let exp2 = expectation(description: "get format")

        // when
        viewModel?.$fileLocation.dropFirst().sink { _ in
        } receiveValue: { location in
            // then
            XCTAssertNotEqual(location, "","got file location")
            exp.fulfill()
        }.store(in: &cancellableBag)
        
        // when
        viewModel?.$fileFormat.dropFirst().sink { _ in
        } receiveValue: { format in
            // then
            XCTAssertNotNil(format,"has format")
            exp2.fulfill()
        }.store(in: &cancellableBag)

        
        viewModel?.requestOpenPanel()
        waitForExpectations(timeout: 5)

    }

}
