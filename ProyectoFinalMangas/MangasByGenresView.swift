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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        @Bindable var bVM = vm
        ScrollView {
            if vm.loadingGenresByiPad {
                ProgressView("Cargando...")
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }
            LazyVGrid(columns: [item]) {
                ForEach (vm.getMangasBySearchField(searchFieldBy: .byGenre, idAuthor: UUID(), demographic: "", genre: genre.genre, theme: "")){ dtoManga in
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
                            .tag(dtoManga)
                            .hoverEffect()
                        }
                }
            }
            .padding()
            .opacity(vm.loadingGenresByiPad ? 0.0 : 1.0)
        }
        .searchable(text: $bVM.searchMangas, prompt: "Buscar un manga")
        .navigationTitle("Mangas de \(genre.genre)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga, path: $path)
                .environment(vm)
        }
        .refreshable {
            Task {
                await vm.getMangasByGenre(genre: genre.genre)
            }
        }
        .onAppear(){
            vm.stepsView = 3
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                guard (vm.mangasByGenresSpecific[genre.genre]?.count) != nil else {
                    getMangasByGenre()
                    return
                }
            } else {
                switch vm.estadoPantalla{
                case .genres:
                    vm.estadoPantalla = .mangas
                    guard (vm.mangasByGenresSpecific[genre.genre]?.count) != nil else {
                        getMangasByGenre()
                        return
                    }
                default:
                    vm.estadoPantalla = .mangas
                }
            }
            #else
            getMangasByGenre()
            #endif
        }
        .onChange(of: genre){
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                getMangasByGenre()
            }
            #else
            getMangasByGenre()
            #endif
        }
        .toolbar {
            if UIDevice.current.userInterfaceIdiom == .phone {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        path.removeLast(2)
                    } label: {
                        Image(systemName: "eraser.line.dashed")
                    }
                }
            }
        }
    }
    func getMangasByGenre(){
        Task {
            vm.loadingGenresByiPad = true
            await vm.getMangasByGenre(genre: genre.genre)
            await MainActor.run{
                vm.loadingGenresByiPad = false
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
