//
//  SignupView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation
import Firebase

final class SignupSceneViewModel {
    
    // MARK: - Properties
    var password: String = ""
    var isSignUpEnabled = false
    var isMinLengthMet = false
    var isCapitalLetterMet = false
    var isNumberMet = false
    var isUniqueCharacterMet = false
    
    // MARK: - Methods
    func register(emailText: String, passwordText: String) {
        if isSignUpEnabled {
            Auth.auth().createUser(withEmail: emailText, password: passwordText) { result, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    func updatePasswordCriteria(password: String) {
        isMinLengthMet = password.count >= 8
        isCapitalLetterMet = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        isNumberMet = password.rangeOfCharacter(from: .decimalDigits) != nil
        isUniqueCharacterMet = password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*")) != nil
        isSignUpEnabled = isMinLengthMet && isCapitalLetterMet && isNumberMet && isUniqueCharacterMet
    }
    
    func passwordTextChange(_ textFieldText: String) {
        password = textFieldText
    }
    
    func addUserData(username: String, email: String, password: String) {
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
}
