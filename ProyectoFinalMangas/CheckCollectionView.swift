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
            .frame(width: 25)
            .overlay{
                Image(systemName: "checkmark.circle.fill")
                    .padding()
                    .frame(width: 50)
                    .foregroundStyle(.blue)
            }
            .padding(10)
    }
}

#Preview {
    CheckCollectionView()
}
