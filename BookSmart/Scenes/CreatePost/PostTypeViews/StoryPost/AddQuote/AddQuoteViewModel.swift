//
//  AddQuoteViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 20.01.24.
//

import Foundation
import GenericNetworkLayer

final class AddQuoteViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published var searchText: String = ""
    @Published var selectedQuote: Quote?
    
    var quotesArray: [Quote] = []
    
    var searchResults: [Quote] {
        if searchText.isEmpty {
            return []
        } else {
            return quotesArray.filter { $0.text.contains(searchText) }
        }
    }
    
    init() {
        fetchQuotesData()
    }

    // MARK: - Methods
    
    func fetchQuotesData() {
        guard let url = URL(string: "https://mocki.io/v1/8a037bf0-1240-4620-97ad-ebd8abded49d#") else { return }
        
        NetworkManager().request(with: url) { [ weak self ] (result: Result<[Quote], Error>) in
            switch result {
            case .success(let quotes):
                self?.quotesArray = quotes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
