//
//  FileSelectorSubVIew.swift
//  ARBUILDER
//
//  Created by belal medhat on 04/02/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct fileSelectorSubView: View {
    
    @State var title:String = ""
    @Binding var fileLocation:String
    @Binding var fileFormat:UTType?
    @EnvironmentObject var fileSelectorVM:FileSelectorViewModel

    var body: some View {
        VStack(spacing:5){
            TitleSubView(sectionTitle: title)
            HStack(){
                    VStack(){
                        Image(systemName:"doc.badge.plus").resizable().frame(width: 25, height: 25, alignment: .center)
                    }.frame(width: 80, height: 40, alignment: .center).background(Color.black).cornerRadius(20).onTapGesture {
                        print("Dawd")
                        
                            fileSelectorVM.requestOpenPanel()
                        
                }
                Spacer(minLength: 10)
                Text(fileSelectorVM.fileLocation).font(Font.custom("Delight Candles", size: 14)).bold().foregroundColor(Color.black).minimumScaleFactor(0.1)
                Spacer(minLength: 10)
            }.frame(minWidth: 380, maxWidth: 380, minHeight: 40, maxHeight: 40, alignment: .center).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black,lineWidth: 3)).padding(.top,5).padding(.leading,5).padding(.trailing,5).onChange(of: fileSelectorVM.fileLocation) { newValue in
                fileLocation = newValue
            }.onChange(of: fileSelectorVM.fileFormat) { newValue in
                fileFormat = newValue
            }.onAppear(){
                print(fileLocation + "location")
            }

        }
    }
}

struct fileAdderSubView_Previews: PreviewProvider {
    static var previews: some View {
        fileSelectorSubView(fileLocation: .constant(""), fileFormat: .constant(.usdz))
    }
}

