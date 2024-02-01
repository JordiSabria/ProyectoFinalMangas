//
//  NoConnectionView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 31/1/24.
//

import SwiftUI

struct NoConnectionView: View {
    var body: some View {
        ContentUnavailableView("No hay Internet", systemImage: "wifi.exclamationmark",
                               description: Text("No hay conexión a internet. Esta aplicación necesita de una conexión a internet para funcionar."))
    }
}

#Preview {
    NoConnectionView()
}
