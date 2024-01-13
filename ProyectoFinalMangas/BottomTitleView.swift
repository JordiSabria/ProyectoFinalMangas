//
//  BottomTitleView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 12/1/24.
//

import SwiftUI

struct BottomTitleView: View {
    let title: String
    
    var body: some View {
        Rectangle()
            .fill(.white.opacity(0.7))
            .frame(height: 50)
            .overlay(alignment: .center) {
                VStack {
                    Text(title)
                        .lineLimit(2)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.black)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.center)
                }
                .padding(2)
            }
    }
}

#Preview {
    BottomTitleView(title: "Pita-Ten")
}
