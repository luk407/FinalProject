//
//  PostDetailsSceneViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 22.01.24.
//

import Foundation
import Firebase

protocol PostDetailsSceneViewDelegateForPostCell: AnyObject {
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
    
    weak var postCellDelegate: PostDetailsSceneViewDelegateForPostCell?
    
    // MARK: - Init
    
    init(userInfo: UserInfo, postInfo: PostInfo) {
        self.userInfo = userInfo
        self.postInfo = postInfo
        
        commentInfoListener()
    }
    
    // MARK: - Methods
    
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
                    print("done")
                    userInfo.likedPosts.append(postInfo.id)
                    postInfo.likedBy.append(userInfo.id)
                }
            }
        }
    }
    
//    private func fetchPostsInfo() {
//        let database = Firestore.firestore()
//        let reference = database.collection("PostInfo").document(postInfo.id.uuidString)
//        
//        reference.addSnapshotListener { [weak self] document, error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Error fetching posts: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let document = document, document.exists else {
//                print("Document does not exist")
//                return
//            }
//            
//            let data = document.data()
//            
//            guard
//                let id = data?["id"] as? String,
//                let authorIDString = data?["authorID"] as? String,
//                let authorID = UUID(uuidString: authorIDString),
//                let typeString = data?["type"] as? String,
//                let header = data?["header"] as? String,
//                let body = data?["body"] as? String,
//                let postingTimeTimestamp = data?["postingTime"] as? Timestamp,
//                let likedBy = data?["likedBy"] as? [String],
//                let comments = data?["comments"] as? [String],
//                let spoilersAllowed = data?["spoilersAllowed"] as? Bool,
//                let announcementTypeString = data?["announcementType"] as? String
//            else {
//                print("Error parsing post data")
//                return
//            }
//            
//            if let type = PostType(rawValue: typeString),
//               let announcementType = AnnouncementType(rawValue: announcementTypeString) {
//                
//                let upToDatePost = PostInfo(
//                    id: UUID(uuidString: id) ?? UUID(),
//                    authorID: authorID,
//                    type: type,
//                    header: header,
//                    body: body,
//                    postingTime: postingTimeTimestamp.dateValue(),
//                    likedBy: likedBy.map { UUID(uuidString: $0) ?? UUID() },
//                    comments: comments.map { UUID(uuidString: $0) ?? UUID() },
//                    spoilersAllowed: spoilersAllowed,
//                    announcementType: announcementType
//                )
//                
//                self.postInfo = upToDatePost
//                
//                self.delegate?.postUpdated()
//            }
//        }
//    }
    
    // MARK: - Methods for comments
    
    func commentInfoListener() {
        let commentsIDs = postInfo.comments
        
        let database = Firestore.firestore()
        let commentCollection = database.collection("CommentInfo")
        database.clearPersistence()

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
                
                // delegate update ui
            }
    }
    
    func toggleLikeComment(commentInfo: CommentInfo?) {

        guard let commentInfo else { return }
        
        let database = Firestore.firestore()
        
        let userReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        let commentReference = database.collection("CommentInfo").document(commentInfo.id.uuidString)
        
        let isLiked = commentInfo.likedBy.contains(userInfo.id)
        
        if isLiked {
            userReference.updateData([
                "likedComments": FieldValue.arrayRemove([commentInfo.id.uuidString])
            ]) { [self] error in
                if let error = error {
                    print("Error removing liked comment from user: \(error.localizedDescription)")
                    return
                }
                
                commentReference.updateData([
                    "likedBy": FieldValue.arrayRemove([userInfo.id.uuidString])
                ]) { error in
                    if let error = error {
                        print("Error removing user from likedBy in comment: \(error.localizedDescription)")
                        return
                    }
                    
//                    if let index = commentInfo.likedBy.firstIndex(of: userInfo.id) {
//                        self.commentInfo.likedBy.remove(at: index)
//                    }
                    // delegate update like
                }
            }
        } else {
            userReference.updateData([
                "likedComments": FieldValue.arrayUnion([commentInfo.id.uuidString])
            ]) { [self] error in
                if let error = error {
                    print("Error adding liked comment to user: \(error.localizedDescription)")
                    return
                }
                
                commentReference.updateData([
                    "likedBy": FieldValue.arrayUnion([userInfo.id.uuidString])
                ]) { error in
                    if let error = error {
                        print("Error adding user to likedBy in comment: \(error.localizedDescription)")
                        return
                    }
                    
                    //self.commentInfo?.likedBy.append(userInfo.id)
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

}


