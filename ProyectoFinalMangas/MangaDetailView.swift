//
//  MangaDetailView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 10/1/24.
//

import SwiftUI
import SwiftData

struct MangaDetailView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    let manga: DTOMangas
    @State var mangaRepetido: Bool = false
    @Query(sort: \Manga.id) var mangasCollection: [Manga]
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack{
                headerMangaDetailView(manga: manga)
                    .environment(vm)
                VStack{
                    if let titleManga = manga.title {
                        Text(titleManga)
                            .lineLimit(2)
                            .font(.title)
                            .bold()
                            .minimumScaleFactor(0.7)
                            .multilineTextAlignment(.center)
                    }
                    if let titleManga = manga.titleJapanese {
                        Text(titleManga)
                            .lineLimit(2)
                            .font(.caption)
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
                            Text(getDateFromString(dateString: startDate))
                        }
                        Divider()
                    }
                    if let endDate = manga.endDate{
                        HStack{
                            Text("Fecha de Fin")
                                .bold()
                            Spacer()
                            Text(getDateFromString(dateString: endDate))
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
                    if manga.score > 0{
                        HStack{
                            Text("Puntuación")
                                .bold()
                            Spacer()
                            Text(String(manga.score))
                        }
                        Divider()
                    }
                    if manga.authors.count > 0{
                        HStack(alignment:.top){
                            if manga.authors.count == 1{
                                Text("Autor")
                                    .bold()
                            } else {
                                Text("Autores")
                                    .bold()
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                ForEach(manga.authors){ author in
                                    Text("\(author.firstName) "+"\(author.lastName)")
                                }
                            }
                        }
                        Divider()
                    }
                    if manga.genres.count > 0{
                        HStack(alignment: .top){
                            if manga.genres.count == 1 {
                                Text("Género")
                                    .bold()
                            } else {
                                Text("Géneros")
                                    .bold()
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                ForEach(manga.genres){ genre in
                                    Text(genre.genre)
                                }
                            }
                        }
                        Divider()
                    }
                    if manga.themes.count > 0{
                        HStack(alignment: .top){
                            if manga.themes.count == 1 {
                                Text("Tema")
                                    .bold()
                            } else {
                                Text("Temas")
                                    .bold()
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                ForEach(manga.themes){theme in
                                    Text(theme.theme)
                                }
                            }
                        }
                        Divider()
                    }
                    if manga.demographics.count > 0{
                        HStack(alignment: .top){
                            if manga.demographics.count == 1 {
                                Text("Demográfic")
                                    .bold()
                            } else {
                                Text("Demográficas")
                                    .bold()
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                ForEach(manga.demographics){ demographic in
                                    Text(demographic.demographic)
                                }
                            }
                        }
                        Divider()
                    }
                    if let synopsis = manga.sypnosis{
                        HStack(alignment: .top){
                            Text("Sinopsis")
                                .bold()
                            Spacer()
                            Text(synopsis)
                                .multilineTextAlignment(.trailing)
                        }
                        Divider()
                    }
                    if let background = manga.background{
                        HStack(alignment: .top){
                            Text("Background")
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
        .onAppear(){
            vm.estadoPantalla = .detailManga
        }
        .toolbar {
            if UIDevice.current.userInterfaceIdiom == .phone {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        path.removeLast(vm.stepsView)
                    } label: {
                        Image(systemName: "eraser.line.dashed")
                    }
                }
            }
        }
    }
    
    func getDateFromString (dateString: String) -> String {
        let inputdateFormatter = ISO8601DateFormatter()
        let inputDate = inputdateFormatter.date(from: dateString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        if let inputDateUnrawped = inputDate {
            return dateFormatter.string(from: inputDateUnrawped)
        }else{
            return ""
        }
    }
}

#Preview {
    ScrollView{
        MangaDetailView(manga: .test, path: .constant(NavigationPath()))
            .environment(MangasVM.test)
            .modelContainer(testModelContainer)
    }
}
