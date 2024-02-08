
import Foundation
import Firebase

protocol LoginSceneViewDelegate: AnyObject {
    func navigateToTabBarController()
    func loginError()
}

final class LoginSceneViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var fetchedUserData: UserInfo?
    private var dispatchGroup = DispatchGroup()

    weak var delegate: LoginSceneViewDelegate?
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - Methods
    
    func loginAndNavigate(email: String, password: String) {
        
        dispatchGroup.enter()
        loginToFirebase(email: email, password: password) {
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getUserInfo(email: email, password: password) {
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.delegate?.navigateToTabBarController()
        }
    }
    
    private func loginToFirebase(email: String, password: String, completion: @escaping () -> Void) {
        FirebaseManager.shared.loginToFirebase(email: email, password: password) { success in
            if !success {
                self.delegate?.loginError()
            }
            completion()
        }
    }

    // MARK: - Firebase Methods
    
    private func getUserInfo(email: String, password: String, completion: @escaping () -> Void) {
        FirebaseManager.shared.getUserInfoToLogin(with: email, and: password) { userInfo in
            self.fetchedUserData = userInfo
        }
        completion()
    }
}
