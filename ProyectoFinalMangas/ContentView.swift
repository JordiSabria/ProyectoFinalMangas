//
//  ContentView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 3/1/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(MangasVM.self) var vm
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(){
            Task{
                await vm.getMangasItems()
            }
        }
    }
    
}

#Preview {
    ContentView()
        .environment(MangasVM())
}
