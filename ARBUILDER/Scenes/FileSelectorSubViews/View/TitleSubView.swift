//
//  TitleSubView.swift
//  ARBUILDER
//
//  Created by belal medhat on 04/02/2023.
//

import SwiftUI

struct TitleSubView: View {
    @State var sectionTitle:String = "Generate"
    var body: some View {
        GeometryReader { innerGeo in
            Text(sectionTitle).font(Font.custom("Delight Candles", size: 14)).bold().foregroundColor(Color.black).frame(width: innerGeo.size.width, height: 40, alignment: .center)

        }.frame(height: 40, alignment: .center)
    }
}

struct TitlesSubView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubView()
    }
}

