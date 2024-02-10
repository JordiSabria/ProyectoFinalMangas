//
//  AllMangasView2.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 2/2/24.
//

import SwiftUI
import SwiftData

struct AllMangasView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]
    @State private var path = NavigationPath()
    @State var loading = false
    @Environment(\.colorScheme) var colorScheme
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        @Bindable var bVM = vm
        NavigationStack (path: $path) {
            ScrollView {
                if loading {
                    ProgressView("Cargando...")
                        .controlSize(.regular)
                        .tint(colorScheme == .dark ? .white : .black)
                }
                LazyVGrid(columns: [item]) {
                    ForEach(vm.getMangasBySearchField(searchFieldBy: .allMangas, idAuthor: UUID(), demographic: "", genre: "", theme: "")){ dtoManga in
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
                    }
                }
                .padding()
                .opacity(loading ? 0.0 : 1.0)
            }
            .navigationTitle("Todos los Mangas")
            .navigationDestination(for: DTOMangas.self) { manga in
                MangaDetailView(manga: manga, path: $path)
                    .environment(vm)
            }
        }
        .searchable(text: $bVM.searchMangas, prompt: "Buscar un manga")
        .refreshable {
            getMangas()
        }
        .onAppear(){
            vm.stepsView = 1
            if vm.mangasItemsArray.count < 40{
                Task{
                    loading = true
                    try? await Task.sleep(for: .seconds(2))
                    loading = false
                }
            }
            if vm.mangasItemsArray.count == 0{
                getMangas()
            }
        }
    }
    func getMangas(){
        Task {
            await vm.getMangasItems()
        }
    }
}

#Preview {
    NavigationStack {
        AllMangasView()
            .environment(MangasVM.test)
            .modelContainer(testModelContainer)
    }
}
