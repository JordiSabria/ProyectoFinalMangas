//
//  AdvancedSearchFieldView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 22/1/24.
//

import SwiftUI

struct AdvancedSearchTextFieldView: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        let localized = NSLocalizedString(label, comment: "The label of the text field")
        VStack(alignment: .leading) {
            Text(localized.capitalized)
                .font(.headline)
                .padding(.leading, 10)
            HStack {
                TextField("Introduce el \(localized.lowercased())", text: $text)
                    .foregroundStyle(.black)
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark")
                        .symbolVariant(.fill)
                        .symbolVariant(.circle)
                }
                .buttonStyle(.plain)
                .opacity(text.isEmpty ? 0.0 : 0.5)
            }
            .padding(10)
            .background {
                Color(white: 0.95)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    AdvancedSearchTextFieldView(label: "Título", text: .constant("Monster"))
}
