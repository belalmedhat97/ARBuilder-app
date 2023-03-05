//
//  ARViewerViewModel.swift
//  ARBUILDER
//
//  Created by belal medhat on 15/02/2023.
//

import Foundation
import SceneKit
import UniformTypeIdentifiers
protocol ARViewerViewModelProtocol:ObservableObject{
    
    var didPressLoad:Bool {get set}
    var scene:SCNScene {get set}
    var cameraNode:SCNNode? {get set}
    func readSavedARModel(fileLocation:String,type:UTType)
    func setCameraNode()
}

class ARViewerViewModel:NSObject, ARViewerViewModelProtocol{
        
   @Published var didPressLoad: Bool = false
   @Published var scene: SCNScene = SCNScene()
   @Published var cameraNode: SCNNode?
    override init() {
    }
    
    func readSavedARModel(fileLocation:String,type:UTType) {
        DispatchQueue.main.async {
            do{
                if type != .realityFile {
                    let loadedScene = try SCNScene(url: URL(string: "\(fileLocation)")!)
                    loadedScene.background.contents = NSColor.white
                    self.scene = loadedScene
                } else {
                    self.didPressLoad = true
                }
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
    func setCameraNode(){
        self.scene.rootNode.childNode(withName: "camera", recursively: false)
    }
}
