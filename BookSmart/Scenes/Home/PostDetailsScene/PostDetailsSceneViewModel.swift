//
//  PostDetailsSceneViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 22.01.24.
//

import Foundation
import Firebase


protocol PostDetailsSceneViewDelegateForCells: AnyObject {
    func updateLikeButtonUI(isLiked: Bool)
}

protocol PostDetailsSceneViewDelegate: AnyObject {
    func postUpdated()
}

final class PostDetailsSceneViewModel {
    
    // MARK: - Properties
    
    var userInfo: UserInfo
    
    var postInfo: PostInfo
    
    var commentInfo: [CommentInfo]?
    
    weak var delegate: PostDetailsSceneViewDelegate?
    
    weak var postCellDelegate: PostDetailsSceneViewDelegateForCells?
    
    weak var commentCellDelegate: PostDetailsSceneViewDelegateForCells?
    
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
        
        postCellDelegate?.updateLikeButtonUI(isLiked: !isLiked)
        
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
        
        let isLiked = postInfo.likedBy.contains(userInfo.id)
        
        commentCellDelegate?.updateLikeButtonUI(isLiked: !isLiked)
        
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
                self.commentInfo = fetchedComments
            }
    }
    
    func toggleLikeComment(commentInfo: CommentInfo?) {
        
        guard let commentInfo = commentInfo else { return }
        
        let database = Firestore.firestore()
        
        let commentReference = database.collection("CommentInfo").document(commentInfo.id.uuidString)
        print("CommentInfo ID: \(commentInfo.id)")
        print("UserInfo ID: \(userInfo.id)")
        print("LikedBy: \(commentInfo.likedBy)")
        
        let isLiked = commentInfo.likedBy.contains(userInfo.id)
        print("IsLiked: \(isLiked)")
        commentCellDelegate?.updateLikeButtonUI(isLiked: !isLiked)
        
        if isLiked {
            commentReference.updateData([
                "likedBy": FieldValue.arrayRemove([userInfo.id.uuidString])
            ]) { [self] error in
                if let error = error {
                    print("Error removing user from likedBy in comment: \(error.localizedDescription)")
                    return
                }
                
                if let indexOfUser = commentInfo.likedBy.firstIndex(of: userInfo.id) {
                    if  let indexOfComment = self.commentInfo?.firstIndex(of: commentInfo) {
                        self.commentInfo?[indexOfComment].comments.remove(at: indexOfUser)
                    }
                }
            }
        } else {
            commentReference.updateData([
                "likedBy": FieldValue.arrayUnion([userInfo.id.uuidString])
            ]) { error in
                if let error = error {
                    print("Error adding user to likedBy in comment: \(error.localizedDescription)")
                    return
                }
                
                if let indexOfComment = self.commentInfo?.firstIndex(of: commentInfo) {
                    self.commentInfo?[indexOfComment].likedBy.append(self.userInfo.id)
                }
            }
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
            
            //            self.fetchPostsInfo()
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
    }
    
    func getCommentInfo(for commentID: UUID) -> CommentInfo? {
        return commentInfo?.first { $0.id == commentID }
    }
    
    func getAuthorInfo(with authorID: UserInfo.ID) -> UserInfo? {
        
        var authorInfo: UserInfo?
        
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo")
        
        reference.getDocuments { [weak self] snapshot, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                return
            }
            
            for document in snapshot.documents {
                let data = document.data()
                
                guard
                    let id = data["id"] as? String,
                    let username = data["username"] as? String,
                    let email = data["email"] as? String,
                    let password = data["password"] as? String,
                    let displayName = data["displayName"] as? String,
                    let registrationDateTimestamp = data["registrationDate"] as? Timestamp,
                    let bio = data["bio"] as? String,
                    let image = data["image"] as? String,
                    let badges = data["badges"] as? [BadgeInfo],
                    let posts = data["posts"] as? [String],
                    let comments = data["comments"] as? [String],
                    let likedPosts = data["likedPosts"] as? [String],
                    let connections = data["connections"] as? [String],
                    let booksFinishedArray = data["booksFinished"] as? [[String: Any]],
                    let quotesUsed = data["quotesUsed"] as? [Quote]
                else {
                    print("Error parsing user data")
                    continue
                }
                
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
                    booksFinished: self.parseBooksFinishedArray(booksFinishedArray),
                    quotesUsed: quotesUsed
                )
                authorInfo = userInfo
            }
        }
        return authorInfo
    }
    
    private func parseBooksFinishedArray(_ booksFinishedArray: [[String: Any]]) -> [Book] {
        var booksFinished: [Book] = []
        
        for bookInfo in booksFinishedArray {
            if let title = bookInfo["title"] as? String,
               let authorName = bookInfo["author"] as? [String] {
                let book = Book(title: title, authorName: authorName)
                booksFinished.append(book)
            }
        }
        return booksFinished
    }
    
}


