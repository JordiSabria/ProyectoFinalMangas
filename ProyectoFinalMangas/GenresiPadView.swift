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
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility){
            List(vm.genres){ genre in
                NavigationLink(value: genre){
                    Text(genre.genre)
                }
            }
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
            if let genresTmp = vm.genres.first{
                MangasByGenresView(genre: genresTmp, path: $path)
                    .environment(vm)
            }
        } detail: {
            if let genresTmp = vm.genres.first{
                if let mangaTmp = vm.getFirstMangaBy(mangasbyToSord: .byGenre, idAuthor: UUID(), demographic: "", genre: genresTmp.genre, theme: ""){
                    MangaDetailView(manga: mangaTmp, path: $path)
                        .environment(vm)
                }
            }
        }
        .onAppear(){
            vm.estadoPantalla = .genres
            if vm.genres.count == 0{
                Task{
                    await vm.getGenres()
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
