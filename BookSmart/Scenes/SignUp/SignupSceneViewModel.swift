
import Foundation

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
            FirebaseManager.shared.registerUser(emailText: emailText, passwordText: passwordText)
        }
    }
    
    func addUserData(username: String, email: String, password: String) {
        FirebaseManager.shared.addUserDataDuringRegistration(username: username,
                                                             email: email,
                                                             password: password)
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
