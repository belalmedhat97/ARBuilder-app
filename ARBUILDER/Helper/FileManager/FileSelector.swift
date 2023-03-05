//
//  FileSelector.swift
//  ARBUILDER
//
//  Created by belal medhat on 04/02/2023.
//

import SwiftUI
import UniformTypeIdentifiers
enum FileType{
    case image
    case file
    case folder
}
protocol FileSelectorDProtocol{
    func pickFile(completion:@escaping(_ filePath:String, _ fileForamt: UTType?)->())
//    var fileDataImage:NSImage {get}
}
class FileSelectorDependecy:FileSelectorDProtocol{
//    @Published var fileDataImage: NSImage = NSImage(named: "white")!
    
    private let myFileOpener = NSOpenPanel()
    private let typeOfFile:FileType!
    var fileExtension:UTType = .usdz
    init(fType:FileType){
        // define button select text
        typeOfFile = fType
        let TypeText = fType == .image ? "Image":"File"
        myFileOpener.prompt = "Select \(TypeText)"
        
        myFileOpener.worksWhenModal = true
        myFileOpener.canCreateDirectories = true
        myFileOpener.canChooseDirectories = true
        myFileOpener.allowsMultipleSelection = false
        
        // define the files types allowed for upload
        switch fType {
        case .file:
            myFileOpener.allowsOtherFileTypes = true
            myFileOpener.allowedContentTypes = [.usdz,.realityFile,.usd,.sceneKitScene]
            myFileOpener.canChooseFiles = true

        case .image:
                myFileOpener.allowedContentTypes = [.png,.jpeg,.gif,.bmp]
        default:
//            myFileOpener.allowsOtherFileTypes = true
            myFileOpener.canChooseFiles = false


        }
//        if fType == .file {
//            myFileOpener.allowsOtherFileTypes = true
//            myFileOpener.allowedContentTypes = [.usdz,.realityFile,.usd]
//
//        }else{
//            myFileOpener.allowedContentTypes = [.png,.jpeg,.gif,.bmp]
//
//        }
    }
    func pickFile(completion:@escaping(_ filePath:String, _ fileForamt: UTType?)->()) {
        
        myFileOpener.begin {(result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let selectedPath = self.myFileOpener.url!.path
                print(selectedPath)
                if self.typeOfFile == .file {
                    let fileType = UTType(filenameExtension: self.myFileOpener.url?.pathExtension ?? "")
                    self.fileExtension = fileType ?? .usdz
                    completion(selectedPath, self.fileExtension)
                }else if self.typeOfFile ==  .folder {
                    completion(selectedPath, nil)

//                    return ""
//                    self.fileDataImage = NSImage(contentsOfFile:selectedPath)!
                }else{
                    
                }
                
            }
        }
        
        
    }
    deinit {
        print("release memory")
//        fileDataFile = ""
//        fileDataImage = NSImage(named: "white")!
    }
    
}
