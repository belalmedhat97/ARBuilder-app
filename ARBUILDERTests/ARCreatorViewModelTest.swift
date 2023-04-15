//
//  ARCreatorViewModel.swift
//  ARBUILDERTests
//
//  Created by belal medhat on 10/04/2023.
//

import XCTest
import Combine
import SwiftUI
@testable import ARBUILDER

final class ARCreatorViewModelTest: XCTestCase {
    var viewModel:ARCreatorViewModel?
    private var cancellableBag = Set<AnyCancellable>()

    override func setUp() {
        viewModel = ARCreatorViewModel()
        
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
            XCTAssertNotEqual(initScene, newScene)
            exp.fulfill()
        }.store(in: &cancellableBag)
        // when
        viewModel?.readSavedARModel(fileSavedLocation: path?.absoluteString ?? "", fileLocation: path?.absoluteString ?? "")
        waitForExpectations(timeout: 10)


    }

}
