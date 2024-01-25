//
//  MangasByThemesView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 18/1/24.
//

import SwiftUI
import SwiftData

struct MangasByThemesView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]

    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    let theme: DTOTheme
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [item]) {
                ForEach (vm.mangasByThemesSpecific[theme.theme] ?? []){ mangaItems in
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
        .navigationTitle("Mangas de \(theme.theme)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga)
                .environment(vm)
        }
        .onAppear(){
            switch vm.estadoPantalla{
                case .themes:
                    vm.estadoPantalla = .mangas
                guard (vm.mangasByThemesSpecific[theme.theme]?.count) != nil else {
                    Task {
                        await vm.getMangasByTheme(theme: theme.theme)
                    }
                    return
                }
                default:
                    vm.estadoPantalla = .mangas
                }
        }
    }
}

#Preview {
    NavigationStack {
        MangasByThemesView(theme: .test)
            .environment(MangasVM.testByThemes)
    }
}
