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
                            .tag(manga)
                            .hoverEffect()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Mi Colección")
            .navigationDestination(for: Manga.self) { manga in
                MangaCollectionDetailView(mangaR: manga)
                    .environment(vm)
            }
        }
    }
}

#Preview {
    OwnCollectionView()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
