//
//  MainViewModel.swift
//  ARBUILDER
//
//  Created by belal medhat on 05/02/2023.
//

import Foundation
import SceneKit
 protocol ARCreatorViewModelProtocol:ObservableObject{
    var percantage:Double {get set}
    var scene: SCNScene {get set}
    var cameraNode: SCNNode? {get set}
    var message:String {get set}
    var showAlert:Bool {get set}
    var didFileSaved:Bool {get set}
    func setCameraNode()
    func readSavedARModel(fileSavedLocation:String,fileLocation:String)
    func generate3DObject(file:String,suggestedFileName:String,savedLocation:String)
}

 class ARCreatorViewModel:ARCreatorViewModelProtocol{
    @Published var scene: SCNScene = SCNScene()
    @Published var cameraNode: SCNNode?
    @Published var percantage: Double = 0.0
    @Published var message: String = ""
    @Published var showAlert:Bool = false
    @Published var didFileSaved:Bool = false
    
    
    private let objectRequesterManager:ObjectCaputureRequesterProtocol?
    init(objectRequesterManager: ObjectCaputureRequesterProtocol? = nil) {
        self.objectRequesterManager = objectRequesterManager
    }
    func generate3DObject(file:String,suggestedFileName:String = "newObject",savedLocation:String =         "\(FileManager.SearchPathDirectory.downloadsDirectory)") {
             objectRequesterManager?.requestObjCaputre(fileLocation: file, suggestedFileName: suggestedFileName, savedLocation: savedLocation,completion: { progress, msg in
                 DispatchQueue.main.async {
                     if let requestPercantage = progress {
                         self.percantage = requestPercantage
                     }
                    if let requestMsg = msg {
                        self.message = requestMsg
                        self.showAlert = true
                        if requestMsg == "Model Created Successfully" {
                            self.didFileSaved = true
                        }
                
                    }
                 }

          })
         
    }
     
     func readSavedARModel(fileSavedLocation:String,fileLocation:String) {
         do{
             cameraNode?.scale = SCNVector3(x: 0.3, y: 0.3, z: 0.3)
             scene = try SCNScene(url: URL(string: "\(fileSavedLocation == "" ? fileLocation:fileSavedLocation)/NewObject.usdz")!)
         }catch let error{
             print(error.localizedDescription)
         }
     }
     
     func setCameraNode(){
         self.scene.rootNode.childNode(withName: "camera1", recursively: false)
     }
}

