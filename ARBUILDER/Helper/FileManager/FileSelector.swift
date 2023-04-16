//
//  FileSelector.swift
//  ARBUILDER
//
//  Created by belal medhat on 04/02/2023.
//

import SwiftUI
import UniformTypeIdentifiers
enum SelectionType{
    case file
    case folder
}
protocol FileSelectorProtocol{
    func pickFile(completion:@escaping(_ filePath:String, _ fileForamt: UTType?)->())
}
class FileSelector:FileSelectorProtocol{
    
    private let myFileOpener = NSOpenPanel()
    private let typeOfFile:SelectionType!
    private var fileExtension:UTType = .usdz
    init(fType:SelectionType){
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
class FileSelectorMock:FileSelectorProtocol{
    private let typeOfFile:SelectionType!
    private var fileExtension:UTType = .usdz
    private var fileURL:URL!
    init(fType:SelectionType,filePath:URL){
        typeOfFile = fType
        fileURL = filePath
    }
    func pickFile(completion:@escaping(_ filePath:String, _ fileForamt: UTType?)->()) {
        if typeOfFile == .file {
            if let fileType = UTType(filenameExtension: fileURL?.pathExtension ?? "") {
                self.fileExtension = fileType
                completion(fileURL?.path ?? "", self.fileExtension)
            }else{
                completion(fileURL?.path ?? "", nil)
            }
        } else {
            completion(fileURL?.path ?? "", nil)

        }

        
        
    }
    
    deinit {
        print("release memory")
    }
    
}
