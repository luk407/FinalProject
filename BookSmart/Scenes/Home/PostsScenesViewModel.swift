//
//  HomeViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation
import Firebase

protocol PostsScenesViewModelDelegate: AnyObject {
    func reloadTableView()
}

final class PostsScenesViewModel {
    
    // MARK: - Properties
    
    var fetchedPostsInfo: [PostInfo] = []
    var storyPosts: [PostInfo] = []
    var announcementPosts: [PostInfo] = []

    var userInfo: UserInfo

    private let dispatchGroup = DispatchGroup()
    
    weak var delegate: PostsScenesViewModelDelegate?
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo        
    }
    
    // MARK: - Methods
    
    func homeSceneViewWillAppear() {
        //if !viewDidLoad {
            
            dispatchGroup.enter()
            userInfoListener()
            
            dispatchGroup.enter()
            postsInfoListener()
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.delegate?.reloadTableView()
                //self?.viewDidLoad = true
            }
        //}
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
    
    // MARK: - Firebase Methods
    
    private func postsInfoListener() {
        
        let database = Firestore.firestore()
        let reference = database.collection("PostInfo")
        
        reference.addSnapshotListener(includeMetadataChanges: true) { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            guard let self = self, let snapshot = snapshot else {
                print("fdfdf")
                return
            }
            
            self.fetchedPostsInfo.removeAll()
            self.storyPosts.removeAll()
            self.announcementPosts.removeAll()
            
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
                    self.fetchedPostsInfo.append(postInfo)
                    
                    switch type {
                    case .story:
                        self.storyPosts.append(postInfo)
                    case .announcement:
                        self.announcementPosts.append(postInfo)
                    }
                }
            }
            
            self.fetchedPostsInfo.sort(by: { $0.postingTime > $1.postingTime })
            self.storyPosts.sort(by: { $0.postingTime > $1.postingTime })
            self.announcementPosts.sort(by: { $0.postingTime > $1.postingTime })
        }
        dispatchGroup.leave()
    }
    
    private func userInfoListener() {
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo").document(userInfo.id.uuidString)
        
        reference.addSnapshotListener(includeMetadataChanges: true) { [weak self] documentSnapshot, error in
            
            guard let self = self else { return }
            
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
            let booksFinished = parseBooksFinishedArray(booksFinishedArray)
            
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
            self.userInfo = userInfo
        }
        dispatchGroup.leave()
    }

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

