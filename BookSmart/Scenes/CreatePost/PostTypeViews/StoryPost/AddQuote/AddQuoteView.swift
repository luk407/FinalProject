//
//  AddQuoteView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 20.01.24.
//

import SwiftUI

struct AddQuoteView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddQuoteViewModel
    @Binding var selectedQuote: Quote?

    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                searchList
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .customBackgroundColor))
        }
        .searchable(text: $viewModel.searchText, prompt: "Search for a quote")
        .tint(Color(uiColor: .customAccentColor))
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .foregroundStyle(Color(uiColor: .customAccentColor))
    }
    
    // MARK: - Views
    
    private var searchList: some View {
        List {
            ForEach(viewModel.searchResults, id: \.self) { result in
                Text(result.text)
                    .foregroundStyle(Color(uiColor: .customAccentColor))
                    .listRowBackground(Color(uiColor: .customBackgroundColor))
                    .onTapGesture {
                        viewModel.selectedQuote = result
                        selectedQuote = result
                        dismiss()
                    }
            }
        }
        .listStyle(.plain)
    }

}
