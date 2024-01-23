//
//  PostDetailsSceneViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 22.01.24.
//

import Foundation
import Firebase

protocol PostDetailsSceneViewDelegate: AnyObject {
    func updateLikeButtonUI(isLiked: Bool)
}

final class PostDetailsSceneViewModel {
    
    // MARK: - Properties
    
    var userInfo: UserInfo
    
    var postInfo: PostInfo
    
    weak var delegate: PostDetailsSceneViewDelegate?
    
    // MARK: - Init
    
    init(userInfo: UserInfo, postInfo: PostInfo) {
        self.userInfo = userInfo
        self.postInfo = postInfo
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

    func toggleLikePost() {

        let database = Firestore.firestore()
        
        let userReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        let postReference = database.collection("PostInfo").document(postInfo.id.uuidString)
        
        let isLiked = userInfo.likedPosts.contains(postInfo.id)
        
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
                    
                    delegate?.updateLikeButtonUI(isLiked: false)
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
                    
                    delegate?.updateLikeButtonUI(isLiked: true)
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
            guard let self = self else { return }

            if let error = error {
                print("Error adding comment to PostInfo: \(error.localizedDescription)")
                return
            }

            print("Comment added to Firebase successfully")

            self.fetchPostsInfo()
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

    private func fetchPostsInfo() {
        let database = Firestore.firestore()
        let reference = database.collection("PostInfo")

        reference.getDocuments() { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            guard let self = self else { return }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    guard
                        let id = data["id"] as? String,
                        let authorIDString = data["authorID"] as? String,
                        let authorID = UUID(uuidString: authorIDString),
                        let typeString = data["type"] as? String,
                        let header = data["header"] as? String,
                        let body = data["body"] as? String,
                        let postingTimeTimestamp = data["postingTime"] as? Timestamp,
                        let likedBy = data["likedBy"] as? [String],
                        let comments = data["comments"] as? [String],
                        let spoilersAllowed = data["spoilersAllowed"] as? Bool,
                        let announcementTypeString = data["announcementType"] as? String
                    else {
                        print("Error parsing post data")
                        continue
                    }
                    
                    if let type = PostType(rawValue: typeString),
                       let announcementType = AnnouncementType(rawValue: announcementTypeString) {
                        
                        let postInfo = PostInfo(
                            id: UUID(uuidString: id) ?? UUID(),
                            authorID: authorID,
                            type: type,
                            header: header,
                            body: body,
                            postingTime: postingTimeTimestamp.dateValue(),
                            likedBy: likedBy.map { UUID(uuidString: $0) ?? UUID() },
                            comments: comments.map { UUID(uuidString: $0) ?? UUID() },
                            spoilersAllowed: spoilersAllowed,
                            announcementType: announcementType
                        )
                        
                        self.postInfo = postInfo
                    }
                }
            }
        }
    }
}
