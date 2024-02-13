//
//  MangasByView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 16/1/24.
//

import SwiftUI
import SwiftData

struct MangasByAuthorView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    let author: DTOAuthor
    
    @Binding var path: NavigationPath
    //@State var loading = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        @Bindable var bVM = vm
        ScrollView {
            if vm.loadingAuthorByiPad {
                ProgressView("Cargando...")
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }
            LazyVGrid(columns: [item]) {
                ForEach (vm.getMangasBySearchField(searchFieldBy: .byAuthor, idAuthor: author.id, demographic: "", genre: "", theme: "")) { dtoManga in
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
            .opacity(vm.loadingAuthorByiPad ? 0.0 : 1.0)
        }
        .searchable(text: $bVM.searchMangas, prompt: "Buscar un manga")
        .navigationTitle("Mangas de \(author.firstName) \(author.lastName)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga, path: $path)
                .environment(vm)
        }
        .refreshable {
            Task {
                await vm.getMangasByAuthor(idAuthor:author.id)
            }
        }
        .onAppear(){
            vm.stepsView = 3
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                guard (vm.mangasByAuthorSpecific[author.id]?.count) != nil else {
                    getMangasByAuthor()
                    return
                }
            } else {
                switch vm.estadoPantalla{
                case .authors:
                    vm.estadoPantalla = .mangas
                    guard (vm.mangasByAuthorSpecific[author.id]?.count) != nil else {
                        getMangasByAuthor()
                        return
                    }
                default:
                    vm.estadoPantalla = .mangas
                }
            }
            #else
            getMangasByAuthor()
            #endif
        }
        .onChange(of: author){
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                getMangasByAuthor()
            }
            #else
            getMangasByAuthor()
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
    func getMangasByAuthor(){
        Task {
            vm.loadingAuthorByiPad = true
            await vm.getMangasByAuthor(idAuthor:author.id)
            await MainActor.run{
                vm.loadingAuthorByiPad = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        MangasByAuthorView(author: .test, path: .constant(NavigationPath()))
            .environment(MangasVM.testByAuthor)
    }
}
