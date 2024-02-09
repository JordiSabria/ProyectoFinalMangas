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
    @State var loading = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        @Bindable var bVM = vm
        ScrollView {
            if loading {
                ProgressView("Cargando...")
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }
            LazyVGrid(columns: [item]) {
                //ForEach (vm.mangasByGenresSpecific[genre.genre] ?? []){ mangaItems in
                ForEach (vm.getMangasBySearchField(searchFieldBy: .byGenre, idAuthor: UUID(), demographic: "", genre: genre.genre, theme: "")){ dtoManga in
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
                   // }
                }
            }
            .padding()
            .opacity(loading ? 0.0 : 1.0)
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
                    Task {
                        loading = true
                        await vm.getMangasByGenre(genre: genre.genre)
                        loading = false
                    }
                    return
                }
            } else {
                switch vm.estadoPantalla{
                case .genres:
                    vm.estadoPantalla = .mangas
                    guard (vm.mangasByGenresSpecific[genre.genre]?.count) != nil else {
                        Task {
                            loading = true
                            await vm.getMangasByGenre(genre: genre.genre)
                            loading = false
                        }
                        return
                    }
                default:
                    vm.estadoPantalla = .mangas
                }
            }
            #else
            Task {
                loading = true
                await vm.getMangasByGenre(genre: genre.genre)
                loading = false
            }
            #endif
        }
        .onChange(of: genre){
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                Task {
                    loading = true
                    await vm.getMangasByGenre(genre: genre.genre)
                    loading = false
                }
            }
            #else
            Task {
                loading = true
                await vm.getMangasByGenre(genre: genre.genre)
                loading = false
            }
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
}

#Preview {
    NavigationStack {
        MangasByGenresView(genre: .test, path: .constant(NavigationPath()))
            .environment(MangasVM.testByGenre)
    }
}
