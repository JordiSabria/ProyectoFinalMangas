//
//  RowMultiLineInfoView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 12/2/24.
//

import SwiftUI

struct RowMultiLineInfoView: View {
    var title: String
    var info: String
    
    var body: some View {
        HStack(alignment: .top){
            Text(title)
                .bold()
            Spacer()
            Text(info)
                .multilineTextAlignment(.trailing)
        }
        Divider()
    }
}

#Preview {
    RowMultiLineInfoView(title: "Sinopsis", info: "informacion")
}
