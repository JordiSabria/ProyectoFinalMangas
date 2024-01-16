//
//  DemographicsView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 16/1/24.
//

import SwiftUI

struct DemographicsView: View {
    @Environment(MangasVM.self) var vm
    
    var body: some View {
        Text(String(vm.demographics.count))
        List(vm.demographics, id: \.self){ demographic in
            Text(demographic)
        }
        .navigationTitle("Autores")
        .onAppear(){
            if vm.demographics.count == 0 {
                Task{
                    await vm.getDemographics()
                }
            }
        }
    }
}
#Preview {
    DemographicsView()
        .environment(MangasVM())
}
