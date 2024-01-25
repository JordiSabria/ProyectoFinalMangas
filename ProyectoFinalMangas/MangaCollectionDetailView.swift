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
    let dataHoy: Date = Date()
    @State var mangaRepetido: Bool = false
    @Query(sort: \Manga.id) var mangasCollection: [Manga]
    
    var body: some View {
        ScrollView {
            VStack{
                MangaView(mangaURL: manga.mainPicture, widthCover: 250, heightCover: 350)
                    .overlay(alignment: .topTrailing){
                        if mangasCollection.contains(where: {$0.id == manga.id}){
                            CheckCollectionView()
                        }
                    }
                if let titleManga = manga.title {
                    Text(titleManga)
                        .lineLimit(2)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.black)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.center)
                }
                Section {
                    HStack{
                        if let statusManga = manga.status{
                            Text("Status: ")
                                .bold()
                            Text(statusManga)
                        }
                        Spacer()
                    }
                    HStack{
                        if let startDate = manga.startDate{
                            Text("Fecha de Inicio: ")
                                .bold()
                            //Text(getDateFromString(dateString: startDate))
                            Text(startDate.description)
                        }
                        Spacer()
                    }
                    HStack{
                        if let endDate = manga.endDate{
                            Text("Fecha de Fin: ")
                                .bold()
                            //Text(getDateFromString(dateString: endDate))
                            Text(endDate.description)
                        }
                        Spacer()
                    }
                    HStack{
                        if let capitulos = manga.chapters{
                            Text("Capítulos: ")
                                .bold()
                            Text(String(capitulos))
                        }
                        Spacer()
                    }
                    HStack{
                        if let volumenes = manga.volumes{
                            Text("Volúmenes: ")
                                .bold()
                            Text(String(volumenes))
                        }
                        Spacer()
                    }
                    HStack{
                        Text("Puntuación: ")
                            .bold()
                        Text(String(manga.score))
                        Spacer()
                    }
                }
                .padding(.horizontal, 10.0)
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
    MangaCollectionDetailView(manga: .test)
        .environment(MangasVM.test)
        //.modelContainer(testModelContainer)
}
