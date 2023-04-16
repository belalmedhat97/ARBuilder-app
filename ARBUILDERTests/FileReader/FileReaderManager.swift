//
//  FileReader.swift
//  ARBUILDERTests
//
//  Created by belal medhat on 09/04/2023.
//

import Foundation
class FileReaderManager {
    static let shared:FileReaderManager = FileReaderManager()
    private init () {}
    
    func getLocalModel(fileName:String,fileType:String) ->  URL? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: fileName, ofType: fileType) else {
            // File not found ... oops
            return nil
        }
        let modelURL = URL(fileURLWithPath: path)
        return modelURL
    }
}

enum FileNames {
    
}
