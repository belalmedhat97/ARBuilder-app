//
//  ARCreatorExtension.swift
//  ARBUILDER
//
//  Created by belal medhat on 25/03/2023.
//

import Foundation
import RealityKit

extension ARCreatorView {
    
    func addLoadingPercantageToGenerateBtn(percantage: Double) {
        print("percantage value")
        let progress = Int((percantage/1)*100)
        generateButtonTxt = "\(progress) % Loading"
        if progress == 100 {
            generateButtonTxt = "Completed"
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                generateButtonTxt = "Generate"
            }
            
        }
    }
    
    func isModelCreationInProgress() {
        if viewVM.percantage != 0.0 {
            let progress = Int((viewVM.percantage/1)*100)
            generateButtonTxt = "\(progress) % Loading"
        }
    }
    
    func isModelGenerated() {
        if viewVM.didFileSaved == false  {
            hideChangeLocationView = true
            
        }
    }
    
    private func checkLocationSubViewIsShown() {
        if changeDestination {
            changeDestination.toggle()
        }
    }
    func pressGenerate() {
        if fileSelectorVM.fileLocation != "" && generateButtonTxt == "Generate" {
            checkLocationSubViewIsShown()
            hideChangeLocationView = true
            viewVM.generate3DObject(file: fileSelectorVM.fileLocation, suggestedFileName: "NewObject", savedLocation: fileSaveLocation == "" ? fileSelectorVM.fileLocation:fileSaveLocation)

        }
    }
    func photoGrammertyEnabled() -> Bool {
        guard PhotogrammetrySession.isSupported else {
            return false
            // Inform user and don't proceed with reconstruction.
        }
        return true
    }
    
}
