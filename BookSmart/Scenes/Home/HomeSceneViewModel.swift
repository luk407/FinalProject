//
//  HomeViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation
import Firebase

protocol HomeSceneViewDelegate: AnyObject {
    func reloadTableView()
}

class HomeSceneViewModel {
    
    // MARK: - Properties
    
    var fetchedPostsInfo: [PostInfo] = []
    var userInfo: UserInfo
    private var viewDidLoad = false
    
    weak var delegate: HomeSceneViewDelegate?
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    // MARK: - Methods
    
    func homeSceneViewDidLoad() {
        if !viewDidLoad {
            
            //userInfoListener() { [ weak self ] _ in
                
                postsInfoListener() { [ weak self ]_ in
                    
                    self?.delegate?.reloadTableView()
                }
           // }
            viewDidLoad = true
        }
    }
    
    // MARK: - Firebase Methods
    
    private func postsInfoListener(completion: @escaping (Bool) -> Void) {
        
        fetchedPostsInfo = []
        
        let database = Firestore.firestore()
        let reference = database.collection("PostInfo")
        
        reference.addSnapshotListener(includeMetadataChanges: true) { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let self = self, let snapshot = snapshot else {
                print("fdfdf")
                completion(false)
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
                    self.fetchedPostsInfo.append(postInfo)
                }
            }
            completion(true)
        }
    }
    
    private func userInfoListener(completion: @escaping (Bool) -> Void) {
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo")
        database.clearPersistence()

        reference.addSnapshotListener(includeMetadataChanges: true) { [weak self] snapshot, error in
            
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
                self.userInfo = userInfo
            }
        }
        completion(true)
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

