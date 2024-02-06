//
//  MangasByAuthoriPadView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 6/2/24.
//

import SwiftUI
import SwiftData

struct MangasByAuthoriPadView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    let author: DTOAuthor
    @Binding var path: NavigationPath
    
    var body: some View {
        @Bindable var bVM = vm
        ScrollView {
            LazyVGrid(columns: [item]) {
                //ForEach (vm.mangasByAuthorSpecific[author.id] ?? []){ mangaItems in
                ForEach (vm.getMangasBySearchField(searchFieldBy: .byAuthor, idAuthor: author.id, demographic: "", genre: "", theme: "")) { dtoManga in
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
                    }
                //}
            }
            .padding()
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
        .onChange(of: author){
            Task {
                await vm.getMangasByAuthor(idAuthor:author.id)
            }
        }
    }
}

#Preview {
    MangasByAuthoriPadView(author: .test, path: .constant(NavigationPath()))
        .environment(MangasVM.testByAuthor)
        //.modelContainer(testModelContainer)
}
