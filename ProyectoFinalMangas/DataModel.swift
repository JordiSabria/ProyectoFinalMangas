//
//  DataModel.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 23/1/24.
//

import Foundation
import SwiftData

@Model
final class Manga {
    @Attribute(.unique) let id: Int
    let title: String?
    let titleEnglish: String?
    let titleJapanese: String?
    let status: String?
    let startDate: Date? // Haig de passar-ho a Date
    let endDate: Date? // Haig de passar-ho a Date
    let chapters: Int?
    let volumes: Int?
    let score: Double
    @Relationship(inverse: \MangaAuthor.author) var authors: [Author]?
    @Relationship(inverse: \MangaGenre.genre) var genres: [Genre]?
    @Relationship(inverse: \MangaTheme.theme) var themes: [Theme]?
    @Relationship(inverse: \MangaDemographic.demographic) var demographics: [Demographic]?
    let sypnosis: String?
    let background: String?
    let mainPicture: String?
    let url: String?
    
    init(id: Int, title: String?, titleEnglish: String?, titleJapanese: String?, status: String?, startDate: Date?, endDate: Date?, chapters: Int?, volumes: Int?, score: Double, authors: [Author], genres: [Genre], themes: [Theme], demographics: [Demographic], sypnosis: String?, background: String?, mainPicture: String?, url: String?) {
        self.id = id
        self.title = title
        self.titleEnglish = titleEnglish
        self.titleJapanese = titleJapanese
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
        self.chapters = chapters
        self.volumes = volumes
        self.score = score
        self.authors = authors
        self.genres = genres
        self.themes = themes
        self.demographics = demographics
        self.sypnosis = sypnosis
        self.background = background
        self.mainPicture = mainPicture
        self.url = url
    }
}
@Model
final class MangaAuthor {
    @Relationship(deleteRule: .nullify) let manga: Manga
    @Relationship(deleteRule: .nullify) let author: Author
    
    init(manga: Manga, author: Author) {
        self.manga = manga
        self.author = author
    }
}
@Model
final class Author {
    @Attribute(.unique) let id: UUID
    let firstName: String
    let lastName: String
    let role: String
    @Relationship(inverse: \MangaAuthor.manga) var mangas: [Manga]?
    
    init(id: UUID, firstName: String, lastName: String, role: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
    }
}
@Model
final class MangaGenre {
    @Relationship(deleteRule: .nullify) let manga: Manga
    @Relationship(deleteRule: .nullify) let genre: Genre
    
    init(manga: Manga, genre: Genre) {
        self.manga = manga
        self.genre = genre
    }
}
@Model
final class Genre {
    @Attribute(.unique) let id: UUID
    let genre: String
    @Relationship(inverse: \MangaGenre.manga) var mangas: [Manga]?
    
    init(id: UUID, genre: String) {
        self.id = id
        self.genre = genre
    }
}
@Model
final class MangaTheme {
    @Relationship(deleteRule: .nullify) let manga: Manga
    @Relationship(deleteRule: .nullify) let theme: Theme
    
    init(manga: Manga, theme: Theme) {
        self.manga = manga
        self.theme = theme
    }
}
@Model
final class Theme {
    @Attribute(.unique) let id: UUID
    let theme: String
    @Relationship(inverse: \MangaTheme.manga) var mangas: [Manga]?
    
    init(id: UUID, theme: String) {
        self.id = id
        self.theme = theme
    }
}
@Model
final class MangaDemographic {
    @Relationship(deleteRule: .nullify) let manga: Manga
    @Relationship(deleteRule: .nullify) let demographic: Demographic
    
    init(manga: Manga, demographic: Demographic) {
        self.manga = manga
        self.demographic = demographic
    }
}
@Model
final class Demographic {
    @Attribute(.unique) let id: UUID
    let demographic: String
    @Relationship(inverse: \MangaDemographic.manga) var mangas: [Manga]?
    
    init(id: UUID, demographic: String) {
        self.id = id
        self.demographic = demographic
    }
}
