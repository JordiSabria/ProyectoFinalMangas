//
//  TitleJaponeseView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 12/2/24.
//

import SwiftUI

struct TitleJapaneseView: View {
    var titleJapaneseManga: String
    var body: some View {
        Text(titleJapaneseManga)
            .lineLimit(2)
            .font(.caption)
            .minimumScaleFactor(0.7)
            .multilineTextAlignment(.center)
            .padding(.bottom, 10)
    }
}

#Preview {
    TitleJapaneseView(titleJapaneseManga: "XinXan")
}
