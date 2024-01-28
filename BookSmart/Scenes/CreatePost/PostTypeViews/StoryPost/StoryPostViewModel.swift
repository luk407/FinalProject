//
//  StoryPostViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 20.01.24.
//

import Foundation
import Firebase

final class StoryPostViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var headerText: String = ""
    @Published var bodyText: String = ""
    @Published var isSpoilersAllowed: Bool = false
    @Published var isAddPostSheetPresented: Bool = false
    @Published var selectedQuotes: [Quote] = []
    
    var userInfo: UserInfo
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    // MARK: - Methods
    
    func addQuote(_ quote: Quote) {
        selectedQuotes.append(quote)
    }
    
    func addPost() {
        let newPost = PostInfo(
            id: UUID(),
            authorID: userInfo.id,
            type: .story,
            header: headerText,
            body: bodyText,
            postingTime: Date(),
            likedBy: [],
            comments: [],
            spoilersAllowed: isSpoilersAllowed,
            announcementType: .none
        )
        
        addPostToFirebase(post: newPost)
        
        addQuotesToFirebase(quotes: selectedQuotes)

        updateUserDataOnFirebase(postID: newPost.id)
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
    
    private func addQuotesToFirebase(quotes: [Quote]) {
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        
        let quotesData: [[String: Any]] = quotes.map { quote in
            return [
                "text": quote.text,
                "author": quote.author
            ]
        }
        
        userReference.updateData(["quotesUsed": FieldValue.arrayUnion(quotesData)]) { error in
            if let error = error {
                print("Error updating user quotes on Firebase: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUserDataOnFirebase(postID: UUID) {
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        
        userReference.updateData(["posts": FieldValue.arrayUnion([postID.uuidString])]) { error in
            if let error = error {
                print("Error updating user data on Firebase: \(error.localizedDescription)")
            }
        }
    }
}
