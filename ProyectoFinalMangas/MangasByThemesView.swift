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
        .refreshable {
            Task {
                await vm.getMangasByTheme(theme: theme.theme)
            }
        }
        .onAppear(){
            vm.stepsView = 3
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                guard (vm.mangasByThemesSpecific[theme.theme]?.count) != nil else {
                    Task {
                        await vm.getMangasByTheme(theme: theme.theme)
                    }
                    return
                }
            } else {
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
            #else
            Task {
                await vm.getMangasByTheme(theme: theme.theme)
            }
            #endif
        }
        .onChange(of: theme){
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                Task {
                    await vm.getMangasByTheme(theme: theme.theme)
                }
            }
            #else
            Task {
                await vm.getMangasByTheme(theme: theme.theme)
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
        MangasByThemesView(theme: .test, path: .constant(NavigationPath()))
            .environment(MangasVM.testByThemes)
    }
}
