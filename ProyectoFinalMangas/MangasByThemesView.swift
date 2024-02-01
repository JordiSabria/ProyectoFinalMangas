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
    
    @Binding var path: NavigationPath
    
    var body: some View {
        @Bindable var bVM = vm
        ScrollView {
            LazyVGrid(columns: [item]) {
                //ForEach (vm.mangasByThemesSpecific[theme.theme] ?? []){ mangaItems in
                ForEach (vm.getMangasBySearchField(searchFieldBy: .byTheme, idAuthor: UUID(), demographic: "", genre: "", theme: theme.theme)){ dtoManga in
                    //ForEach (mangaItems.items){ mangaItem in
                        if let mangaTitle = dtoManga.title {
                            NavigationLink(value: dtoManga) {
                                MangaView(mangaURL: dtoManga.mainPicture, widthCover: 150, heightCover: 230)
                                    .overlay(alignment: .bottom){
                                        BottomTitleView(title: mangaTitle)
                                    }
                                    .overlay(alignment: .topTrailing){
                                        if mangasCollection.contains(where: {$0.id == dtoManga.id}){
                                            CheckCollectionView()
                                        }
                                    }
                                  .padding()
                            }
                        }
                    //}
                }
            }
            .padding()
        }
        .searchable(text: $bVM.searchMangas, prompt: "Buscar un manga")
        .navigationTitle("Mangas de \(theme.theme)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga, path: $path)
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
        MangasByThemesView(theme: .test, path: .constant(NavigationPath()))
            .environment(MangasVM.testByThemes)
    }
}
