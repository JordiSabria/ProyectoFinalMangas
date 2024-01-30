//
//  AdvSearchMangasView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 28/1/24.
//

import SwiftUI
import SwiftData

struct AdvSearchMangasView: View {
    @Environment(AdvancedSearchMangasVM.self) var vm2
    @Environment(MangasVM.self) var vm
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    @Query var mangasCollection: [Manga]
    @State private var navigateToMangasDetailView = false
    @State private var selectedMangaItem: DTOMangas?
    
    @Binding var path: NavigationPath
    
    
    var body: some View {
        @Bindable var vmASM = vm2
        ScrollView{
            LazyVGrid(columns: [item]){
                ForEach(vm2.mangasItemsArray){ mangaItems in
                    ForEach(mangaItems.items){ mangaItem in
                        if let mangaTitle = mangaItem.title {
                            MangaView(mangaURL: mangaItem.mainPicture, widthCover: 150, heightCover: 230)
                                .overlay(alignment: .bottom){
                                    BottomTitleView(title: mangaTitle)
                                }
                                .overlay(alignment: .topTrailing){
                                    if mangasCollection.contains(where: {$0.id == mangaItem.id}){
                                        CheckCollectionView()
                                    }
                                }
                                .onTapGesture{
                                    selectedMangaItem = mangaItem
                                    navigateToMangasDetailView = true
                                }
                              .padding()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationDestination(isPresented: $navigateToMangasDetailView){
            if let manga = selectedMangaItem {
                MangaDetailView(manga: manga, path: $path)
                    .environment(vm)
            }
        }
        .navigationTitle("Mangas búsqueda abançada")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            switch vm.estadoPantalla{
            case .advSearch:
                vm.estadoPantalla = .mangas
                Task {
                    await vm2.getAdvSearchMangas(mangasVM: vm)
                }
            default:
                vm.estadoPantalla = .mangas
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    path.removeLast()
                    vm2.cleanAdvSearchMangas()
                } label: {
                    Image(systemName: "eraser.line.dashed")
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        AdvSearchMangasView(path: .constant(NavigationPath()))
            .environment(MangasVM.testAdvSearch)
            .environment(AdvancedSearchMangasVM())
            .modelContainer(testModelContainer)
    }
}
