//
//  GenresView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 16/1/24.
//

import SwiftUI

struct GenresView: View {
    @Environment(MangasVM.self) var vm
    @Binding var path: NavigationPath
    @State var loading = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if loading {
            ProgressView()
                .controlSize(.regular)
                .tint(colorScheme == .dark ? .white : .black)
        }
        List(vm.genres){ genre in
            NavigationLink(value: genre){
                Text(genre.genre)
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
        .onAppear(){
            vm.estadoPantalla = .genres
            if vm.genres.count == 0{
                Task{
                    loading = true
                    await vm.getGenres()
                    loading = false
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
        GenresView(path: .constant(NavigationPath()))
            .environment(MangasVM.test)
    }
}
