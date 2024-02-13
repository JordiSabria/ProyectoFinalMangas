//
//  MangaView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 8/1/24.
//

import SwiftUI

struct MangaView: View {
    let mangaURL: String?
    var widthCover: CGFloat
    var heightCover: CGFloat

    var body: some View {
        HStack {
            if let urlImageManga = mangaURL{
                let url = URL(string: urlImageManga.replacingOccurrences(of: "\"", with: ""))
                AsyncImage(url: url){ image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: widthCover, height: heightCover)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                } placeholder: {
                    Image(systemName: "book.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (widthCover - 30), height: (heightCover - 30))
                        .padding()
                        .background {
                            Color(white: 0.9)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                }
            }
        }
    }
    
}

#Preview {
    MangaView(mangaURL: "https://cdn.myanimelist.net/images/manga/1/267784l.jpg" , widthCover: 150, heightCover: 230)
}
