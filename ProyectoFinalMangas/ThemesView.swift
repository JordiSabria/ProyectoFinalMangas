//
//  ThemesView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 16/1/24.
//

import SwiftUI

struct ThemesView: View {
    @Environment(MangasVM.self) var vm
    
    var body: some View {
        List(vm.themes){ theme in
            NavigationLink(value: theme){
                Text(theme.theme)
            }
        }
        .navigationTitle("Temáticas")
        .navigationDestination(for: DTOTheme.self){ theme in
            MangasByThemesView(theme: theme)
                .environment(vm)
        }
        .refreshable {
            Task{
                await vm.getThemes()
            }
        }
        .onAppear(){
            switch vm.estadoPantalla{
                case .search:
                    vm.estadoPantalla = .themes
                    Task{
                        await vm.getThemes()
                    }
                default:
                    vm.estadoPantalla = .themes
                }
        }
    }
}

#Preview {
    NavigationStack {
        ThemesView()
            .environment(MangasVM.test)
    }
}
