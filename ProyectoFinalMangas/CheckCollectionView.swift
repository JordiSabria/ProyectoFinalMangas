//
//  checkCollectionView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 25/1/24.
//

import SwiftUI

struct CheckCollectionView: View {
    var body: some View {
        Circle()
            .fill(.white.opacity(0.7))
            .frame(width: 40)
            .overlay{
                Image(systemName: "books.vertical")
                    .font(.largeTitle)
                    .symbolVariant(.circle)
                    .symbolVariant(.fill)
                    .foregroundStyle(.white, .blue)
                    .padding()
            }
            .padding(10)
    }
}

#Preview {
    CheckCollectionView()
}
