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
    var nickname: String = ""
    var email: String = ""
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
                    print(error?.localizedDescription)
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
}
