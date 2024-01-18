//
//  MangasByDemographicView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 17/1/24.
//

import SwiftUI

struct MangasByDemographicView: View {
    @Environment(MangasVM.self) var vm
    let item = GridItem(.adaptive(minimum: 150), alignment: .center)
    var demographic: DTODemographic
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [item]) {
                ForEach (vm.mangasItemsByDemographic){ mangaItems in
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
                    Task {
                        await vm.getMangasByDemographic(demographic: demographic.demographic)
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
