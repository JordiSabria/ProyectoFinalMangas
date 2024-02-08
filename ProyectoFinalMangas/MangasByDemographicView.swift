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
    @Binding var path: NavigationPath
    
    var body: some View {
        @Bindable var bVM = vm
        ScrollView {
            LazyVGrid(columns: [item]) {
                //ForEach (vm.mangasByDemographicSpecific[demographic.demographic] ?? []){ mangaItems in
                ForEach (vm.getMangasBySearchField(searchFieldBy: .byDemographic, idAuthor: UUID(), demographic: demographic.demographic, genre: "", theme: "")){ dtoManga in
                    //ForEach (mangaItems.items){ dtoManga in
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
                    //}
                }
            }
            .padding()
        }
        .searchable(text: $bVM.searchMangas, prompt: "Buscar un manga")
        .navigationTitle("Mangas de \(demographic.demographic)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: DTOMangas.self) { manga in
            MangaDetailView(manga: manga, path: $path)
                .environment(vm)
        }
        .refreshable {
            Task {
                await vm.getMangasByDemographic(demographic: demographic.demographic)
            }
        }
        .onAppear(){
            vm.stepsView = 3
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                guard (vm.mangasByDemographicSpecific[demographic.demographic]?.count) != nil else {
                    Task {
                        await vm.getMangasByDemographic(demographic: demographic.demographic)
                    }
                    return
                }
            }else {
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
            #else
            Task {
                await vm.getMangasByDemographic(demographic: demographic.demographic)
            }
            #endif
        }
        .onChange(of: demographic){
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                Task {
                    await vm.getMangasByDemographic(demographic: demographic.demographic)
                }
            }
            #else
            Task {
                await vm.getMangasByDemographic(demographic: demographic.demographic)
            }
            #endif
        }
        .toolbar {
            if UIDevice.current.userInterfaceIdiom == .phone {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        path.removeLast(2)
                    } label: {
                        Image(systemName: "eraser.line.dashed")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MangasByDemographicView(demographic: .test, path: .constant(NavigationPath()))
            .environment(MangasVM.testByDemographic)
    }
}
