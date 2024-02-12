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
    @Bindable var manga: Manga
    @State var mangaRepetido: Bool = false
    @Query(sort: \Manga.id) var mangasCollection: [Manga]
    
    @State private var showAlert = false
    
    init(mangaR: Manga){
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
        manga = mangaR
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center){
                headerMangaCollectionDetailView(manga: manga)
                    .environment(vm)
                VStack{
                    if let titleManga = manga.title {
                        TitleMangaView(titleManga: titleManga)
                    }
                    if let titleJapaneseManga = manga.titleJapanese {
                        TitleJapaneseView(titleJapaneseManga: titleJapaneseManga)
                    }
                    if let capitulos = manga.chapters{
                        RowInfoView(title: "Capítulos", info: String(capitulos))
                    }
                    if let volumenes = manga.volumes{
                        RowInfoView(title: "Volúmenes", info: String(volumenes))
                    }
                    if let _ = manga.volumes{
                        Stepper(value: $manga.volumesBuyed, in: 0...(manga.volumes ?? 0)){
                            Text("Volúmenes Comprados:   \(manga.volumesBuyed)")
                        }
                        .foregroundStyle(Color.blue)
                    }else{
                        Stepper(value: $manga.volumesBuyed, in: 0...100){
                            Text("Volúmenes Comprados:   \(manga.volumesBuyed)")
                        }
                        .foregroundStyle(Color.blue)
                    }
                    Divider()
                    if let _ = manga.volumes{
                        Stepper(value: $manga.volumeReading, in: 0...(manga.volumes ?? 0)){
                            Text("Volúmen actual de lectura:   \(manga.volumeReading)")
                        }
                        .foregroundStyle(Color.blue)
                    }else{
                        Stepper(value: $manga.volumeReading, in: 0...100){
                            Text("Volúmen actual de lectura:   \(manga.volumeReading)")
                        }
                        .foregroundStyle(Color.blue)
                    }
                    Divider()
                    Toggle(isOn: $manga.completCollection) {
                        Text("Colección Completa")
                    }
                    .foregroundStyle(.blue)
                    Divider()
                    if manga.score > 0{
                        RowInfoView(title: "Puntuación", info: String(manga.score))
                    }
                    if let statusManga = manga.status{
                        RowInfoView(title: "Status", info: statusManga)
                    }
                    if let startDate = manga.startDate{
                        RowInfoView(title: "Fecha de Inicio", info: getDateFormatted(startDate))
                    }
                    if let endDate = manga.endDate{
                        RowInfoView(title: "Fecha de Fin", info: getDateFormatted(endDate))
                    }
                    MultiLineInfoView(titleSing: "Autor",titlePlur:"Autores", items: manga.authors ?? []) { author in
                        Text("\(author.firstName) \(author.lastName)")
                    }
                    MultiLineInfoView(titleSing: "Gérero", titlePlur: "Géneros", items: manga.genres ?? []){ genre in
                        Text(genre.genre)
                    }
                    MultiLineInfoView(titleSing: "Tema", titlePlur: "Temas", items: manga.themes ?? []){ theme in
                        Text(theme.theme)
                    }
                    MultiLineInfoView(titleSing: "Demográfic", titlePlur: "Demográficas", items: manga.demographics ?? []){ demographic in
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
            .onChange(of: manga.volumeReading){
                if manga.volumeReading > manga.volumesBuyed {showAlert = true}
            }
            .alert("Veo que algún amigo te ha dejado un volumen que no tenías, eh! 😉 Espero que le hayas dejado tú uno. Hay que ser un buen amigo.", isPresented: $showAlert){
                Button("Aceptar"){
                }
            }
       }
    }
    func getDateFormatted(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            return formatter.string(from: date)
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
    MangaCollectionDetailView(mangaR: Manga.test)
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
