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
        
        reference.getDocuments() { [weak self] snapshot, error in
            
            guard let self = self else { return }
            
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let passwordToCheck = data["password"] as? String ?? ""
                    let emailToCheck = data["email"] as? String ?? ""
                    
                    if emailToCheck == email && passwordToCheck == password {
                        let id = data["id"] as? String ?? ""
                        let username = data["username"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let password = data["password"] as? String ?? ""
                        let displayName = data["displayName"] as? String ?? ""
                        let registrationDate = data["registrationDate"] as? Date ?? Date.now
                        let bio = data["bio"] as? String ?? ""
                        let image = data["image"] as? String ?? ""
                        let badges = data["badge"] as? [BadgeInfo] ?? []
                        let posts = data["posts"] as? [PostInfo] ?? []
                        let comments = data["comments"] as? [CommentInfo] ?? []
                        let likedPosts = data["likedPosts"] as? [PostInfo] ?? []
                        let connections = data["connections"] as? [UserInfo] ?? []
                        let booksFinished = data["booksFinished"] as? [Book] ?? []
                        let quotesUsed = data["quotesUsed"] as? [Quote] ?? []
                        
                        let userInfo = UserInfo(
                            id: UUID(uuidString: id) ?? UUID(),
                            userName: username,
                            email: email,
                            password: password,
                            displayName: displayName,
                            registrationDate: registrationDate,
                            bio: bio,
                            image: image,
                            badges: badges,
                            posts: posts,
                            comments: comments,
                            likedPosts: likedPosts,
                            connections: connections,
                            booksFinished: booksFinished,
                            quotesUsed: quotesUsed)
                        
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
