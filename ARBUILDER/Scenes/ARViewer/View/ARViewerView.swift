//
//  ARViewer.swift
//  ARBUILDER
//
//  Created by belal medhat on 15/02/2023.
//

import SwiftUI
import SceneKit
import RealityKit
import UniformTypeIdentifiers
struct ARViewerView<VM>: View where VM:ARViewerViewModelProtocol {
    @StateObject var fileSelectorVM:FileSelectorViewModel
    @State var fileLocation:String = ""
    @State var showAlert:Bool = false
    @StateObject var viewVM:VM
    @AppStorage("viewDidDisappear") var viewDidDisappear: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack(){
                    VStack(spacing:20) {
                        HStack(alignment:.bottom){
                            fileSelectorSubView(title: "Select Model Location", fileLocation: $fileLocation, fileFormat: $fileSelectorVM.fileFormat, fileSelectorVM: fileSelectorVM)
                            
                        }
                                            
                        Button {
                            if fileSelectorVM.fileLocation != "" && fileSelectorVM.fileFormat != nil {
                                viewVM.readSavedARModel(fileLocation: fileSelectorVM.fileLocation, type: fileSelectorVM.fileFormat ?? .fileURL)
                            } else {
                                showAlert = true
                            }

                        } label: {
 
                                Text("Load").frame(width: 130, height: 40, alignment: .center).foregroundColor(Color.black).bold()
                            
                            
                        }.buttonStyle(.plain).focusable(false).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black,lineWidth: 3))
                        GeometryReader { innerGeo in
                            ZStack(){
                                if fileSelectorVM.fileLocation != "" {
                                    if fileSelectorVM.fileFormat == .realityFile {
                                        ARViewContainer(url: fileSelectorVM.fileLocation, didPressLoad: $viewVM.didPressLoad, viewDidDisapper: $viewDidDisappear).ignoresSafeArea()
                                    }else{
                                        
                                        SceneView(
                                            scene: viewVM.scene,
                                            pointOfView: viewVM.cameraNode,
                                            options: [ .autoenablesDefaultLighting, .temporalAntialiasingEnabled,.allowsCameraControl,.rendersContinuously ],delegate: viewVM as? SCNSceneRendererDelegate
                                            
                                        ).background(Color.white).edgesIgnoringSafeArea(.all)
                                    }
                                    
                                    
                                    
                                }
                            }


                        }.background(Color.white).cornerRadius(20).padding(60)
                        
                        
                    }
                    

            }.frame(width: geo.size.width,height: geo.size.height,alignment: .center)
        }.alert("Select Model Location", isPresented: $showAlert) {
            // add buttons here
            Button("OK", role: .cancel) {
                showAlert = false
            }
        } message: {
            Text("")
        }
        .background(LinearGradient.gradientColor).onAppear(){
            viewVM.setCameraNode()
        }.onDisappear(){
            viewDidDisappear = true
        }
    }


}

struct ARViewerView_Previews: PreviewProvider {
    static var previews: some View {
        ARViewerView(fileSelectorVM: FileSelectorViewModel(panelRequesterManager: FileSelectorDependecy(fType: .folder)), viewVM: ARViewerViewModel())
    }
}

