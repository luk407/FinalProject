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
    var email: String
    var password: String
    
    // MARK: - Init
    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
        
        FirebaseApp.configure()
    }
    
    // MARK: - Methods
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            #warning("handle errors")
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    func signupButtonPressed(navigationController: UINavigationController) {
        let signupScene = SignupSceneView()
        navigationController.pushViewController(signupScene, animated: true)
    }
}
