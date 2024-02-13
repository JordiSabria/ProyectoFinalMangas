//
//  AppStateView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 31/1/24.
//

import SwiftUI

struct AppStateView: View {
    @Environment(MangasVM.self) var vm
    @State var networkStatus = NetworkStatus()
    @State var lastState: AppState = .intro
    
    var body: some View {
        Group{
            switch vm.appState{
            case .intro:
                IntroView()
                    .environment(vm)
            case .home:
                #if os(iOS)
                if UIDevice.current.userInterfaceIdiom == .pad{
                    MangasMainIpadView()
                        .environment(vm)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }else{
                    MangasMain()
                        .environment(vm)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                #else
                MangasMainIpadView()
                    .environment(vm)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                #endif
            case .noInternet:
                NoConnectionView()
                    .transition(.opacity)
            }
        }
        .animation(.easeIn, value: vm.appState)
        .onChange(of: networkStatus.status) {
            if networkStatus.status == .offline {
                lastState = vm.appState
                vm.appState = .noInternet
            } else {
                vm.appState = lastState
            }
        }
    }
}

#Preview {
    AppStateView()
        .environment(MangasVM.test)
}
