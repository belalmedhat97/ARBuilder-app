//
//  ARBUILDERApp.swift
//  ARBUILDER
//
//  Created by belal medhat on 04/02/2023.
//

import SwiftUI
@main
struct ARBUILDERApp: App {

    var body: some Scene {
        WindowGroup {
            
            NavigationSplitView {
                SidebarNavigation()
            } detail: {
                
            }.frame(minWidth: 800, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity, alignment: .center)
        }
    }
    //MARK: - define the app sidebar navigation here
    private func toggleSidebar() { // 2
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
