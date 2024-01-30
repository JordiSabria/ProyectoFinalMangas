//
//  MangasByGenresView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 18/1/24.
//

import SwiftUI
import SwiftData

struct MangasByGenresView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    let genre: DTOGenre
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [item]) {
                ForEach (vm.mangasByGenresSpecific[genre.genre] ?? []){ mangaItems in
                    ForEach (mangaItems.items){ mangaItem in
                        if let mangaTitle = mangaItem.title {
                            NavigationLink(value: mangaItem) {
                                MangaView(mangaURL: mangaItem.mainPicture, widthCover: 150, heightCover: 230)
                                    .overlay(alignment: .bottom){
                                        BottomTitleView(title: mangaTitle)
                                    }
                                    .overlay(alignment: .topTrailing){
                                        if mangasCollection.contains(where: {$0.id == mangaItem.id}){
                                            CheckCollectionView()
                                        }
                                    }
                                  .padding()
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Mangas de \(genre.genre)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga, path: $path)
                .environment(vm)
        }
        .onAppear(){
            switch vm.estadoPantalla{
                case .genres:
                    vm.estadoPantalla = .mangas
                guard (vm.mangasByGenresSpecific[genre.genre]?.count) != nil else {
                    Task {
                        await vm.getMangasByGenre(genre: genre.genre)
                    }
                    return
                }
                default:
                    vm.estadoPantalla = .mangas
                }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "eraser.line.dashed")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MangasByGenresView(genre: .test, path: .constant(NavigationPath()))
            .environment(MangasVM.testByGenre)
    }
}
