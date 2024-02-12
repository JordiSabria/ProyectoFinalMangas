//
//  ImageBookCollectionView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 12/2/24.
//

import SwiftUI

struct ImageBookCollectionView: View {
    
    var body: some View {
        Image(systemName: "books.vertical")
            .font(.largeTitle)
            .symbolVariant(.circle)
            .symbolVariant(.fill)
            .padding(7)
    }
}

#Preview {
    ImageBookCollectionView()
}
