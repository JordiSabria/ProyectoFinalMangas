//
//  RowInfoView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 12/2/24.
//

import SwiftUI

struct RowInfoView: View {
    var title: String
    var info: String
    
    var body: some View {
        HStack{
            Text(title)
                .bold()
            Spacer()
            Text(info)
        }
        Divider()
    }
}

#Preview {
    RowInfoView(title: "Status", info: "Completed")
}
