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
        List{
            Text(String(vm.mangasItemsArray.count))
            //Text(String(vm.mangasArray.count))
            ForEach (vm.mangasItemsArray){ mangaItems in
                ForEach (mangaItems.items){ mangaItem in
                    MangaView(mangaURL: mangaItem.mainPicture, widthCover: 150, heightCover: 230)
                }
            }
//            ForEach (vm.mangasArray) { manga in
//                MangaView(manga: manga)
//            }
        }
        .padding()
    }
    
}

#Preview {
    ContentView()
        .environment(MangasVM())
}
