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
        Text(String(vm.genres.count))
        List(vm.genres, id: \.self){ genre in
            Text(genre)
        }
        .navigationTitle("Género")
        .onAppear(){
            if vm.genres.count == 0 {
                Task{
                    await vm.getGenres()
                }
            }
        }
    }
}

#Preview {
    GenresView()
        .environment(MangasVM())
}
