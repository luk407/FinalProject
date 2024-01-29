//
//  LeaderboardSceneViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation
import Firebase
import FirebaseStorage

protocol LeaderboardSceneViewModelDelegate: AnyObject {
    func updateUserImage(userIndex: Int, userImage: UIImage)
}

final class LeaderboardSceneViewModel {
    
    // MARK: - Properties
    
    var userInfo: UserInfo
    var fetchedUsersInfo: [UserInfo] = []
    private var fetchedUserImages: [UUID: UIImage] = [:]
    weak var delegate: LeaderboardSceneViewModelDelegate?
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        
        getAllUsersInfo { usersInfo in
            if let usersInfo {
                self.fetchedUsersInfo = usersInfo.sorted { $0.booksFinished.count > $1.booksFinished.count }
                self.retrieveAllImages()
            }
        }
        
    }
    
    // MARK: - Methods
    
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
    
    func getImage(index: Int) -> UIImage? {
        let userID = fetchedUsersInfo[index].id
        return fetchedUserImages[userID]
    }
    
    func retrieveAllImages() {
        for (index, user) in fetchedUsersInfo.enumerated() {
            let imageName = user.id.uuidString
            
            if let cachedImage = CacheManager.instance.get(name: imageName) {
                delegate?.updateUserImage(userIndex: index, userImage: cachedImage)
            } else {
                fetchImage(imageName, userIndex: index)
            }
        }
    }
    
    private func fetchImage(_ imagePath: String, userIndex: Int) {
        
        let storageReference = Storage.storage().reference()
        let fileReference = storageReference.child(imagePath)
        
        fileReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let data = data, error == nil, let fetchedImage = UIImage(data: data) {
                print("Image fetched successfully.")
                
                let userID = self.fetchedUsersInfo[userIndex].id
                self.fetchedUserImages[userID] = fetchedImage
                
                self.delegate?.updateUserImage(userIndex: userIndex, userImage: fetchedImage)
            } else {
                print("Error fetching image:", error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}
