
import Foundation
import Firebase
import FirebaseStorage

final public class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let dispatchGroup = DispatchGroup()
    
    // MARK: - Registration Methods
    
    func registerUser(emailText: String, passwordText: String) {
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { result, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func addUserDataDuringRegistration(username: String, email: String, password: String) {
        let createdUserInfo = UserInfo(
            id: UUID(),
            userName: username,
            email: email,
            password: password,
            displayName: username,
            registrationDate: Date.now,
            bio: "",
            image: "",
            badges: [],
            posts: [],
            comments: [],
            likedPosts: [],
            connections: [],
            booksFinished: [],
            quotesUsed: [])
        
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo").document(createdUserInfo.id.uuidString)
        
        reference.setData([
            "id": createdUserInfo.id.uuidString,
            "username": createdUserInfo.userName,
            "email": createdUserInfo.email,
            "password": createdUserInfo.password,
            "displayName": createdUserInfo.displayName,
            "registrationDate": createdUserInfo.registrationDate,
            "bio": createdUserInfo.bio,
            "image": createdUserInfo.image,
            "badges": createdUserInfo.badges,
            "posts": createdUserInfo.posts,
            "comments": createdUserInfo.comments,
            "likedPosts": createdUserInfo.likedPosts,
            "connections": createdUserInfo.connections,
            "booksFinished": createdUserInfo.booksFinished,
            "quotesUsed": createdUserInfo.quotesUsed
        ]) { error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    // MARK: - Login Methods
    
    func loginToFirebase(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // MARK: - User Methods
    
    func getUserInfoToLogin(with email: String, and password: String, completion: @escaping (UserInfo?) -> Void) {
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo")
        
        reference.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                completion(nil)
                return
            }
            
            let userInfo = self.parseSnapshot(snapshot, email: email, password: password)
            completion(userInfo)
        }
    }
    
    private func parseSnapshot(_ snapshot: QuerySnapshot, email: String, password: String) -> UserInfo? {
        
        for document in snapshot.documents {
            let data = document.data()
            
            guard let emailToCheck = data["email"] as? String,
                  let passwordToCheck = data["password"] as? String,
                  emailToCheck == email,
                  passwordToCheck == password else {
                continue
            }
            
            guard let id = data["id"] as? String,
                  let username = data["username"] as? String,
                  let displayName = data["displayName"] as? String,
                  let registrationDateTimestamp = data["registrationDate"] as? Timestamp,
                  let bio = data["bio"] as? String,
                  let image = data["image"] as? String,
                  let badgesData = data["badges"] as? [[String: String]],
                  let posts = data["posts"] as? [String],
                  let comments = data["comments"] as? [String],
                  let likedPosts = data["likedPosts"] as? [String],
                  let connections = data["connections"] as? [String],
                  let booksFinishedArray = data["booksFinished"] as? [[String: Any]],
                  let quotesUsedData = data["quotesUsed"] as? [[String: String]] else {
                continue
            }
            
            let badges = parseBadgesArray(badgesData)
            let booksFinished = parseBooksFinishedArray(booksFinishedArray)
            let quotesUsed = parseQuotesArray(quotesUsedData)
            
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
            
            return userInfo
        }
        
        return nil
    }
    
    func userInfoListener(userIDString: String, completion: @escaping (UserInfo) -> Void) {
        
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo").document(userIDString)
        
        reference.addSnapshotListener(includeMetadataChanges: true) { documentSnapshot, error in
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
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
                print("Error parsing user dataa")
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
    
    func getUserInfo(userIDString: String, completion: @escaping (UserInfo) -> Void) {

        let database = Firestore.firestore()
        let reference = database.collection("UserInfo").document(userIDString)
        
        reference.getDocument { documentSnapshot, error in
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
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
                print("Error parsing user dataa")
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
    
    func addQuotesToFirebase(userInfoIDString: String, quotes: [Quote]) {
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfoIDString)
        
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
    
    func updateUserPostsAndFinishedBooksOnFirebase(userInfo: UserInfo, postID: UUID, selectedAnnouncementType: AnnouncementType, selectedBook: Book) {
        
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        
        let updatedPosts = FieldValue.arrayUnion([postID.uuidString])
        
        var updatedFinishedBooks = userInfo.booksFinished
        
        if selectedAnnouncementType == .finishedBook {
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
    
    func updateUserPostsOnFirebase(userInfoIDString: String, postID: UUID) {
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfoIDString)
        
        userReference.updateData(["posts": FieldValue.arrayUnion([postID.uuidString])]) { error in
            if let error = error {
                print("Error updating user data on Firebase: \(error.localizedDescription)")
            }
        }
    }

    func getAllUsersInfo(completion: @escaping ([UserInfo]?) -> Void) {
        
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo")
        
        reference.getDocuments { snapshot, error in
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            var fetchedUsers: [UserInfo] = []
            
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
                    let badgesData = data["badges"] as? [[String: String]],
                    let posts = data["posts"] as? [String],
                    let comments = data["comments"] as? [String],
                    let likedPosts = data["likedPosts"] as? [String],
                    let connections = data["connections"] as? [String],
                    let booksFinishedArray = data["booksFinished"] as? [[String: Any]],
                    let quotesUsedData = data["quotesUsed"] as? [[String: String]]
                else {
                    print("Error parsing user dataaaa")
                    continue
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
                
                fetchedUsers.append(userInfo)
            }
            
            completion(fetchedUsers)
        }
    }
    
    func updateUserProfile(userIDString: String, displayName: String, username: String, bio: String, badges: [BadgeInfo]) {
        let database = Firestore.firestore()
        let userDocumentReference = database.collection("UserInfo").document(userIDString)
        
        var updateData: [String: Any] = [:]
        
        updateData["displayName"] = displayName
        updateData["username"] = username
        updateData["bio"] = bio
        updateData["badges"] = convertBadgesToArray(badges: badges)
        
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
    
    // MARK: - Post Author Methods
    
    func getAuthorInfo(with authorID: UserInfo.ID, completion: @escaping (UserInfo?) -> Void) {
        
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo").whereField("id", isEqualTo: authorID.uuidString)
        
        reference.getDocuments { snapshot, error in
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            if let document = snapshot.documents.first {
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
                    let badgesData = data["badges"] as? [[String: String]],
                    let posts = data["posts"] as? [String],
                    let comments = data["comments"] as? [String],
                    let likedPosts = data["likedPosts"] as? [String],
                    let connections = data["connections"] as? [String],
                    let booksFinishedArray = data["booksFinished"] as? [[String: Any]],
                    let quotesUsedData = data["quotesUsed"] as? [[String: String]]
                else {
                    print("Error parsing user dataaaa")
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
    }
    
    // MARK: - Methods for Posts
    
    func postsInfoListenerForProfile(profileOwnerID: UserInfo.ID, completion: @escaping ([PostInfo]) -> Void) {

        let database = Firestore.firestore()
        let reference = database.collection("PostInfo")
        
        reference.addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                return
            }
            
            var posts: [PostInfo] = []
            
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
                    posts.append(postInfo)
                }
            }
            completion(posts.sorted(by: { $0.postingTime > $1.postingTime }))
        }
    }

    func getPostsInfoFromFirebaseForPostsScenes(completion: @escaping ([PostInfo], [PostInfo], [PostInfo], [PostInfo]) -> Void) {
        
        var fetchedPostsInfo: [PostInfo] = []
        var storyPosts: [PostInfo] = []
        var filteredStoryPosts: [PostInfo] = []
        var announcementPosts: [PostInfo] = []
        
        let database = Firestore.firestore()
        let reference = database.collection("PostInfo")
        
        reference.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                return
            }
            
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
                    
                    fetchedPostsInfo.append(postInfo)
                    
                    switch type {
                    case .story:
                        storyPosts.append(postInfo)
                        filteredStoryPosts.append(postInfo)
                    case .announcement:
                        announcementPosts.append(postInfo)
                    }
                }
            }
            
            completion(fetchedPostsInfo, storyPosts, filteredStoryPosts, announcementPosts)
        }
    }
    
    func toggleLikePost(userInfoIDString: String, postInfoIDString: String, completion: @escaping (Bool) -> Void) {
        
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfoIDString)
        let postReference = database.collection("PostInfo").document(postInfoIDString)
        
        userReference.getDocument { userDocument, userError in
            guard let userDocument = userDocument, userDocument.exists else {
                return
            }
            
            let userData = userDocument.data()
            guard let likedPosts = userData?["likedPosts"] as? [String] else {
                return
            }
            
            if likedPosts.contains(postInfoIDString) {
                userReference.updateData([
                    "likedPosts": FieldValue.arrayRemove([postInfoIDString])
                ]) { userUpdateError in
                    if let userUpdateError = userUpdateError {
                        print("Error updating user liked posts: \(userUpdateError.localizedDescription)")
                    } else {
                        postReference.updateData([
                            "likedBy": FieldValue.arrayRemove([userInfoIDString])
                        ]) { postUpdateError in
                            if let postUpdateError = postUpdateError {
                                print("Error updating post likedBy array: \(postUpdateError.localizedDescription)")
                                return
                            } else {
                                completion(false)
                            }
                        }
                    }
                }
            } else {
                userReference.updateData([
                    "likedPosts": FieldValue.arrayUnion([postInfoIDString])
                ]) { userUpdateError in
                    if let userUpdateError = userUpdateError {
                        print("Error updating user liked posts: \(userUpdateError.localizedDescription)")
                    } else {
                        postReference.updateData([
                            "likedBy": FieldValue.arrayUnion([userInfoIDString])
                        ]) { postUpdateError in
                            if let postUpdateError = postUpdateError {
                                print("Error updating post likedBy array: \(postUpdateError.localizedDescription)")
                                return
                            } else {
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addPostToFirebase(post: PostInfo) {
        
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
    
    func deletePost(_ post: PostInfo) {
        
        let postRef = Firestore.firestore().collection("PostInfo").document(post.id.uuidString)
        
        postRef.delete { error in
            if let error = error {
                print("Error deleting post: \(error.localizedDescription)")
            } else {
                print("Post deleted successfully")
                self.removePostFromUserProfile(post)
            }
        }
    }
    
    private func removePostFromUserProfile(_ post: PostInfo) {
        
        let userPostsRef = Firestore.firestore().collection("UserInfo").document(post.authorID.uuidString)
        
        userPostsRef.updateData([
            "posts": FieldValue.arrayRemove([post.id.uuidString])
        ]) { error in
            if let error = error {
                print("Error removing post from author's posts: \(error.localizedDescription)")
            } else {
                print("Post removed from author's posts successfully")
            }
        }
    }

    // MARK: - Methods for Images
    
    func uploadImage(selectedImage: UIImage, userIDString: String) {
        
        let storageReference = Storage.storage().reference()
        
        let imageData = selectedImage.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "profileImages/\(userIDString).jpg"
        
        let fileReference = storageReference.child(path)
        
        fileReference.putData(imageData!, metadata: nil) { [self] metadata, error in
            
            if error == nil && metadata != nil {
                changeImagePathOfOwner(userIDString: userIDString, path: path)
                CacheManager.instance.update(image: selectedImage , name: userIDString)
            }
        }
    }
    
    private func changeImagePathOfOwner(userIDString: String, path: String) {
        
        let database = Firestore.firestore()
        let userDocumentReference = database.collection("UserInfo").document(userIDString)
        
        userDocumentReference.updateData(["image": path]) { error in
            if let error = error {
                print("Error updating image path: \(error.localizedDescription)")
            } else {
                print("Image path updated successfully.")
            }
        }
    }
    
    func retrieveImage(_ ownerIDString: String, completion: @escaping (UIImage) -> Void) {
        
        if let cachedImage = CacheManager.instance.get(name: ownerIDString) {
            completion(cachedImage)
        } else {
            let database = Firestore.firestore()
            database.collection("UserInfo").document(ownerIDString).getDocument { document, error in
                if error == nil && document != nil {
                    let imagePath = document?.data()?["image"] as? String
                    self.fetchImage(imagePath ?? "") { image in
                        completion(image)
                    }
                }
            }
        }
    }
    
    private func fetchImage(_ imagePath: String, completion: @escaping (UIImage) -> Void) {
        
        let storageReference = Storage.storage().reference()
        let fileReference = storageReference.child(imagePath)
        
        fileReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let data = data, error == nil, let fetchedImage = UIImage(data: data) {
                print("Image fetched successfully.")
                DispatchQueue.main.async {
                    CacheManager.instance.add(image: fetchedImage, name: imagePath)
                    completion(fetchedImage)
                }
            } else {
                print("Error fetching image:", error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    // MARK: - Methods for Comments
    
    func commentInfoListenerForPostDetails(commentsIDs: [CommentInfo.ID], completion: @escaping ([CommentInfo]) -> Void) {

        guard !commentsIDs.isEmpty else { return }
        
        let database = Firestore.firestore()
        let commentCollection = database.collection("CommentInfo")
        
        commentCollection
            .whereField("id", in: commentsIDs.map { $0.uuidString })
            .addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
                
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
                completion(fetchedComments.sorted(by: { $0.commentTime > $1.commentTime }))
            }
    }
    
    func addCommentToFirebase(userInfoID: UserInfo.ID, postInfoIDString: String, commentText: String, completion: @escaping (CommentInfo.ID) -> Void) {
        
        let database = Firestore.firestore()
        let postReference = database.collection("PostInfo").document(postInfoIDString)
        
        let newComment = CommentInfo(
            id: UUID(),
            authorID: userInfoID,
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
            
            self?.updateUserDataWithNewCommentID(userInfoIDString: userInfoID.uuidString, commentID: newComment.id)
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
        
        completion(newComment.id)
    }
    
    func deleteComment(_ comment: CommentInfo, for post: PostInfo) {
        
        let commentRef = Firestore.firestore().collection("CommentInfo").document(comment.id.uuidString)
        
        commentRef.delete { error in
            if let error = error {
                print("Error deleting comment: \(error.localizedDescription)")
            } else {
                print("Comment deleted successfully")
                
                self.removeCommentFromUserProfile(comment)
                self.removeCommentFromParentPost(comment, for: post)
            }
        }
    }
    
    private func removeCommentFromUserProfile(_ comment: CommentInfo) {
        
        let userCommentsRef = Firestore.firestore().collection("UserInfo").document(comment.authorID.uuidString)
        
        userCommentsRef.updateData([
            "comments": FieldValue.arrayRemove([comment.id.uuidString])
        ]) { error in
            if let error = error {
                print("Error removing comment from author's comments: \(error.localizedDescription)")
            } else {
                print("Comment removed from author's comments successfully")
            }
        }
    }

    private func removeCommentFromParentPost(_ comment: CommentInfo, for post: PostInfo) {
        
        let postRef = Firestore.firestore().collection("PostInfo").document(post.id.uuidString)
        
        postRef.updateData([
            "comments": FieldValue.arrayRemove([comment.id.uuidString])
        ]) { error in
            if let error = error {
                print("Error removing comment from parent post: \(error.localizedDescription)")
            } else {
                print("Comment removed from parent post successfully")
            }
        }
    }

    
    private func updateUserDataWithNewCommentID(userInfoIDString: String, commentID: UUID) {
        
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfoIDString)
        
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
    
    func commentInfoListenerForProfile(profileOwnerIDString: String, completion: @escaping ([CommentInfo]) -> Void) {
        
        _ = Firestore.firestore()
            .collection("CommentInfo")
            .whereField("authorID", isEqualTo: profileOwnerIDString)
            .addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
                
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
                completion(fetchedComments.sorted(by: { $0.commentTime > $1.commentTime }))
            }
    }

    // MARK: - Methods for Connections
    
    func connectionsInfoListener(profileOwnerIdString: String, completion: @escaping ([UserInfo]) -> Void) {

        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(profileOwnerIdString)
        
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
            dispatchGroup.enter()
            for connectionIDString in connectionsData {
                
                self.userInfoListener(userIDString: connectionIDString) { userInfo in
                    fetchedConnections.append(userInfo)
                    
                }
                
            }
            dispatchGroup.leave()
            
            dispatchGroup.notify(queue: .main) {
                completion(fetchedConnections)
            }
            
        }
    }
    
    func addConnection(userIDString: String, profileOwnerIDString: String) {
        
        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(userIDString)
        
        userDocumentReference.updateData(["connections": FieldValue.arrayUnion([profileOwnerIDString])]) { [weak self] error in
            if let error = error {
                print("Error adding connection: \(error.localizedDescription)")
            } else {
                print("Connection added successfully.")
                self?.updateProfileOwnerConnectionAddition(userIDString: userIDString, profileOwnerIDString: profileOwnerIDString)
            }
        }
    }
    
    private func updateProfileOwnerConnectionAddition(userIDString: String, profileOwnerIDString: String) {
        
        let profileOwnerDocumentReference = Firestore.firestore().collection("UserInfo").document(profileOwnerIDString)
        
        profileOwnerDocumentReference.updateData(["connections": FieldValue.arrayUnion([userIDString])]) { error in
            if let error = error {
                print("Error updating profile owner's connections: \(error.localizedDescription)")
            } else {
                print("Profile owner's connections updated successfully.")
            }
        }
    }

    func removeConnection(userIDString: String, profileOwnerIDString: String) {
        
        let userDocumentReference = Firestore.firestore().collection("UserInfo").document(userIDString)
        
        userDocumentReference.updateData(["connections": FieldValue.arrayRemove([profileOwnerIDString])]) { [weak self] error in
            if let error = error {
                print("Error removing connection: \(error.localizedDescription)")
            } else {
                print("Connection removed successfully.")
                self?.updateProfileOwnerConnectionRemoval(userIDString: userIDString, profileOwnerIDString: profileOwnerIDString)
            }
        }
    }

    private func updateProfileOwnerConnectionRemoval(userIDString: String, profileOwnerIDString: String) {
        
        let profileOwnerDocumentReference = Firestore.firestore().collection("UserInfo").document(profileOwnerIDString)
        
        profileOwnerDocumentReference.updateData(["connections": FieldValue.arrayRemove([userIDString])]) { error in
            if let error = error {
                print("Error updating profile owner's connections: \(error.localizedDescription)")
            } else {
                print("Profile owner's connections updated successfully.")
            }
        }
    }
}
