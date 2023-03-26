//
//  FileSelector.swift
//  ARBUILDER
//
//  Created by belal medhat on 04/02/2023.
//

import SwiftUI
import UniformTypeIdentifiers
enum FileType{
    case file
    case folder
}
protocol FileSelectorDProtocol{
    func pickFile(completion:@escaping(_ filePath:String, _ fileForamt: UTType?)->())
}
class FileSelectorDependecy:FileSelectorDProtocol{
    
    private let myFileOpener = NSOpenPanel()
    private let typeOfFile:FileType!
    private var fileExtension:UTType = .usdz
    init(fType:FileType){
        typeOfFile = fType
        myFileOpener.worksWhenModal = true
        myFileOpener.allowsMultipleSelection = false
        switch fType {
        case .file:
            myFileOpener.prompt = "Select File"
            myFileOpener.allowsOtherFileTypes = true
            myFileOpener.allowedContentTypes = [.usdz,.realityFile,.usd,.sceneKitScene]
            myFileOpener.canChooseFiles = true
            myFileOpener.canChooseDirectories = false
        default:
            myFileOpener.prompt = "Select Folder"
            myFileOpener.canChooseDirectories = true
            myFileOpener.canCreateDirectories = true
            myFileOpener.canChooseFiles = false
            myFileOpener.nameFieldStringValue = "New Object"
            myFileOpener.nameFieldLabel = "File Name"
            


        }
    }
    func pickFile(completion:@escaping(_ filePath:String, _ fileForamt: UTType?)->()) {
        
        myFileOpener.begin {(result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let selectedPath = self.myFileOpener.url!.path
                print(selectedPath)
                if self.typeOfFile == .file {
                    if let fileType = UTType(filenameExtension: self.myFileOpener.url?.pathExtension ?? "") {
                        self.fileExtension = fileType
                        completion(selectedPath, self.fileExtension)
                    }else{
                        completion(selectedPath, nil)
                    }
                }else if self.typeOfFile ==  .folder {
                    completion(selectedPath, nil)
                }
                
            }
        }
        
        
    }
    deinit {
        print("release memory")
    }
    
}
