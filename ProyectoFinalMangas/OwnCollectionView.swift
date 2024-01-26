//
//  OwnCollectionView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 24/1/24.
//

import SwiftUI
import SwiftData

struct OwnCollectionView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]
    @State private var path = NavigationPath()
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: [item]){
                    ForEach(mangasCollection){ manga in
                        if let mangaTitle = manga.title {
                            NavigationLink(value: manga){
                                MangaView(mangaURL: manga.mainPicture, widthCover: 150, heightCover: 230)
                                    .overlay(alignment: .bottom){
                                        BottomTitleView(title: mangaTitle)
                                    }
                                    .overlay(alignment: .topTrailing){
                                        if mangasCollection.contains(where: {$0.id == manga.id}){
                                            CheckCollectionView()
                                        }
                                    }
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Mi Col-lección")
            .navigationDestination(for: Manga.self) { manga in
                MangaCollectionDetailView(manga: manga)
                    .environment(vm)
            }
        }
    }
}
//        List(mangas){ manga in
//            VStack(alignment: .leading){
//                Text(manga.title ?? "")
//                    .font(.headline)
//                ForEach(manga.authors ?? []){ author in
//                    Text("Autor: \(author.firstName) \(author.lastName)")
//                        .font(.caption)
//                        .foregroundStyle(.secondary)
//                }
//                ForEach(manga.themes ?? []){ theme in
//                    Text("Tema: \(theme.theme)")
//                        .font(.caption)
//                        .foregroundStyle(.secondary)
//                }
//            }
//            
//        }
//        List(actorsMovies){ actor in
//            VStack(alignment: .leading){
//                Text(actor.name)
//                    .font(.headline)
//                ForEach(actor.movies ?? []){ movie in
//                    Text(movie.name)
//                        .font(.caption)
//                        .foregroundStyle(.secondary)
//                }
//            }
//        }


#Preview {
    OwnCollectionView()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
