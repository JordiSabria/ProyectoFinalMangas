//
//  MangaView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 8/1/24.
//

import SwiftUI

struct MangaView: View {
    //let manga: Manga
    let manga: DTOMangas
    
    var body: some View {
        if let mangaUn = manga.title {
            HStack {
                if let urlImageManga = manga.mainPicture{
                    let url = URL(string: urlImageManga.replacingOccurrences(of: "\"", with: ""))
                    AsyncImage(url: url){ image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 230)
                            .overlay(alignment: .bottom){
                                BottomTitleView(title: mangaUn)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    } placeholder: {
                        Image(systemName: "book.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 230)
                            .padding()
                            .background {
                                Color(white: 0.9)
                            }
                            .overlay(alignment: .bottom){
                                BottomTitleView(title: mangaUn)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    
                }
            }
        }
    }
    
}

#Preview {
    MangaView(manga: .test)
}
