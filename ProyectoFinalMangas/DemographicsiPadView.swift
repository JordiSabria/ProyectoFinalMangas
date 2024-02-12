//
//  DemographicsiPadView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 6/2/24.
//

import SwiftUI


struct DemographicsiPadView: View {
    @Environment(MangasVM.self) var vm
    @State private var path = NavigationPath()
    @State var visibility: NavigationSplitViewVisibility = .all
    @State var loading = false
    @Environment(\.colorScheme) var colorScheme
    @State var demographicSelected: DTODemographic?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility){
            if loading {
                ProgressView()
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }
//            List(vm.demographics){ demographic in
            List(selection: $demographicSelected){
                ForEach(vm.demographics){ demographic in
                    NavigationLink(value: demographic){
                        Text(demographic.demographic)
                    }
                    .tag(demographic)
                }
            }
            .opacity(loading ? 0.0 : 1.0)
            .navigationTitle("Demográficas")
            .navigationDestination(for: DTODemographic.self){ demographic in
                MangasByDemographicView(demographic: demographic, path: $path)
                    .environment(vm)
            }
            .refreshable {
                Task{
                    await vm.getDemographics()
                }
            }
        } content: { 
//            if let demographicTmp = vm.demographics.first{
            if let demographicSelected{
                MangasByDemographicView(demographic: demographicSelected, path: $path)
                    .environment(vm)
            }
        } detail: {
//            Text("Selecciona un manga")
//            if let demographicTmp = vm.demographics.first{
            if vm.loadingDemographicByiPad{
                ProgressView("Cargando...")
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }else{
                if let demographicSelected{
                    if let mangaTmp = vm.getFirstMangaBy(mangasbyToSord: .byDemographic, idAuthor: UUID(), demographic: demographicSelected.demographic, genre: "", theme: ""){
                        MangaDetailView(manga: mangaTmp, path: $path)
                            .environment(vm)
                    }
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear(){
            vm.estadoPantalla = .demographics
            if vm.demographics.count == 0{
                Task{
                    loading = true
                    await vm.getDemographics()
                    loading = false
                    if demographicSelected == nil{
                        demographicSelected = vm.demographics.first
                    }
                }
            }
        }
    }
}

#Preview {
    DemographicsiPadView()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
