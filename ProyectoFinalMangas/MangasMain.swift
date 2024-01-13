//
//  MangasMain.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 10/1/24.
//

import SwiftUI

struct MangasMain: View {
    @Environment(MangasVM.self) var vm
    
    var body: some View {
        TabView{
            SearchView()
                .environment(vm)
                .tabItem{
                    Label("Busqueda", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    MangasMain()
        .environment(MangasVM())
}
