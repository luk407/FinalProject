//
//  AnnouncementPostViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 20.01.24.
//

import Foundation
import Firebase
import GenericNetworkLayer
import Combine
 
final class AnnouncementPostViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var disposeBag = Set<AnyCancellable>()

    @Published var searchText: String = ""
    @Published var isSpoilersAllowed: Bool = false
    @Published var selectedAnnouncementType: AnnouncementType = .startedBook
    @Published var selectedBook: Book? = nil
    
    var userInfo: UserInfo
    
    var booksArray: [Book] = []
    
    var searchResults: [Book] {
        if searchText.isEmpty {
            return []
        } else {
            return booksArray.filter { $0.title.contains(searchText) }
        }
    }
    
    var formattedAuthorNames: String {
        guard let selectedBook = selectedBook else { return "" }
        return selectedBook.authorName?.joined(separator: ", ") ?? ""
    }

    var headerTextForStart: String {
        "\(userInfo.displayName) has just started reading a book \"\(selectedBook?.title ?? "")"
    }
    
    var headerTextForFinish: String {
        "\(userInfo.displayName) has just finished reading a book \"\(selectedBook?.title ?? "")"
    }
    
    var bodyText: String {
        "The book is written by \(formattedAuthorNames)"
    }
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        debounceTextChanges()
    }
    
    // MARK: - Methods
    
    private func debounceTextChanges() {
        $searchText
            .debounce(for: 2, scheduler: RunLoop.main)
        
            .sink {
                self.fetchBooksData(with: $0)
            }
            .store(in: &disposeBag)
    }

    func addPost() {
        if selectedAnnouncementType == .finishedBook {
            let newPost = PostInfo(
                id: UUID(),
                authorID: userInfo.id,
                type: .announcement,
                header: headerTextForFinish,
                body: bodyText,
                postingTime: Date(),
                likedBy: [],
                comments: [],
                spoilersAllowed: isSpoilersAllowed,
                announcementType: selectedAnnouncementType
            )
            
            addPostToFirebase(post: newPost)
            
            updateUserDataOnFirebase(postID: newPost.id)
        } else {
            let newPost = PostInfo(
                id: UUID(),
                authorID: userInfo.id,
                type: .announcement,
                header: headerTextForStart,
                body: bodyText,
                postingTime: Date(),
                likedBy: [],
                comments: [],
                spoilersAllowed: isSpoilersAllowed,
                announcementType: selectedAnnouncementType
            )
            
            addPostToFirebase(post: newPost)
            
            updateUserDataOnFirebase(postID: newPost.id)
        }
    }
    
    private func addPostToFirebase(post: PostInfo) {
        let database = Firestore.firestore()
        let postReference = database.collection("PostInfo").document(post.id.uuidString)
        
        let postData: [String: Any] = [
            "id": post.id.uuidString,
            "authorID": post.authorID.uuidString,
            "type": post.type.rawValue,
            "header": post.header,
            "body": post.body,
            "postingTime": post.postingTime,
            "likedBy": post.likedBy.map { $0.uuidString },
            "comments": post.comments.map { $0.uuidString },
            "spoilersAllowed": post.spoilersAllowed,
            "announcementType": post.announcementType.rawValue
        ]
        
        postReference.setData(postData)
    }
    
    private func updateUserDataOnFirebase(postID: UUID) {
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        
        let updatedPosts = FieldValue.arrayUnion([postID.uuidString])
        
        var updatedFinishedBooks = userInfo.booksFinished
        
        if selectedAnnouncementType == .finishedBook, let selectedBook = selectedBook {
            if !updatedFinishedBooks.contains(selectedBook) {
                updatedFinishedBooks.append(selectedBook)
            }
        }
        
        let userData: [String: Any] = [
            "posts": updatedPosts,
            "booksFinished": updatedFinishedBooks.map { book in
                [
                    "title": book.title,
                    "authorName": book.authorName ?? []
                ]
            }
        ]
        
        userReference.updateData(userData) { error in
            if let error = error {
                print("Error updating user data on Firebase: \(error.localizedDescription)")
            }
        }
    }

    func fetchBooksData(with titleString: String) {
        guard let url = URL(string: "https://openlibrary.org/search.json?title=\(titleString)#") else { return }
        
        NetworkManager().request(with: url) { [ weak self ] (result: Result<BooksData, Error>) in
            switch result {
            case .success(let books):
                self?.booksArray = books.docs
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
