//
//  BestMangaiPadView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 5/2/24.
//

import SwiftUI
import SwiftData

struct BestMangaiPadView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]
    @State private var path = NavigationPath()
    
    @State var visibility: NavigationSplitViewVisibility = .all
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility){
            ScrollView{
                LazyVGrid(columns: [item]){
                    ForEach (vm.bestMangasItemsArray){ mangaItems in
                        ForEach (mangaItems.items){ dtoManga in
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
                }
            }
            .navigationTitle("Los 10 mejores Mangas")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: DTOMangas.self) { manga in
                MangaDetailView(manga: manga, path: $path)
                    .environment(vm)
            }
            .navigationSplitViewColumnWidth(min: 1000, ideal: 1000, max: 1000)
            .onAppear(){
                vm.stepsView = 2
                if vm.bestMangasItemsArray.count == 0{
                    getBestMangas()
                }
            }
        } detail: {
            if let mangaItemsDetail = vm.bestMangasItemsArray.first{
                if let mangaDetail=mangaItemsDetail.items.first{
                    MangaDetailView(manga: mangaDetail, path: $path)
                        .environment(vm)
                }
            }
        }
    }
    func getBestMangas(){
        Task {
            await vm.getBestMangasItems()
        }
    }
}

#Preview {
    BestMangaiPadView()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)

}
