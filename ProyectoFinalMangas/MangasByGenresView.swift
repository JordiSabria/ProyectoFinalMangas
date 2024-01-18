//
//  MangasByGenresView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 18/1/24.
//

import SwiftUI

struct MangasByGenresView: View {
    @Environment(MangasVM.self) var vm
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    let genre: DTOGenre
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [item]) {
                ForEach (vm.mangasItemsByGenre){ mangaItems in
                    ForEach (mangaItems.items){ mangaItem in
                        if let mangaTitle = mangaItem.title {
                            NavigationLink(value: mangaItem) {
                                MangaView(mangaURL: mangaItem.mainPicture, widthCover: 150, heightCover: 230)
                                    .overlay(alignment: .bottom){
                                        BottomTitleView(title: mangaTitle)
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
            MangaDetailView(manga: manga)
                .environment(vm)
        }
        .onAppear(){
            switch vm.estadoPantalla{
                case .genres:
                    vm.estadoPantalla = .mangas
                    Task {
                        await vm.getMangasByGenre(genre: genre.genre)
                    }
                default:
                    vm.estadoPantalla = .mangas
                }
        }
    }
}

#Preview {
    NavigationStack {
        MangasByGenresView(genre: .test)
            .environment(MangasVM.testByGenre)
    }
}
