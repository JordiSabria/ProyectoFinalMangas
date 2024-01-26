//
//  AllMangasView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 10/1/24.
//

import SwiftUI
import SwiftData

struct AllMangasView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]
    
    @State var searchManga: String = ""
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        @Bindable var bVM = vm
        Text(String(vm.mangasItemsArray.count))
        ScrollView {
            LazyVGrid(columns: [item]) {
                ForEach(vm.getMangasItemsSearchAllMangash()){ mangaItem in
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
            .padding()
        }
        .searchable(text: $bVM.searchAllMangas, prompt: "Buscar un manga")
        .navigationTitle("Todos los Mangas")
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga)
                .environment(vm)
        }
        .refreshable {
            getMangas()
        }
        .onAppear(){
            //getMangas()
            if vm.mangasItemsArray.count == 0{
                getMangas()
            }
        }
//        .onChange(of: bVM.searchAllMangas, initial: false){
//            print(bVM.searchAllMangas)
//        }
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
