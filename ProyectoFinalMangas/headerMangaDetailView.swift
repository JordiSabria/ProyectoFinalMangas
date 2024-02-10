//
//  headerMangaDetailView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 10/2/24.
//

import SwiftUI
import SwiftData

struct headerMangaDetailView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    let manga: DTOMangas
    @Query(sort: \Manga.id) var mangasCollection: [Manga]
    
    var body: some View {
        HStack(alignment: .top) {
            Spacer()
            MangaView(mangaURL: manga.mainPicture, widthCover: 250, heightCover: 350)
                .offset(x: 30)
            Button{
                if mangasCollection.contains(where: { $0.id == manga.id }){
                    try? vm.eliminarMangaEnMiLibreria(mangaID: manga.id, context: context)
                } else {
                    vm.guardarMangaEnMiLibreria(manga: manga, context: context)
                }
            }label: {
                if mangasCollection.contains(where: { $0.id == manga.id }){
                    Image(systemName: "books.vertical")
                        .font(.largeTitle)
                        .symbolVariant(.circle)
                        .symbolVariant(.fill)
                        .foregroundStyle(.white, .blue)
                        .padding(7)
                }else{
                    Image(systemName: "books.vertical")
                        .font(.largeTitle)
                        .symbolVariant(.circle)
                        .symbolVariant(.fill)
                        .foregroundStyle(.white, .black)
                        .padding(7)
                        .overlay{
                            Circle()
                                .fill(.white.opacity(0.8))
                                .frame(width: 35)
                        }
                }
            }
            .offset(x: 30)
            Spacer()
        }
    }
}

#Preview {
    headerMangaDetailView(manga: .test)
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
