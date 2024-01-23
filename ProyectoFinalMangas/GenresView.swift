//
//  GenresView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 16/1/24.
//

import SwiftUI

struct GenresView: View {
    @Environment(MangasVM.self) var vm
    
    var body: some View {
        List(vm.genres){ genre in
            NavigationLink(value: genre){
                Text(genre.genre)
            }
        }
        .navigationTitle("Género")
        .navigationDestination(for: DTOGenre.self){ genre in
            MangasByGenresView(genre: genre)
                .environment(vm)
        }
        .refreshable {
            Task{
                await vm.getGenres()
            }
        }
        .onAppear(){
            vm.estadoPantalla = .genres
            if vm.genres.count == 0{
                Task{
                    await vm.getGenres()
                }
            }
//            switch vm.estadoPantalla{
//                case .search:
//                    vm.estadoPantalla = .genres
//                    Task{
//                        await vm.getGenres()
//                    }
//                default:
//                    vm.estadoPantalla = .genres
//                }
        }
    }
}

#Preview {
    NavigationStack {
        GenresView()
            .environment(MangasVM.test)
    }
}
