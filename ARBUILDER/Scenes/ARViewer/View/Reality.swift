//
//  Reality.swift
//  ARBUILDER
//
//  Created by belal medhat on 21/02/2023.
//

import SwiftUI
import RealityKit
import UniformTypeIdentifiers
struct ARViewContainer: NSViewRepresentable {
    let url:String?
    @Binding var didPressLoad:Bool
    @Binding var viewDidDisapper:Bool
    var anchor:AnchorEntity = AnchorEntity()
    private func getFile() -> (name: String, ext:String){
        let urlArray = url?.split(separator: "/")
        let file = urlArray?.last?.split(separator: ".")
        let fileName = file?.first
        let fileExtension = file?.last
        return ("\(fileName ?? "")","\(fileExtension ?? "")")
    }
    func makeNSView(context: Context) -> ARView {
        let view = ARView(frame: NSRect(x: 0, y: 0, width: NSScreen().frame.size.width, height: NSScreen().frame.size.height))
        view.environment.background = .color(.white)
        view.scene.addAnchor(anchor)
        if url != nil &&  didPressLoad == false && viewDidDisapper == true {
                    DispatchQueue.main.async {
                        if let entityLoaded = loadRealityComposerScene(filename: getFile().name, fileExtension: getFile().ext, sceneName: "") {
                            anchor.addChild(entityLoaded)
                            view.scene.addAnchor(entityLoaded)
                            viewDidDisapper = false
                        }
                    }
        }

        return view
    }
    
    func updateNSView(_ uiView: ARView, context: Context) {
        if didPressLoad {
            DispatchQueue.main.async {
                clearArView(uiView: uiView)
                if let entityLoaded = loadRealityComposerScene(filename: getFile().name, fileExtension: getFile().ext, sceneName: "") {
                    anchor.addChild(entityLoaded)
                    uiView.scene.addAnchor(entityLoaded)
                    didPressLoad = false
                }
            }
        }


    }
    func clearArView(uiView:ARView){
        anchor.children.removeAll()
        anchor.removeFromParent()
        uiView.scene.removeAnchor(anchor)
        uiView.scene.anchors.removeAll()
    }
    func loadRealityComposerScene (filename: String,
                                    fileExtension: String,
                                    sceneName: String) -> (Entity & HasAnchoring)? {

        guard let realitySceneURL = URL(string: url ?? "") else {
            return nil
        }
        let loadedAnchor = try? Entity.loadAnchor(contentsOf: realitySceneURL)

        return loadedAnchor
    }
    
}
