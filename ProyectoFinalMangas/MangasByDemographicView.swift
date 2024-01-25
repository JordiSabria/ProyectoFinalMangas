//
//  MangasByDemographicView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 17/1/24.
//

import SwiftUI
import SwiftData

struct MangasByDemographicView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @Query var mangasCollection: [Manga]
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    var demographic: DTODemographic
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [item]) {
                ForEach (vm.mangasByDemographicSpecific[demographic.demographic] ?? []){ mangaItems in
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
            .padding()
        }
        .navigationTitle("Mangas de \(demographic.demographic)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga)
                .environment(vm)
        }
        .onAppear(){
            switch vm.estadoPantalla{
                case .demographics:
                    vm.estadoPantalla = .mangas
                guard (vm.mangasByDemographicSpecific[demographic.demographic]?.count) != nil else {
                    Task {
                        await vm.getMangasByDemographic(demographic: demographic.demographic)
                    }
                    return
                }
                default:
                    vm.estadoPantalla = .mangas
                }
        }
    }
}

#Preview {
    NavigationStack {
        MangasByDemographicView(demographic: .test)
            .environment(MangasVM.testByDemographic)
    }
}
