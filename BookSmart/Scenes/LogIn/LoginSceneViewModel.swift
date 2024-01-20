//
//  LoginSceneViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation
import Firebase

final class LoginSceneViewModel {
    // MARK: - Properties
    var fetchedUserData: UserInfo?
    
    // MARK: - Init
    init() {
        FirebaseApp.configure()
    }
    
    // MARK: - Methods
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    func navigateToTabBarController(navigationController: UINavigationController) {
        guard let fetchedUserData else { return }
        let tabbarController = TabBarController(userInfo: fetchedUserData)
        navigationController.pushViewController(tabbarController, animated: true)
    }
    
    func signupButtonPressed(navigationController: UINavigationController) {
        let signupScene = SignupSceneView()
        navigationController.pushViewController(signupScene, animated: true)
    }
    
    func fetchUserInfoAndLogin(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo")
        
        reference.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let snapshot = snapshot {
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
                            let badges = data["badges"] as? [BadgeInfo],
                            let posts = data["posts"] as? [String],
                            let comments = data["comments"] as? [String],
                            let likedPosts = data["likedPosts"] as? [String],
                            let connections = data["connections"] as? [String],
                            let booksFinished = data["booksFinished"] as? [BooksData],
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
                            booksFinished: booksFinished,
                            quotesUsed: quotesUsed
                        )
                        
                        self.fetchedUserData = userInfo
                    }
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
