//
//  BestMangasView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 13/1/24.
//

import SwiftUI

struct BestMangasView: View {
    @Environment(MangasVM.self) var vm
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
                                  .padding()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Los mejores Mangas")
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga)
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
        }
    }
}

#Preview {
    NavigationStack {
        BestMangasView()
            .environment(MangasVM())
    }
}
