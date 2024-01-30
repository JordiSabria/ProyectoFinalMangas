//
//  DemographicsView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 16/1/24.
//

import SwiftUI

struct DemographicsView: View {
    @Environment(MangasVM.self) var vm
    @Binding var path: NavigationPath
    
    var body: some View {
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
        .onAppear(){
            vm.estadoPantalla = .demographics
            if vm.demographics.count == 0{
                Task{
                    await vm.getDemographics()
                }
            }
//            switch vm.estadoPantalla{
//                case .search:
//                    vm.estadoPantalla = .demographics
//                    Task{
//                        await vm.getDemographics()
//                    }
//                default:
//                    vm.estadoPantalla = .demographics
//                }
        }
    }
}
#Preview {
    NavigationStack {
        DemographicsView(path: .constant(NavigationPath()))
            .environment(MangasVM.test)
    }
}
