//
//  BestMangasView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 13/1/24.
//

import SwiftUI
import SwiftData

struct BestMangasView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: [item]){
                ForEach (vm.bestMangasItemsArray){ mangaItems in
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
        }
        .navigationTitle("Los 10 mejores Mangas")
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga)
                .environment(vm)
        }
        .onAppear(){
            if vm.bestMangasItemsArray.count == 0{
                getBestMangas()
            }
        }
    }
    func getBestMangas(){
        Task {
            await vm.getBestMangasItems()
            //insertMangas()
        }
    }
    func insertMangas(){
        for mangaItem in vm.bestMangasItemsArray {
            for DTOManga in mangaItem.items{
                vm.guardarMangaEnMiLibreria(manga: DTOManga, context: context)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BestMangasView()
            .environment(MangasVM.test)
    }
}
