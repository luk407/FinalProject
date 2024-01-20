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
                        let achievementTypeString = data["achievementType"] as? String
                    else {
                        print("Error parsing post data")
                        continue
                    }

                    if let type = PostType(rawValue: typeString),
                       let achievementType = AchievementType(rawValue: achievementTypeString),
                       authorID != self.userInfo?.id {
                        
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
                            achievementType: achievementType
                        )

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
