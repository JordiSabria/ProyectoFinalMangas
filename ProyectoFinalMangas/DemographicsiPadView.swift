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
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility){
            List(vm.demographics){ demographic in
                NavigationLink(value: demographic){
                    Text(demographic.demographic)
                }
            }
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
            if let demographicTmp = vm.demographics.first{
                if let mangaTmp = vm.getFirstMangaBy(mangasbyToSord: .byDemographic, idAuthor: UUID(), demographic: demographicTmp.demographic, genre: "", theme: ""){
                    MangaDetailView(manga: mangaTmp, path: $path)
                        .environment(vm)
                }
            }
        }
        .onAppear(){
            vm.estadoPantalla = .demographics
            if vm.demographics.count == 0{
                Task{
                    await vm.getDemographics()
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
