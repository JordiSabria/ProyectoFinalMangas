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
    let anchoPantalla = UIScreen.main.bounds.width
    let altoPantalla = UIScreen.main.bounds.height
    @State var positionRelative = Position(x:0, y:0)
    @State private var positionY: CGFloat = 0
    @State private var positionX: CGFloat = 0
    @State private var tamaño: CGFloat = 100

    var body: some View {
        ZStack{
            Image(.icono2ProyectoFinalMangas)
                .resizable()
                .scaledToFit()
                .frame(width: tamaño)
                .cornerRadius(20)
                .offset(x: positionRelative.x, y: positionRelative.y)
        }
        .animation(.bouncy().speed(0.5), value: positionRelative.x)
        .animation(.bouncy().speed(0.5), value: positionRelative.y)
        .task {
//            Task{
//                await vm.getMangasItems()
//            }
            try? await Task.sleep(for: .seconds(1.5))
            moveToPosition(posicion: 1)
            tamaño = 120
            try? await Task.sleep(for: .seconds(1.5))
            moveToPosition(posicion: 2)
            tamaño = 140
            try? await Task.sleep(for: .seconds(1.5))
            moveToPosition(posicion: 3)
            tamaño = 160
            try? await Task.sleep(for: .seconds(1.5))
            moveToPosition(posicion: 4)
            tamaño = 180
            try? await Task.sleep(for: .seconds(1.5))
            moveToPosition(posicion: 5)
            tamaño = 200
            try? await Task.sleep(for: .seconds(1))
            vm.appState = .home
        }
    }
    func moveToPosition(posicion: CGFloat) {
        
        switch posicion {
        case 1:
            if (anchoPantalla < altoPantalla){
                positionRelative.y = -(altoPantalla/2*60/100)
                positionRelative.x = -(anchoPantalla/2*60/100)
            } else {
                positionRelative.y = -(altoPantalla/2*55/100)
                positionRelative.x = -(anchoPantalla/2*60/100)
            }
        case 2:
            if (anchoPantalla < altoPantalla){
                positionRelative.y = (altoPantalla/2*60/100)
                positionRelative.x = -(anchoPantalla/2*55/100)
            } else {
                positionRelative.y = (altoPantalla/2*60/100)
                positionRelative.x = -(anchoPantalla/2*60/100)
            }
        case 3:
            if (anchoPantalla < altoPantalla){
                positionRelative.y = -(altoPantalla/2*60/100)
                positionRelative.x = (anchoPantalla/2*50/100)
            } else {
                positionRelative.y = -(altoPantalla/2*45/100)
                positionRelative.x = (anchoPantalla/2*60/100)
            }
        case 4:
            if (anchoPantalla < altoPantalla){
                positionRelative.y = (altoPantalla/2*60/100)
                positionRelative.x = (anchoPantalla/2*45/100)
            } else {
                positionRelative.y = (altoPantalla/2*50/100)
                positionRelative.x = (anchoPantalla/2*60/100)
            }
        case 5:
            positionRelative.y = 0
            positionRelative.x = 0
        default:
            positionRelative.y = 0
            positionRelative.x = 0
        }
    }
}

#Preview {
    IntroView()
        .environment(MangasVM.test)
}
