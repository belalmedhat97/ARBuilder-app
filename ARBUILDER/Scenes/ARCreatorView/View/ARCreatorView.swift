//
//  ContentView.swift
//  ARBUILDER
//
//  Created by belal medhat on 04/02/2023.
//

import SwiftUI
import SceneKit
import RealityKit
struct ARCreatorView<VM>: View where VM:ARCreatorViewModelProtocol {
    
    @ObservedObject var fileSelectorVM:FileSelectorViewModel
    @ObservedObject var fileChangeLocationVM:FileSelectorViewModel
    @State var fileLocation:String = ""
    @State var fileSaveLocation:String = ""
    @State var changeDestination:Bool = false
    @State var generateButtonTxt:String = "Generate"
    @State var hideChangeLocationView:Bool = false
    @StateObject var viewVM:VM
    var body: some View {
        GeometryReader { geo in
            ZStack(){
                if photoGrammertyEnabled() {
                    VStack(spacing:20) {
                        HStack(alignment:.bottom){
                            fileSelectorSubView(title: "Select Folder Location", fileLocation: $fileLocation, fileFormat: $fileSelectorVM.fileFormat, fileSelectorVM: fileSelectorVM)
                            if changeDestination {
                                fileSelectorSubView(title: "Select Model Location", fileLocation: $fileChangeLocationVM.fileLocation, fileFormat: $fileSelectorVM.fileFormat, fileSelectorVM: fileChangeLocationVM)
                            }
                            
                        }
                        if fileSelectorVM.fileLocation != "" && hideChangeLocationView == false {
                            HStack(spacing:10){
                                Text("Hint: the default save destination location is where you select the folder containing images, you can change it").foregroundColor(.black).opacity(0.5)
                                Button {
                                    changeDestination.toggle()
                                    
                                } label: {
                                    Image(systemName: "folder.circle.fill").resizable().frame(width: 30,height: 30,alignment: .center).foregroundColor(.black)
                                }.padding().buttonStyle(.plain)
                                
                            }
                            
                        }
                        
                        
                        Button {
                            pressGenerate()
                        } label: {
                            ZStack(alignment:.leading){

                                LeftToRightFillShape(progress: CGFloat(viewVM.percantage)).frame(width: 130, height: 40, alignment: .center).cornerRadius(20)
                                Text(generateButtonTxt).frame(width: 130, height: 40, alignment: .center).foregroundColor(Color.black).bold()
                            }

                        }.buttonStyle(.plain).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black,lineWidth: 3)).focusable(false)
                        GeometryReader { innerGeo in
                            ZStack(){
                                SceneView(
                                    scene: viewVM.scene,
                                    pointOfView: viewVM.cameraNode,
                                        options: [ .autoenablesDefaultLighting, .temporalAntialiasingEnabled,.allowsCameraControl,.rendersContinuously ]
                                ).background(Color.white)
                            }
                        }.background(Color.white).cornerRadius(20).padding(60)


                    }

                } else {
                    Text("Sorry, Object Capture is no suported on your device ").foregroundColor(.gray).bold()

                }
            }.frame(width: geo.size.width,height: geo.size.height,alignment: .center).onChange(of: viewVM.percantage) { newValue in
                addLoadingPercantageToGenerateBtn(percantage:newValue)
            }
        }
        .background(LinearGradient.gradientColor).onAppear(){
            viewVM.setCameraNode()
            isModelCreationInProgress()
            isModelGenerated()
        }.alert(viewVM.message, isPresented: $viewVM.showAlert) {
            // add buttons here
            Button("OK", role: .cancel) {
                viewVM.showAlert = false
            }
        } message: {
            Text("")
        }.onChange(of: viewVM.didFileSaved) { newValue in
            viewVM.readSavedARModel(fileSavedLocation: fileSaveLocation, fileLocation: fileLocation)
        }.onChange(of: fileSelectorVM.fileLocation) { newValue in
            hideChangeLocationView = false
        }
    }
}

struct ARCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        ARCreatorView(fileSelectorVM: FileSelectorViewModel(),fileChangeLocationVM: FileSelectorViewModel(),viewVM: ARCreatorViewModel(objectRequesterManager: ObjectCaptureRequester()))
    }
}

