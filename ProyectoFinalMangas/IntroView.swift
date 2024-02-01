//
//  IntroView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 31/1/24.
//

import SwiftUI

struct IntroView: View {
    @Environment(MangasVM.self) var vm
    
    @State var loading = false
    @State var appear = false
    @State private var position = 0

    var body: some View {
        ZStack{
            Image(.icono2ProyectoFinalMangas)
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .cornerRadius(20)
                .offset(y: CGFloat(position))
        }
        .animation(.bouncy().speed(0.5), value: position)
        .task {
            Task{
                await vm.getMangasItems()
            }
            try? await Task.sleep(for: .seconds(1.5))
            position = -200
            try? await Task.sleep(for: .seconds(1.5))
            position = 200
            try? await Task.sleep(for: .seconds(1.5))
            position = 0
            try? await Task.sleep(for: .seconds(1))
            vm.appState = .home
        }
    }
}

#Preview {
    IntroView()
        .environment(MangasVM.test)
}
