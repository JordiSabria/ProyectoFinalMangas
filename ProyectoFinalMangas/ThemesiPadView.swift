//
//  ThemesiPadView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 6/2/24.
//

import SwiftUI

struct ThemesiPadView: View {
    @Environment(MangasVM.self) var vm
    @State private var path = NavigationPath()
    @State var visibility: NavigationSplitViewVisibility = .all
    @State var loading = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility){
            if loading {
                ProgressView()
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }
            List(vm.themes){ theme in
                NavigationLink(value: theme){
                    Text(theme.theme)
                }
            }
            .opacity(loading ? 0.0 : 1.0)
            .navigationTitle("Temáticas")
            .navigationDestination(for: DTOTheme.self){ theme in
                MangasByThemesView(theme: theme, path: $path)
                    .environment(vm)
            }
            .refreshable {
                Task{
                    await vm.getThemes()
                }
            }
        } content: {
            if let themeTmp = vm.themes.first{
                MangasByThemesView(theme: themeTmp, path: $path)
                    .environment(vm)
            }
        } detail: {
            if let themeTmp = vm.themes.first{
                if let mangaTmp = vm.getFirstMangaBy(mangasbyToSord: .byTheme, idAuthor: UUID(), demographic: "", genre: "", theme: themeTmp.theme){
                    MangaDetailView(manga: mangaTmp, path: $path)
                        .environment(vm)
                }
            }
        }
        .onAppear(){
            vm.estadoPantalla = .themes
            if vm.themes.count == 0{
                Task{
                    loading = true
                    await vm.getThemes()
                    loading = false
                }
            }
        }
    }
}

#Preview {
    ThemesiPadView()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
