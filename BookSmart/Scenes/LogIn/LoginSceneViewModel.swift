//
//  LoginSceneViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation
import Firebase

protocol LoginSceneViewDelegate: AnyObject {
    func navigateToTabBarController()
}

final class LoginSceneViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var fetchedUserData: UserInfo?
    private var dispatchGroup = DispatchGroup()
    private var userDispatchGroup = DispatchGroup()

    weak var delegate: LoginSceneViewDelegate?
    
    // MARK: - Init
    
    init() {
        FirebaseApp.configure()
    }
    
    // MARK: - Methods
    
    func loginAndNavigate(email: String, password: String) {
        
        dispatchGroup.enter()
        loginToFirebase(email: email, password: password)
        
        dispatchGroup.enter()
        userInfoListener(email: email, password: password)
        
        dispatchGroup.notify(queue: .main) { [ weak self ] in
            self?.delegate?.navigateToTabBarController()
        }
    }
    
    private func loginToFirebase(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
        dispatchGroup.leave()
    }

    // MARK: - Firebase Methods
    
    func userInfoListener(email: String, password: String) {
        
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo")
        
        reference.addSnapshotListener(includeMetadataChanges: true) { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot else { return }
            
            for document in snapshot.documents {
                let data = document.data()
                
                let passwordToCheck = data["password"] as? String ?? ""
                let emailToCheck = data["email"] as? String ?? ""
                
                if emailToCheck == email && passwordToCheck == password {
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
                        let quotesUsed = data["quotesUsed"] as? [Quote]
                    else {
                        print("Error parsing user data")
                        continue
                    }
                    
                    let badges = self.parseBadgesArray(badgesData)
                    
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
                    
                    // only works second time. needs fix.
                    self.fetchedUserData = userInfo
                }
            }
        }
        dispatchGroup.leave()
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
}
