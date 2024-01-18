//
//  MangasByView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 16/1/24.
//

import SwiftUI

struct MangasByAuthorView: View {
    @Environment(MangasVM.self) var vm
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    let author: DTOAuthor
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [item]) {
                ForEach (vm.mangasItemsByAuthor){ mangaItems in
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
        .navigationTitle("Mangas de \(author.firstName) \(author.lastName)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga)
                .environment(vm)
        }
        .onAppear(){
            switch vm.estadoPantalla{
                case .authors:
                    vm.estadoPantalla = .mangas
                    Task {
                        await vm.getMangasByAuthor(idAuthor:author.id)
                    }
                default:
                    vm.estadoPantalla = .mangas
                }
            
        }
    }
}

#Preview {
    NavigationStack {
        MangasByAuthorView(author: .test)
            .environment(MangasVM.testByAuthor)
    }
}
