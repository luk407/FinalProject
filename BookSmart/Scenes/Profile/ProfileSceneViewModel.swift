//
//  ProfileSceneViewMode.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

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
    @Published var fetchedOwnerImage = UIImage()
    
    var ownerBadges: [BadgeInfo] {
        var badges: [BadgeInfo] = []

        if let fetchedOwnerInfo = fetchedOwnerInfo {
            badges = BadgeManager.calculateBadges(for: fetchedOwnerInfo)
        }
        
        return badges
    }
    
    // MARK: - Init
    
    init(profileOwnerInfoID: UserInfo.ID, userInfo: UserInfo) {
        self.profileOwnerInfoID = profileOwnerInfoID
        self.userInfo = userInfo
    }
    
    // MARK: - Methods
    
    func viewOnAppear() {
        fetchOwnerInfo()
        postsInfoListener()
        commentInfoListener()
        connectionsInfoListener()
        checkProfileOwner()
        checkIfInConnections()
    }
    
    private func checkProfileOwner() {
        if profileOwnerInfoID == userInfo.id {
            isOwnProfile = true
        } else {
            isOwnProfile = false
        }
    }
    
    private func checkIfInConnections() {
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
            if selectedImage != nil {
                uploadImage()
            }
            updateUserProfile()
        } else {
            isEditable = true
        }
    }

    // MARK: - Firebase Methods
    
    // MARK: - Posts
    private func fetchOwnerInfo() {
        fetchOwnerInfo(with: profileOwnerInfoID) { userInfo, error in
            if let userInfo = userInfo {
                self.fetchedOwnerInfo = userInfo
                self.fetchedOwnerDisplayName = userInfo.displayName
                self.fetchedOwnerUsername = "@\(userInfo.userName)"
                self.fetchedOwnerBio = userInfo.bio
                self.fetchOwnerImage()
            } else if let error = error {
                print("Error fetching connection info: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchOwnerImage() {
        guard let fetchedOwnerInfo = fetchedOwnerInfo else { return }
        
        retrieveImage(for: fetchedOwnerInfo) { image in
            DispatchQueue.main.async {
                self.fetchedOwnerImage = image ?? UIImage(systemName: "person.fill")!
            }
        }
    }
    
    private func postsInfoListener() {
        
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
            
            var posts: [PostInfo] = []
            
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
                    posts.append(postInfo)
                }
            }
            self.postsInfo = posts.sorted(by: { $0.postingTime > $1.postingTime })
        }
    }
    
    // MARK: - Comment
    
    private func commentInfoListener() {
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
                self.commentsInfo = fetchedComments.sorted(by: { $0.commentTime > $1.commentTime })
            }
    }
    
    // MARK: - Connections
    
    private func connectionsInfoListener() {

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
                    
                    if let userInfo = userInfo {
                        fetchedConnections.append(userInfo)
                    } else if let error = error {
                        print("Error fetching connection info: \(error.localizedDescription)")
                    }
                }
                connectionGroup.leave()
            }
     
            connectionGroup.notify(queue: .main) {
                DispatchQueue.main.async {
                    self.connectionsInfo = fetchedConnections
                }
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
            let badgesData = data?["badges"] as? [[String: String]],
            let postsData = data?["posts"] as? [String],
            let commentsData = data?["comments"] as? [String],
            let likedPostsData = data?["likedPosts"] as? [String],
            let connectionsData = data?["connections"] as? [String],
            let booksFinishedArray = data?["booksFinished"] as? [[String: Any]],
            let quotesUsedData = data?["quotesUsed"] as? [[String: String]]
        else {
            print("Error parsing UserInfo data")
            return nil
        }

        let posts = postsData.compactMap { UUID(uuidString: $0) }
        let comments = commentsData.compactMap { UUID(uuidString: $0) }
        let likedPosts = likedPostsData.compactMap { UUID(uuidString: $0) }
        let connections = connectionsData.compactMap { UUID(uuidString: $0) }

        let badges = self.parseBadgesArray(badgesData)
        let quotesUsed = parseQuotesArray(quotesUsedData)
        let booksFinished = parseBooksFinishedArray(booksFinishedArray)

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
    
    private func fetchOwnerInfo(with userID: UUID, completion: @escaping (UserInfo?, Error?) -> Void) {
        
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
        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(userInfo.id.uuidString)
        
        userDocumentReference.updateData(["connections": FieldValue.arrayUnion([profileOwnerInfoID.uuidString])]) { [weak self] error in
            if let error = error {
                print("Error adding connection: \(error.localizedDescription)")
            } else {
                print("Connection added successfully.")
                self?.updateProfileOwnerConnectionAddition()
            }
        }
    }
    
    private func updateProfileOwnerConnectionAddition() {
        let profileOwnerDocumentReference = Firestore.firestore().collection("UserInfo").document(profileOwnerInfoID.uuidString)
        
        profileOwnerDocumentReference.updateData(["connections": FieldValue.arrayUnion([userInfo.id.uuidString])]) { error in
            if let error = error {
                print("Error updating profile owner's connections: \(error.localizedDescription)")
            } else {
                print("Profile owner's connections updated successfully.")
            }
        }
    }

    private func removeConnection() {
        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(userInfo.id.uuidString)
        
        userDocumentReference.updateData(["connections": FieldValue.arrayRemove([profileOwnerInfoID.uuidString])]) { [weak self] error in
            if let error = error {
                print("Error removing connection: \(error.localizedDescription)")
            } else {
                print("Connection removed successfully.")
                self?.updateProfileOwnerConnectionRemoval()
            }
        }
    }

    private func updateProfileOwnerConnectionRemoval() {
        let profileOwnerDocumentReference = Firestore.firestore().collection("UserInfo").document(profileOwnerInfoID.uuidString)
        
        profileOwnerDocumentReference.updateData(["connections": FieldValue.arrayRemove([userInfo.id.uuidString])]) { error in
            if let error = error {
                print("Error updating profile owner's connections: \(error.localizedDescription)")
            } else {
                print("Profile owner's connections updated successfully.")
            }
        }
    }

    private func uploadImage() {
        
        let storageReference = Storage.storage().reference()
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "profileImages/\(profileOwnerInfoID.uuidString).jpg"
        
        let fileReference = storageReference.child(path)
        
        fileReference.putData(imageData!, metadata: nil) { [self] metadata, error in
            
            if error == nil && metadata != nil {
                changeImagePathOfOwner(path)
                CacheManager.instance.update(image: selectedImage ?? UIImage(systemName: "person.fill")!, name: profileOwnerInfoID.uuidString)
            }
        }
    }
    
    private func changeImagePathOfOwner(_ path: String) {
        let database = Firestore.firestore()
        let userDocumentReference = database.collection("UserInfo").document(profileOwnerInfoID.uuidString)
        
        userDocumentReference.updateData(["image": path]) { error in
            if let error = error {
                print("Error updating image path: \(error.localizedDescription)")
            } else {
                print("Image path updated successfully.")
            }
        }
    }
    
    func retrieveImage(for user: UserInfo, completion: @escaping (UIImage?) -> Void) {
        var fetchedImage = UIImage(systemName: "person.fill")!
        
        if let cachedImage = CacheManager.instance.get(name: user.id.uuidString) {
            fetchedImage = cachedImage
            if user.id == self.profileOwnerInfoID {
                completion(fetchedImage)
            } else {
                completion(nil)
            }
        } else {
            let storageReference = Storage.storage().reference()
            let imagePath = "profileImages/\(user.id.uuidString).jpg"
            let fileReference = storageReference.child(imagePath)
            
            fileReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let data = data, error == nil, let newImage = UIImage(data: data) {
                    print("Image fetched successfully.")
                    fetchedImage = newImage
                    
                    CacheManager.instance.add(image: fetchedImage, name: user.id.uuidString)
                    
                    if user.id == self.profileOwnerInfoID {
                        completion(fetchedImage)
                    } else {
                        completion(nil)
                    }
                } else {
                    print("Error fetching image:", error?.localizedDescription ?? "Unknown error")
                    completion(nil)
                }
            }
        }
    }
    
    func getImageFromCache(userIDString: String) -> UIImage {
        return CacheManager.instance.get(name: userIDString) ?? UIImage(systemName: "person.fill")!
    }
    
    private func fetchImage(_ imagePath: String) {
        let storageReference = Storage.storage().reference()
        let fileReference = storageReference.child(imagePath)
        
        fileReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let data = data, error == nil, let fetchedImage = UIImage(data: data) {
                print("Image fetched successfully.")
                DispatchQueue.main.async {
                    self.fetchedOwnerImage = fetchedImage
                    CacheManager.instance.add(image: fetchedImage, name: self.profileOwnerInfoID.uuidString)
                }
            } else {
                print("Error fetching image:", error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    func updateUserProfile() {
        let database = Firestore.firestore()
        let userDocumentReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        
        var updateData: [String: Any] = [:]
        
        updateData["displayName"] = fetchedOwnerDisplayName
        updateData["username"] = fetchedOwnerUsername.dropFirst()
        updateData["bio"] = fetchedOwnerBio
        updateData["badges"] = convertBadgesToArray(badges: ownerBadges)
        
        userDocumentReference.updateData(updateData) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
            } else {
                print("User profile updated successfully.")
            }
        }
    }
    
    private func convertBadgesToArray(badges: [BadgeInfo]) -> [[String: Any]] {
        var badgesArray: [[String: Any]] = []
        
        for badge in badges {
            let badgeData: [String: Any] = [
                "category": badge.category.rawValue,
                "type": badge.type.rawValue
            ]
            badgesArray.append(badgeData)
        }
        
        return badgesArray
    }
}
