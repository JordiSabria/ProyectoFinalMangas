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
                        TitleMangaView(titleManga: titleManga)
                    }
                    if let titleJapaneseManga = manga.titleJapanese {
                        TitleJapaneseView(titleJapaneseManga: titleJapaneseManga)
                    }
                    if let statusManga = manga.status{
                        RowInfoView(title: "Status", info: statusManga)
                    }
                    if let startDate = manga.startDate{
                        RowInfoView(title: "Fecha de Inicio", info: getDateFromString(dateString: startDate))
                    }
                    if let endDate = manga.endDate{
                        RowInfoView(title: "Fecha de Fin", info: getDateFromString(dateString: endDate))
                    }
                    if let capitulos = manga.chapters{
                        RowInfoView(title: "Capítulos", info: String(capitulos))
                    }
                    if let volumenes = manga.volumes{
                        RowInfoView(title: "Volúmenes", info: String(volumenes))
                    }
                    if manga.score > 0{
                        RowInfoView(title: "Puntuación", info: String(manga.score))
                    }
                    MultiLineInfoView(titleSing: "Autor",titlePlur:"Autores", items: manga.authors) { author in
                        Text("\(author.firstName) \(author.lastName)")
                    }
                    MultiLineInfoView(titleSing: "Gérero", titlePlur: "Géneros", items: manga.genres){ genre in
                        Text(genre.genre)
                    }
                    MultiLineInfoView(titleSing: "Tema", titlePlur: "Temas", items: manga.themes){ theme in
                        Text(theme.theme)
                    }
                    MultiLineInfoView(titleSing: "Demográfic", titlePlur: "Demográficas", items: manga.demographics){ demographic in
                        Text(demographic.demographic)
                    }
                    if let synopsis = manga.sypnosis{
                        RowMultiLineInfoView(title: "Sinopsis", info: synopsis)
                    }
                    if let background = manga.background{
                        RowMultiLineInfoView(title: "Background", info: background)
                    }
                    if let url = manga.url{
                        RowURLView(url: url)
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
    func MultiLineInfoView<T: Identifiable, Content: View>(titleSing: String, titlePlur: String, items: [T], @ViewBuilder content: @escaping (T) -> Content) -> some View {
        Group { // Usamos Group como un contenedor neutral
            if items.count > 0 {
                HStack(alignment: .top) {
                    Text(items.count == 1 ? titleSing : titlePlur)
                        .bold()
                    Spacer()
                    VStack(alignment: .trailing) {
                        ForEach(items) { item in
                            content(item)
                        }
                    }
                }
                Divider()
            }
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
