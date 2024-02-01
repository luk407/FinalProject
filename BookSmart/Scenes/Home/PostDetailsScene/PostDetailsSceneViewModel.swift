//
//  PostDetailsSceneViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 22.01.24.
//

import Foundation
import Firebase


protocol PostDetailsSceneViewDelegateForStory: AnyObject {
    func updateLikeButtonUI(isLiked: Bool)
}

protocol PostDetailsSceneViewDelegateForAnnouncement: AnyObject {
    func updateLikeButtonUI(isLiked: Bool)
}

protocol PostDetailsSceneViewDelegate: AnyObject {
    func postUpdated()
}

final class PostDetailsSceneViewModel {
    
    // MARK: - Properties
    
    var userInfo: UserInfo
    
    var postInfo: PostInfo
    
    var commentsInfo: [CommentInfo]?
    
    weak var delegate: PostDetailsSceneViewDelegate?
    
    weak var storyCellDelegate: PostDetailsSceneViewDelegateForStory?
    
    weak var announcementCellDelegate: PostDetailsSceneViewDelegateForAnnouncement?
    
    private var dispatchGroup = DispatchGroup()
    
    // MARK: - Init
    
    init(userInfo: UserInfo, postInfo: PostInfo) {
        self.userInfo = userInfo
        self.postInfo = postInfo
    }
    
    // MARK: - Methods
    
    func postDetailsSceneViewWillAppear() {
        dispatchGroup.enter()
        commentInfoListener()
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            self.delegate?.postUpdated()
        }
    }
    
    func timeAgoString(from date: Date) -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: currentDate)
        
        if let years = components.year, years > 0 {
            return "\(years)y"
        } else if let months = components.month, months > 0 {
            return "\(months)m"
        } else if let days = components.day, days > 0 {
            return "\(days)d"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m"
        } else {
            return "Now"
        }
    }
    
    // MARK: - Methods for posts
    
    func toggleLikePost() {
        
        let database = Firestore.firestore()
        
        let userReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        let postReference = database.collection("PostInfo").document(postInfo.id.uuidString)
        
        let isLiked = userInfo.likedPosts.contains(postInfo.id)
        
        storyCellDelegate?.updateLikeButtonUI(isLiked: !isLiked)
        announcementCellDelegate?.updateLikeButtonUI(isLiked: !isLiked)
        
        if isLiked {
            userReference.updateData([
                "likedPosts": FieldValue.arrayRemove([postInfo.id.uuidString])
            ]) { [self] error in
                if let error = error {
                    print("Error removing liked post from UserInfo: \(error.localizedDescription)")
                    return
                }
                
                postReference.updateData([
                    "likedBy": FieldValue.arrayRemove([userInfo.id.uuidString])
                ]) { [self] error in
                    if let error = error {
                        print("Error removing user from likedBy in PostInfo: \(error.localizedDescription)")
                        return
                    }
                    
                    if let index = userInfo.likedPosts.firstIndex(of: postInfo.id) {
                        userInfo.likedPosts.remove(at: index)
                    }
                    if let index = postInfo.likedBy.firstIndex(of: userInfo.id) {
                        postInfo.likedBy.remove(at: index)
                    }
                }
            }
        } else {
            userReference.updateData([
                "likedPosts": FieldValue.arrayUnion([postInfo.id.uuidString])
            ]) { [self] error in
                if let error = error {
                    print("Error adding liked post to UserInfo: \(error.localizedDescription)")
                    return
                }
                
                postReference.updateData([
                    "likedBy": FieldValue.arrayUnion([userInfo.id.uuidString])
                ]) { [self] error in
                    if let error = error {
                        print("Error adding user to likedBy in PostInfo: \(error.localizedDescription)")
                        return
                    }
                    userInfo.likedPosts.append(postInfo.id)
                    postInfo.likedBy.append(userInfo.id)
                }
            }
        }
    }
    
    // MARK: - Methods for comments
    
    func commentInfoListener() {
        let commentsIDs = postInfo.comments
        
        guard !commentsIDs.isEmpty else { return }
        
        let database = Firestore.firestore()
        let commentCollection = database.collection("CommentInfo")
        
        commentCollection
            .whereField("id", in: commentsIDs.map { $0.uuidString })
            .addSnapshotListener(includeMetadataChanges: true) { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching comments info: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No comments found.")
                    return
                }
                
                var fetchedComments: [CommentInfo] = []
                
                for document in documents {
                    let data = document.data()
                    
                    guard
                        let commentIDString = data["id"] as? String,
                        let commentID = UUID(uuidString: commentIDString),
                        let authorIDString = data["authorID"] as? String,
                        let authorID = UUID(uuidString: authorIDString),
                        let commentTime = data["commentTime"] as? Timestamp,
                        let body = data["body"] as? String,
                        let likedBy = data["likedBy"] as? [String],
                        let comments = data["comments"] as? [String]
                    else {
                        print("Error parsing comment data")
                        continue
                    }
                    
                    let commentInfo = CommentInfo(
                        id: commentID,
                        authorID: authorID,
                        commentTime: commentTime.dateValue(),
                        body: body,
                        likedBy: likedBy.map { UUID(uuidString: $0) ?? UUID() },
                        comments: comments.map { UUID(uuidString: $0) ?? UUID() }
                    )
                    
                    fetchedComments.append(commentInfo)
                }
                self.commentsInfo = fetchedComments
            }
    }
    
    func submitCommentButtonTapped(commentText: String) {
        let database = Firestore.firestore()
        let postReference = database.collection("PostInfo").document(postInfo.id.uuidString)
        
        let newComment = CommentInfo(
            id: UUID(),
            authorID: userInfo.id,
            commentTime: Date(),
            body: commentText,
            likedBy: [],
            comments: [])
        
        postReference.updateData([
            "comments": FieldValue.arrayUnion([newComment.id.uuidString])
        ]) { [weak self] error in
            guard self != nil else { return }
            
            if let error = error {
                print("Error adding comment to PostInfo: \(error.localizedDescription)")
                return
            }
            
            print("Comment added to Firebase successfully")
            
            self?.updateUserDataWithNewCommentID(commentID: newComment.id)
        }
        
        let commentReference = database.collection("CommentInfo").document(newComment.id.uuidString)
        
        let commentData: [String: Any] = [
            "id": newComment.id.uuidString,
            "authorID": newComment.authorID.uuidString,
            "commentTime": newComment.commentTime,
            "body": newComment.body,
            "likedBy": [],
            "comments": []
        ]
        
        commentReference.setData(commentData)
        
        DispatchQueue.main.async {
            self.delegate?.postUpdated()
        }
    }
    
    private func updateUserDataWithNewCommentID(commentID: UUID) {
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        
        userReference.updateData([
            "comments": FieldValue.arrayUnion([commentID.uuidString])
        ]) { error in
            if let error = error {
                print("Error updating user data with new comment ID: \(error.localizedDescription)")
            } else {
                print("User data updated with new comment ID")
            }
        }
    }
    
    func getCommentInfo(for commentID: UUID) -> CommentInfo? {
        return commentsInfo?.first { $0.id == commentID }
    }
    
    func getAuthorInfo(with authorID: UserInfo.ID, completion: @escaping (UserInfo?) -> Void)  {

        let database = Firestore.firestore()
        let reference = database.collection("UserInfo").document(authorID.uuidString)
        
        reference.getDocument { document, error in
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User not found.")
                return
            }
            
            let data = document.data()
            
            guard
                let id = data?["id"] as? String,
                let username = data?["username"] as? String,
                let email = data?["email"] as? String,
                let password = data?["password"] as? String,
                let displayName = data?["displayName"] as? String,
                let registrationDateTimestamp = data?["registrationDate"] as? Timestamp,
                let bio = data?["bio"] as? String,
                let image = data?["image"] as? String,
                let badgesData = data?["badges"] as? [[String: String]],
                let posts = data?["posts"] as? [String],
                let comments = data?["comments"] as? [String],
                let likedPosts = data?["likedPosts"] as? [String],
                let connections = data?["connections"] as? [String],
                let booksFinishedArray = data?["booksFinished"] as? [[String: Any]],
                let quotesUsedData = data?["quotesUsed"] as? [[String: String]]
            else {
                print("Error parsing user dat")
                return
            }
            
            let badges = self.parseBadgesArray(badgesData)
            let quotesUsed = self.parseQuotesArray(quotesUsedData)
            let booksFinished = self.parseBooksFinishedArray(booksFinishedArray)
            
            let userInfo = UserInfo(
                id: UUID(uuidString: id) ?? UUID(),
                userName: username,
                email: email,
                password: password,
                displayName: displayName,
                registrationDate: registrationDateTimestamp.dateValue(),
                bio: bio,
                image: image,
                badges: badges,
                posts: posts.map { UUID(uuidString: $0) ?? UUID() },
                comments: comments.map { UUID(uuidString: $0) ?? UUID() },
                likedPosts: likedPosts.map { UUID(uuidString: $0) ?? UUID() },
                connections: connections.map { UUID(uuidString: $0) ?? UUID() },
                booksFinished: booksFinished,
                quotesUsed: quotesUsed
            )
            completion(userInfo)
        }
    }
    
    private func parseBooksFinishedArray(_ booksFinishedArray: [[String: Any]]) -> [Book] {
        var booksFinished: [Book] = []
        
        for bookInfo in booksFinishedArray {
            if let title = bookInfo["title"] as? String,
               let authorName = bookInfo["authorName"] as? [String] {
                let book = Book(title: title, authorName: authorName)
                booksFinished.append(book)
            }
        }
        return booksFinished
    }
    
    private func parseBadgesArray(_ badgesData: [[String: String]]) -> [BadgeInfo] {
        
        var badges: [BadgeInfo] = []
        
        for badgeInfo in badgesData {
            if
                let categoryString = badgeInfo["category"],
                let category = BadgeCategory(rawValue: categoryString),
                let typeString = badgeInfo["type"],
                let type = BadgeType(rawValue: typeString)
            {
                let badge = BadgeInfo(category: category, type: type)
                badges.append(badge)
            }
        }
        return badges
    }
    
    private func parseQuotesArray(_ quotesData: [[String: String]]) -> [Quote] {
        var quotes: [Quote] = []
        
        for quoteData in quotesData {
            if let text = quoteData["text"], let author = quoteData["author"] {
                let quote = Quote(text: text, author: author)
                quotes.append(quote)
            }
        }
        
        return quotes
    }
}
