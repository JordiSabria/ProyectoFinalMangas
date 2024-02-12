//
//  RowURLView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 12/2/24.
//

import SwiftUI

struct RowURLView: View {
    var url: String
    
    var body: some View {
        let urlRetocada = url.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        HStack(alignment: .top){
            Text("Link")
                .bold()
            Spacer()
            Link(urlRetocada, destination: URL(string: urlRetocada) ?? URL(string: "https://myanimelist.net")!)
        }
        Divider()
    }
}

#Preview {
    RowURLView(url: "http://www.google.es")
}
