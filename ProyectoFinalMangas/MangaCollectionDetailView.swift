//
//  MangaCollectionDetailView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 25/1/24.
//

import SwiftUI
import SwiftData

struct MangaCollectionDetailView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    let manga: Manga
    @State var mangaRepetido: Bool = false
    @Query(sort: \Manga.id) var mangasCollection: [Manga]
    
    var body: some View {
        ScrollView {
            VStack{
                HStack(alignment: .top) {
                    Spacer()
                    MangaView(mangaURL: manga.mainPicture, widthCover: 250, heightCover: 350)
                    Button{
                        if mangasCollection.contains(where: { $0.id == manga.id }){
                            try? vm.eliminarMangaEnMiLibreria(mangaID: manga.id, context: context)
                        }else{
                            try? vm.guardarMangaFromMangaEnMiLibreria(manga: manga, context: context, mangaID: manga.id)
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
                        }
                        
                    }
                }
                VStack{
                    if let titleManga = manga.title {
                        Text(titleManga)
                            .lineLimit(2)
                            .font(.title)
                            .bold()
                            .minimumScaleFactor(0.7)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }
                    if let statusManga = manga.status{
                        HStack{
                            Text("Status")
                                .bold()
                            Spacer()
                            Text(statusManga)
                        }
                        Divider()
                    }
                    if let startDate = manga.startDate{
                        HStack{
                            Text("Fecha de Inicio")
                                .bold()
                            Spacer()
                            Text(startDate.description)
                        }
                        Divider()
                    }
                    if let endDate = manga.endDate{
                        HStack{
                            Text("Fecha de Fin")
                                .bold()
                            Spacer()
                            Text(endDate.description)
                        }
                        Divider()
                    }
                    if let capitulos = manga.chapters{
                        HStack{
                            Text("Capítulos")
                                .bold()
                            Spacer()
                            Text(String(capitulos))
                        }
                        Divider()
                    }
                    if let volumenes = manga.volumes{
                        HStack{
                            Text("Volúmenes")
                                .bold()
                            Spacer()
                            Text(String(volumenes))
                        }
                        Divider()
                    }
                    HStack{
                        Text("Puntuación")
                            .bold()
                        Spacer()
                        Text(String(manga.score))
                    }
                    Divider()
                    if let authors = manga.authors {
                        if authors.count > 0{
                            HStack(alignment:.top){
                                if authors.count == 1{
                                    Text("Autor")
                                        .bold()
                                } else {
                                    Text("Autores")
                                        .bold()
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    ForEach(authors){ author in
                                        Text("\(author.firstName) "+"\(author.lastName)")
                                    }
                                }
                            }
                            Divider()
                        }
                    }
                    if let genres = manga.genres{
                        if genres.count > 0{
                            HStack(alignment: .top){
                                if genres.count == 1 {
                                    Text("Genero")
                                        .bold()
                                } else {
                                    Text("Generos")
                                        .bold()
                                }
                                Spacer()
                                VStack(alignment: .trailing){
                                    ForEach(genres){ genre in
                                        Text(genre.genre)
                                    }
                                }
                            }
                            Divider()
                        }
                    }
                    if let themes = manga.themes {
                        if themes.count > 0{
                            HStack(alignment: .top){
                                if themes.count == 1 {
                                    Text("Tema")
                                        .bold()
                                } else {
                                    Text("Temas")
                                        .bold()
                                }
                                Spacer()
                                VStack(alignment: .trailing){
                                    ForEach(themes){theme in
                                        Text(theme.theme)
                                    }
                                }
                            }
                            Divider()
                        }
                    }
                    if let demographics = manga.demographics {
                        if demographics.count > 0{
                            HStack(alignment: .top){
                                if demographics.count == 1 {
                                    Text("Demográfic")
                                        .bold()
                                } else {
                                    Text("Demográficas")
                                        .bold()
                                }
                                Spacer()
                                VStack(alignment: .trailing){
                                    ForEach(demographics){ demographic in
                                        Text(demographic.demographic)
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    if let synopsis = manga.sypnosis{
                        HStack(alignment: .top){
                            Text("Sinopsis ")
                                .bold()
                            Spacer()
                            Text(synopsis)
                                .multilineTextAlignment(.trailing)
                        }
                        Divider()
                    }
                    if let background = manga.background{
                        HStack(alignment: .top){
                            Text("Background ")
                                .bold()
                            Spacer()
                            Text(background)
                                .multilineTextAlignment(.trailing)
                        }
                        Divider()
                    }
                    if let url = manga.url{
                        let urlRetocada = url.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        HStack(alignment: .top){
                            Text("Link")
                                .bold()
                            Spacer()
                            Link(urlRetocada, destination: URL(string: urlRetocada) ?? URL(string: "https://myanimelist.net")!)
                        }
                        Divider()
                    }
                }
                .padding(.horizontal, 20.0)
            }
       }
    }
    
    func getDateFromString (dateString: String) -> String {
        let inputdateFormatter = ISO8601DateFormatter()
        let inputDate = inputdateFormatter.date(from: dateString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        if let inputDateUnrawped = inputDate {
            return dateFormatter.string(from: inputDateUnrawped)
        }else{
            return ""
        }
    }
}

#Preview {
    MangaCollectionDetailView(manga: Manga.test)
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
