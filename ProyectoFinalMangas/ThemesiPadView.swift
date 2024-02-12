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
    @State var themeSelected: DTOTheme?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility){
            if loading {
                ProgressView()
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }
//            List(vm.themes){ theme in
            List(selection: $themeSelected){
                ForEach(vm.themes){ theme in
                    NavigationLink(value: theme){
                        Text(theme.theme)
                    }
                    .tag(theme)
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
            //if let themeTmp = vm.themes.first{
            if let themeSelected{
                MangasByThemesView(theme: themeSelected, path: $path)
                    .environment(vm)
            }
        } detail: {
//            Text("Selecciona un manga")
            if vm.loadingThemesByiPad{
                ProgressView("Cargando...")
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }else{
//                if let themeTmp = vm.themes.first{
                if let themeSelected{
                    if let mangaTmp = vm.getFirstMangaBy(mangasbyToSord: .byTheme, idAuthor: UUID(), demographic: "", genre: "", theme: themeSelected.theme){
                        MangaDetailView(manga: mangaTmp, path: $path)
                            .environment(vm)
                    }
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear(){
            vm.estadoPantalla = .themes
            if vm.themes.count == 0{
                Task{
                    loading = true
                    await vm.getThemes()
                    loading = false
                    if themeSelected == nil {
                        themeSelected = vm.themes.first
                    }
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
