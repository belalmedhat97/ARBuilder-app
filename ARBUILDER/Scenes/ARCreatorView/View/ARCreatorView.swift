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
    @EnvironmentObject var fileSelectorVM:FileSelectorViewModel
    
//    @StateObject var fileSelectorChangeLocationVMFolder = FileSelectorViewModel(panelRequesterManager: FileSelectorDependecy(fType: .folder))

    @State var fileLocation:String = ""
    @State var fileSaveLocation:String = ""
    @State var changeDestination:Bool = false
    @State var generateButtonTxt:String = "Generate"
    @State var fileAfterSaving:URL?
    @State var trimPercantage:CGFloat = 0.0
    @State var suggestedFileNames:String = "MyName"
    @StateObject var viewVM:VM
    var body: some View {
        GeometryReader { geo in
            ZStack(){
                if checkPhotoGrammerty() == true {
                    VStack(spacing:20) {
                        HStack(alignment:.bottom){
                            fileSelectorSubView(title: "Select Folder Location", fileLocation: $fileLocation, fileFormat: $fileSelectorVM.fileFormat)
                            
                        }
                        if fileSelectorVM.fileLocation != "" {
                            if changeDestination {
                                FileLocationChangeSubView(title: "Select Save Destination Location", fileLocation: $fileSaveLocation).padding(.top,30)
                            }
                            HStack(spacing:10){
                                Text("Hint: the default save destination location is where you select the folder containg images, you can change it").foregroundColor(.black).opacity(0.5)
                                Button {
                                    changeDestination.toggle()
                                    
                                } label: {
                                    Image(systemName: "folder.circle.fill").resizable().frame(width: 30,height: 30,alignment: .center).foregroundColor(.black)
                                }.padding().buttonStyle(.plain)
                                
                            }
                            
                        }
                        
                        
                        Button {
                            if fileSelectorVM.fileLocation != "" && generateButtonTxt == "Generate" {
                                viewVM.generate3DObject(file: fileSelectorVM.fileLocation, suggestedFileName: "NewObject", savedLocation: fileSaveLocation == "" ? fileSelectorVM.fileLocation:fileSaveLocation)

                            }
                        } label: {
                            ZStack(alignment:.leading){

                                LeftToRightFillShape(progress: trimPercantage).frame(width: 130, height: 40, alignment: .center).cornerRadius(20)
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
                print("percantage value")
                let progress = Int((newValue/1)*100)
                withAnimation {
                    trimPercantage = CGFloat(newValue)
                }
                generateButtonTxt = "\(progress) % Loading"
                if progress == 100 {
                    generateButtonTxt = "Completed"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                        generateButtonTxt = "Generate"
                            trimPercantage = 0.0
                    }

                }
            }
        }
        .background(LinearGradient.gradientColor).onAppear(){
            viewVM.setCameraNode()
            if viewVM.percantage != 0.0 {
                let progress = Int((viewVM.percantage/1)*100)
                withAnimation {
                    trimPercantage = CGFloat(viewVM.percantage)
                }
                generateButtonTxt = "\(progress) % Loading"
            }
        }.alert(viewVM.message, isPresented: $viewVM.showAlert) {
            // add buttons here
            Button("OK", role: .cancel) {
                viewVM.showAlert = false
            }
        } message: {
            Text("")
        }.onChange(of: viewVM.didFileSaved) { newValue in
            viewVM.readSavedARModel(fileSavedLocation: fileSaveLocation, fileLocation: fileLocation)
        }
    }
    func checkPhotoGrammerty() -> Bool {
        guard PhotogrammetrySession.isSupported else {
            return false
            // Inform user and don't proceed with reconstruction.
        }
        return true
    }

}

struct ARCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        ARCreatorView(viewVM: ARCreatorViewModel(objectRequesterManager: ObjectCaptureRequester()))
    }
}

