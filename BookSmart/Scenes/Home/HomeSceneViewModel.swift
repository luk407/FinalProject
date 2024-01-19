//
//  HomeViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation
import Firebase

class HomeSceneViewModel {
    
    // MARK: - Properties
    var fetchedPostsInfo: [PostInfo] = []
    var userInfo: UserInfo?
    
    // MARK: - Methods
    func fetchPostsInfo(completion: @escaping (Bool) -> Void) {
        let database = Firestore.firestore()
        let reference = database.collection("PostInfo")
        
        reference.getDocuments() { [weak self] snapshot, error in
            
            if error != nil {
                print(error?.localizedDescription)
            }
            
            guard let self = self else { return }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let authorID = data["authorID"] as? String ?? ""
                    let typeString = data["type"] as? String ?? ""
                    let header = data["header"] as? String ?? ""
                    let body = data["body"] as? String ?? ""
                    let postingTimeTimestamp = data["postingTime"] as? Timestamp ?? Timestamp(date: Date())
                    let postingTime = postingTimeTimestamp.dateValue()
                    let likedBy = data["likedBy"] as? [UserInfo.ID] ?? []
                    let comments = data["comments"] as? [CommentInfo.ID] ?? []
                    let spoilersAllowed = data["spoilersAllowed"] as? Bool ?? false
                    let achievementTypeString = data["achievementType"] as? AchievementType ?? .none
                    
                    if let type = PostType(rawValue: typeString),
                       let achievementType = AchievementType(rawValue: achievementTypeString.rawValue),
                       UUID(uuidString: authorID) != self.userInfo?.id {
                        
                        let postInfo = PostInfo(
                            id: UUID(uuidString: id) ?? UUID(),
                            authorID: UUID(uuidString: authorID) ?? UUID(),
                            type: type,
                            header: header,
                            body: body,
                            postingTime: postingTime,
                            likedBy: likedBy,
                            comments: comments,
                            spoilersAllowed: spoilersAllowed,
                            achievementType: achievementType)

                        self.fetchedPostsInfo.append(postInfo)
                    }
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
