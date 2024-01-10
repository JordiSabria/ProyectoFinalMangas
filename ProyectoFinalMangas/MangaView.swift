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
                Text(mangaUn)
                if let urlImageManga = manga.mainPicture{
                    let url = URL(string: urlImageManga.replacingOccurrences(of: "\"", with: ""))
                   // Text(urlImageManga)
                    AsyncImage(url: url){ image in
                        image
                            .resizable()
                            .scaledToFit()
                            .symbolVariant(.fill)
                            .symbolVariant(.circle)
                            .frame(width: 90)
                            .background {
                                Color(white: 0.9)
                            }
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .symbolVariant(.fill)
                            .symbolVariant(.circle)
                            .padding()
                            .frame(width: 90)
                            .background {
                                Color(white: 0.9)
                            }
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
    
}

#Preview {
    MangaView(manga: .test)
}
