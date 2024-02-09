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
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility){
            if loading {
                ProgressView()
                    .controlSize(.regular)
                    .tint(colorScheme == .dark ? .white : .black)
            }
            List(vm.demographics){ demographic in
                NavigationLink(value: demographic){
                    Text(demographic.demographic)
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
            if let demographicTmp = vm.demographics.first{
                MangasByDemographicView(demographic: demographicTmp, path: $path)
                    .environment(vm)
            }
        } detail: {
            Text("Selecciona un manga")
//            if let demographicTmp = vm.demographics.first{
//                if let mangaTmp = vm.getFirstMangaBy(mangasbyToSord: .byDemographic, idAuthor: UUID(), demographic: demographicTmp.demographic, genre: "", theme: ""){
//                    MangaDetailView(manga: mangaTmp, path: $path)
//                        .environment(vm)
//                }
//            }
        }
        .onAppear(){
            vm.estadoPantalla = .demographics
            if vm.demographics.count == 0{
                Task{
                    loading = true
                    await vm.getDemographics()
                    loading = false
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
