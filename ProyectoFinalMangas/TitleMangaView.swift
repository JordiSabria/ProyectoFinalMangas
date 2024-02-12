//
//  TitleMangaView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 12/2/24.
//

import SwiftUI

struct TitleMangaView: View {
    var titleManga: String
    var body: some View {
        Text(titleManga)
            .lineLimit(2)
            .font(.title)
            .bold()
            .minimumScaleFactor(0.7)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    TitleMangaView(titleManga: "Dragon Ball")
}
