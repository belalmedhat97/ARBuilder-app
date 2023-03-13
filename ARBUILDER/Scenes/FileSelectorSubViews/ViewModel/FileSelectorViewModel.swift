//
//  FileSelectorViewModel.swift
//  ARBUILDER
//
//  Created by belal medhat on 06/02/2023.
//

import Foundation
import Combine
import UniformTypeIdentifiers
protocol FileSelectorViewModelProtocol:ObservableObject{
    var fileLocation:String {get set}
    var fileFormat:UTType? {get set}
    func requestOpenPanel() 
}
class FileSelectorViewModel:FileSelectorViewModelProtocol{
    @Published var fileLocation:String = ""
    @Published var fileFormat:UTType?
    @Published var panelRequesterManager:(any FileSelectorDProtocol)?
    init(panelRequesterManager: (any FileSelectorDProtocol)? = nil) {
        self.panelRequesterManager = panelRequesterManager
    }
    func requestOpenPanel() {
        panelRequesterManager?.pickFile(completion: { [weak self] fileURL,format  in
            self?.fileLocation = fileURL
            if let formatType = format {
                self?.fileFormat = formatType
            }
        })
    }
    deinit{
        print("memory release")
    }

}
