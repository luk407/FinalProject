//
//  ProfileSceneViewMode.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation
import SwiftUI
import Firebase

enum DisplayInfoType {
    case posts, comments, connections
}

class ProfileSceneViewModel: ObservableObject {
    
    // MARK: - Properties
    
    var profileOwnerInfoID: UserInfo.ID
    var userInfo: UserInfo
    var fetchedOwnerInfo: UserInfo?
    let connectionGroup = DispatchGroup()
    let fetchGroup = DispatchGroup()
    
    @Published var displayInfoType: DisplayInfoType = .posts
    @Published var postsInfo: [PostInfo] = []
    @Published var commentsInfo: [CommentInfo] = []
    @Published var connectionsInfo: [UserInfo] = []
    @Published var selectedImage: UIImage?
    @Published var isOwnProfile = false
    @Published var isEditable = false
    @Published var isInConnections = false
    @Published var isImagePickerShowing = false
    @Published var fetchedOwnerDisplayName: String = ""
    @Published var fetchedOwnerUsername: String = ""
    @Published var fetchedOwnerBio: String = ""
    
    // MARK: - Init
    
    init(profileOwnerInfoID: UserInfo.ID, userInfo: UserInfo) {
        self.profileOwnerInfoID = profileOwnerInfoID
        self.userInfo = userInfo
    }
    
    // MARK: - Methods
    
    func checkProfileOwner() {
        if profileOwnerInfoID == userInfo.id {
            isOwnProfile = true
        } else {
            isOwnProfile = false
        }
    }
    
    func checkIfInConnections() {
        if userInfo.connections.contains(where: { $0.uuidString == profileOwnerInfoID.uuidString }) {
            isInConnections = true
        } else {
            isInConnections = false
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
    
    func addRemoveConnections() {
        if isInConnections {
            removeConnection()
            isInConnections = false
        } else {
            addConnection()
            isInConnections = true
        }
    }
    
    func editProfile() {
        if isEditable {
            isEditable = false
        } else {
            isEditable = true
        }
    }

    // MARK: - Firebase Methods
    
    // MARK: - Posts
    func fetchOwnerInfo() {
        fetchOwnerInfoOnce(with: profileOwnerInfoID) { userInfo, error in
            if let userInfo = userInfo {
                self.fetchedOwnerInfo = userInfo
                self.fetchedOwnerDisplayName = userInfo.displayName
                self.fetchedOwnerUsername = userInfo.userName
                self.fetchedOwnerBio = userInfo.bio
            } else if let error = error {
                print("Error fetching connection info: \(error.localizedDescription)")
            }
        }
    }
    
    func postsInfoListener() {
        
        postsInfo = []
        
        let database = Firestore.firestore()
        let reference = database.collection("PostInfo")
        
        reference.addSnapshotListener(includeMetadataChanges: true) { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            guard let self = self, let snapshot = snapshot else {
                return
            }
            
            for document in snapshot.documents {
                let data = document.data()
                
                guard
                    let id = data["id"] as? String,
                    let authorIDString = data["authorID"] as? String,
                    let authorID = UUID(uuidString: authorIDString),
                    authorID == self.profileOwnerInfoID,
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
                    self.postsInfo.append(postInfo)
                }
            }
        }
    }
    
    // MARK: - Comment
    
    func commentInfoListener() {
        _ = Firestore.firestore()
            .collection("CommentInfo")
            .whereField("authorID", isEqualTo: profileOwnerInfoID.uuidString)
            .addSnapshotListener(includeMetadataChanges: true) { [weak self] (querySnapshot, error) in
                
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching user comments info: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No comments found for the user.")
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
    
    // MARK: - Connections
    
    func connectionsInfoListener() {

        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(profileOwnerInfoID.uuidString)
        
        userDocumentReference.addSnapshotListener(includeMetadataChanges: true) { [weak self] (documentSnapshot, error) in
            
            guard let self = self, let document = documentSnapshot else { return }
            
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            guard let connectionsData = document.data()?["connections"] as? [String] else {
                print("No connections found for the user.")
                return
            }
            
            var fetchedConnections: [UserInfo] = []
            
            for connectionIDString in connectionsData {
                
                let connectionID = UUID(uuidString: connectionIDString) ?? UUID()
                
                connectionGroup.enter()
                self.fetchUserInfo(with: connectionID) { (userInfo, error) in
                    
//                    self.fetchGroup.enter()
                    if let userInfo = userInfo {
                        fetchedConnections.append(userInfo)
                    } else if let error = error {
                        print("Error fetching connection info: \(error.localizedDescription)")
                    }
                    
//                    self.fetchGroup.notify(queue: .main) {
//                        self.connectionGroup.leave()
//                    }
                }
                connectionGroup.leave()
            }
     
            connectionGroup.notify(queue: .main) {
                self.connectionsInfo = fetchedConnections
            }
        }
    }
    
    private func fetchUserInfo(with userID: UUID, completion: @escaping (UserInfo?, Error?) -> Void) {
        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(userID.uuidString)

        userDocumentReference.addSnapshotListener(includeMetadataChanges: true) { (documentSnapshot, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }

            if let document = documentSnapshot, document.exists {
                
                if let userInfo = self.parseUserInfo(from: document.data()) {
                    completion(userInfo, nil)
                } else {
                    completion(nil, NSError(domain: "UserInfo Parsing Error", code: 0, userInfo: nil))
                }
            } else {
                completion(nil, NSError(domain: "User Document Not Found", code: 0, userInfo: nil))
            }
            
            //self.fetchGroup.leave()
        }
    }

    private func parseUserInfo(from data: [String: Any]?) -> UserInfo? {
        
        guard
            let idString = data?["id"] as? String,
            let id = UUID(uuidString: idString),
            let userName = data?["username"] as? String,
            let email = data?["email"] as? String,
            let password = data?["password"] as? String,
            let displayName = data?["displayName"] as? String,
            let registrationTimestamp = data?["registrationDate"] as? Timestamp,
            let bio = data?["bio"] as? String,
            let image = data?["image"] as? String,
            let badgesData = data?["badges"] as? [[String: Any]],
            let postsData = data?["posts"] as? [String],
            let commentsData = data?["comments"] as? [String],
            let likedPostsData = data?["likedPosts"] as? [String],
            let connectionsData = data?["connections"] as? [String],
            let booksFinishedData = data?["booksFinished"] as? [[String: Any]],
            let quotesUsedData = data?["quotesUsed"] as? [[String: Any]]
        else {
            print("Error parsing UserInfo data")
            return nil
        }

        // Parse badges
        var badges: [BadgeInfo] = []
        for badgeData in badgesData {
            if
                let categoryString = badgeData["category"] as? String,
                let category = BadgeCategory(rawValue: categoryString),
                let typeString = badgeData["type"] as? String,
                let type = BadgeType(rawValue: typeString)
            {
                let badge = BadgeInfo(category: category, type: type)
                badges.append(badge)
            }
        }

        let posts = postsData.compactMap { UUID(uuidString: $0) }
        let comments = commentsData.compactMap { UUID(uuidString: $0) }
        let likedPosts = likedPostsData.compactMap { UUID(uuidString: $0) }
        let connections = connectionsData.compactMap { UUID(uuidString: $0) }

        // Parse booksFinished and quotesUsed later
        var booksFinished: [Book] = []
        for bookData in booksFinishedData {

        }

        var quotesUsed: [Quote] = []
        for quoteData in quotesUsedData {

        }

        let userInfo = UserInfo(
            id: id,
            userName: userName,
            email: email,
            password: password,
            displayName: displayName,
            registrationDate: registrationTimestamp.dateValue(),
            bio: bio,
            image: image,
            badges: badges,
            posts: posts,
            comments: comments,
            likedPosts: likedPosts,
            connections: connections,
            booksFinished: booksFinished,
            quotesUsed: quotesUsed
        )
        
        return userInfo
    }
    
    func fetchOwnerInfoOnce(with userID: UUID, completion: @escaping (UserInfo?, Error?) -> Void) {
        
        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(userID.uuidString)
        
        userDocumentReference.addSnapshotListener(includeMetadataChanges: true) { (documentSnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            if let document = documentSnapshot, document.exists {
                if let userInfo = self.parseUserInfo(from: document.data()) {
                    completion(userInfo, nil)
                } else {
                    completion(nil, NSError(domain: "UserInfo Parsing Error", code: 0, userInfo: nil))
                }
            } else {
                completion(nil, NSError(domain: "User Document Not Found", code: 0, userInfo: nil))
            }
        }
    }

    
    private func addConnection() {
        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(profileOwnerInfoID.uuidString)
        
        userDocumentReference.updateData(["connections": FieldValue.arrayUnion([userInfo.id.uuidString])]) { error in
            if let error = error {
                print("Error adding connection: \(error.localizedDescription)")
            } else {
                print("Connection added successfully.")
            }
        }
    }
    
    private func removeConnection() {
        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(profileOwnerInfoID.uuidString)
        
        userDocumentReference.updateData(["connections": FieldValue.arrayRemove([userInfo.id.uuidString])]) { error in
            if let error = error {
                print("Error removing connection: \(error.localizedDescription)")
            } else {
                print("Connection removed successfully.")
            }
        }
    }
}
