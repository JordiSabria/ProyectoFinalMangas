//
//  AllMangasView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 10/1/24.
//

import SwiftUI

struct AllMangasView: View {
    @Environment(MangasVM.self) var vm
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        Text(String(vm.mangasItemsArray.count))
        ScrollView {
            LazyVGrid(columns: [item]) {
                ForEach (vm.mangasItemsArray){ mangaItems in
                    ForEach (mangaItems.items){ mangaItem in
                        NavigationLink(value: mangaItem) {
                            MangaView(manga: mangaItem)
                                .padding()
                        }
                    }
                }
            }
            .padding()
        }
//        List{
//            //Text(String(vm.mangasArray.count))
//            ForEach (vm.mangasItemsArray){ mangaItems in
//                ForEach (mangaItems.items){ mangaItem in
//                    NavigationLink(value: mangaItem) {
//                        MangaView(manga: mangaItem)
//                    }
//                }
//            }
//            ForEach (vm.mangasArray) { manga in
//                MangaView(manga: manga)
//            }
//        }
//        .padding()
        .navigationTitle("Todos los Mangas")
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga)
        }
        .onAppear(){
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
            .environment(MangasVM())
    }
}
