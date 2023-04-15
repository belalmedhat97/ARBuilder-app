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
    
    var willSetARView:Bool {get set}
    var scene:SCNScene {get set}
    var cameraNode:SCNNode? {get set}
    func readSavedARModel(fileLocation:String,type:UTType)
    func setCameraNode()
}

class ARViewerViewModel:NSObject, ARViewerViewModelProtocol{
        
   @Published var willSetARView: Bool = false
   @Published var scene: SCNScene = SCNScene()
   @Published var cameraNode: SCNNode?
    override init() {
    }
    
    func readSavedARModel(fileLocation:String,type:UTType) {
        DispatchQueue.main.async {
                if type != .realityFile {
                    self.setSceneKitModel(location: fileLocation)
                } else {
                    self.willSetARView = true
                }
        }
    }
    func setCameraNode(){
        self.scene.rootNode.childNode(withName: "camera", recursively: false)
    }
    
    private func setSceneKitModel(location:String){
        do {
            let loadedScene = try SCNScene(url: URL(string: "\(location)")!)
            loadedScene.background.contents = NSColor.white
            self.scene = loadedScene
        } catch let error {
            print(error.localizedDescription)
        }

    }
}
