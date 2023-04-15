//
//  ARViewModelTest.swift
//  ARBUILDERTests
//
//  Created by belal medhat on 08/04/2023.
//

import XCTest
import Combine
@testable import ARBUILDER
 
final class ARViewerViewModelTest: XCTestCase {
    var viewModel:ARViewerViewModel?
    private var cancellableBag = Set<AnyCancellable>()

    override func setUp() {
        viewModel = ARViewerViewModel()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        viewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadUsdzFile() {
        let exp = expectation(description: "select file")
        // given
        let path = FileReaderManager.shared.getLocalModel(fileName: "sneaker_airforce", fileType: "usdz")
        let initScene = viewModel?.scene
        viewModel?.$scene.dropFirst().sink { _ in
        } receiveValue: { newScene in
            // then
            XCTAssertNotEqual(initScene, newScene)
            exp.fulfill()
        }.store(in: &cancellableBag)
        viewModel?.readSavedARModel(fileLocation: path?.absoluteString ?? "", type: .usdz)

        waitForExpectations(timeout: 10)


    }
    func testLoadRealityFile() {
        let exp = expectation(description: "select file")
        // given
        let path = FileReaderManager.shared.getLocalModel(fileName: "CosmonautSuit_en", fileType: "reality")
        viewModel?.$willSetARView.dropFirst().sink { _ in
        } receiveValue: { loadedAR in
            // then
            XCTAssertTrue(loadedAR,"file is type of reality")
            exp.fulfill()
        }.store(in: &cancellableBag)
        // when
        viewModel?.readSavedARModel(fileLocation: path?.absoluteString ?? "", type: .realityFile)

        waitForExpectations(timeout: 10)


    }
}
