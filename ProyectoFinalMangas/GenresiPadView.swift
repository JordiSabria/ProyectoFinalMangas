//
//  GenresiPadView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 6/2/24.
//

import SwiftUI

struct GenresiPadView: View {
    @Environment(MangasVM.self) var vm
    @State private var path = NavigationPath()
    @State var visibility: NavigationSplitViewVisibility = .all
    @State var loading = false
    @Environment(\.colorScheme) var colorScheme
    @State var genreSelected: DTOGenre?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility){
            if loading {
                ProgressView()
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }
//            List(vm.genres){ genre in
            List(selection: $genreSelected){
                ForEach(vm.genres){ genre in
                    NavigationLink(value: genre){
                        Text(genre.genre)
                    }
                    .tag(genre)
                }
            }
            .opacity(loading ? 0.0 : 1.0)
            .navigationTitle("Género")
            .navigationDestination(for: DTOGenre.self){ genre in
                MangasByGenresView(genre: genre, path: $path)
                    .environment(vm)
            }
            .refreshable {
                Task{
                    await vm.getGenres()
                }
            }
        } content: {
//            if let genresTmp = vm.genres.first{
            if let genreSelected {
                MangasByGenresView(genre: genreSelected, path: $path)
                    .environment(vm)
            }
        } detail: {
//            Text("Selecciona un manga")
//            if let genresTmp = vm.genres.first{
            if vm.loadingGenresByiPad{
                ProgressView("Cargando...")
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }else{
                if let genreSelected {
                    if let mangaTmp = vm.getFirstMangaBy(mangasbyToSord: .byGenre, idAuthor: UUID(), demographic: "", genre: genreSelected.genre, theme: ""){
                        MangaDetailView(manga: mangaTmp, path: $path)
                            .environment(vm)
                    }
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear(){
            vm.estadoPantalla = .genres
            if vm.genres.count == 0{
                Task{
                    loading = true
                    await vm.getGenres()
                    loading = false
                    if genreSelected == nil {
                        genreSelected = vm.genres.first
                    }
                }
            }
        }
    }
}

#Preview {
    GenresiPadView()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
