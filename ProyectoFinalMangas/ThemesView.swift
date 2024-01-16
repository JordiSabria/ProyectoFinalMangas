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
        Text(String(vm.themes.count))
        List(vm.themes, id: \.self){ theme in
            Text(theme)
        }
        .navigationTitle("Temáticas")
        .onAppear(){
            if vm.themes.count == 0 {
                Task{
                    await vm.getThemes()
                }
            }
        }
    }
}

#Preview {
    ThemesView()
        .environment(MangasVM())
}
