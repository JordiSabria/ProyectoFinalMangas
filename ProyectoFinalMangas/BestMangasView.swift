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
    @Binding var path: NavigationPath
    @State var loading = false
    @Environment(\.colorScheme) var colorScheme
    
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    
    var body: some View {
        ScrollView{
            if loading {
                ProgressView("Cargando...")
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }
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
            .opacity(loading ? 0.0 : 1.0)
        }
        .navigationTitle("Los 10 mejores Mangas")
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga, path: $path)
                .environment(vm)
        }
        .onAppear(){
            vm.stepsView = 2
            if vm.bestMangasItemsArray.count == 0{
                Task {
                    loading = true
                    await vm.getBestMangasItems()
                    loading = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BestMangasView(path: .constant(NavigationPath()))
            .environment(MangasVM.test)
            .modelContainer(testModelContainer) 
    }
}
