//
//  SidebarNavigation.swift
//  ARBUILDER
//
//  Created by belal medhat on 15/02/2023.
//

import SwiftUI
import SceneKit
enum screenName: String,Identifiable,CaseIterable  {
    var id : String { UUID().uuidString }
    case creator = "AR Creator"
    case viewer = "AR Viewer"

}
struct SidebarNavigation: View {
    @State var selection = Set<screenName>()
    var viewerVM = ARViewerViewModel()
    var creatorVM = ARCreatorViewModel(objectRequesterManager: ObjectCaptureRequester())
    @StateObject var fileSelectorVMFile = FileSelectorViewModel(panelRequesterManager: FileSelectorDependecy(fType: .file))
    @StateObject var fileSelectorVMFolder = FileSelectorViewModel(panelRequesterManager: FileSelectorDependecy(fType: .folder))

    var body: some View {
        List(selection: $selection) {
            ForEach(screenName.allCases,id:
                        \.self) { view in
                NavigationLink(view.rawValue) {
                    
                    goToDestination(view: view).frame(minWidth: 750, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity, alignment: .center)
                    
                }
            }



        }.listStyle(.sidebar).frame(minWidth: 100, maxWidth: 150, minHeight: 600, maxHeight: .infinity, alignment: .center).onAppear(){
            DispatchQueue.main.async {
                selection.insert(.creator)
            }
        }
    }
    @ViewBuilder func goToDestination(view:screenName) -> some View {
         switch view {
         case .creator:  ARCreatorView(viewVM: creatorVM).environmentObject(fileSelectorVMFolder)
         case .viewer:  ARViewerView(viewVM: viewerVM).environmentObject(fileSelectorVMFile)
         }
     }
}

struct SidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        SidebarNavigation()
    }
}

