//
//  StateMachine.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 31/1/24.
//

import SwiftUI

enum AppState {
    case intro
    case home
    case noInternet
}

struct ScrollOffset: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = 0.0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

enum search {
    //case allMangas
    case bestMangas
    case authors
    case demographics
    case genres
    case themes
    case superSearch
}

enum estadoPantalla {
    case search
    case authors
    case demographics
    case genres
    case themes
    case mangas
    case detailManga
    case advSearch
}
enum searchFieldMangas {
    case allMangas
    case byAuthor
    case byDemographic
    case byGenre
    case byTheme
}
enum mangasByToSord {
    case byAuthor
    case byDemographic
    case byGenre
    case byTheme
}

