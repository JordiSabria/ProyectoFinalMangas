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
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//            if( !vm.mangasItemsArray.isEmpty ){
//                Text(String(vm.mangasItemsArray.count))
//            }
//        }
        List{
            Text(String(vm.mangasItemsArray.count))
            ForEach (vm.mangasItemsArray) { mangaItem in  
                ForEach (mangaItem.items){ manga in
                    if let mangaUn = manga.title {
                        Text(mangaUn)
                    }
                }
            }
        }
        .padding()
//        .onAppear(){
//            Task{
//                await vm.getMangasItems()
//            }
//        }
    }
    
}

#Preview {
    ContentView()
        .environment(MangasVM())
}
