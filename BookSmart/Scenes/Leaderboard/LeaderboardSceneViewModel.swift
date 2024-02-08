
import Foundation
import Firebase
import FirebaseStorage

protocol LeaderboardSceneViewModelDelegate: AnyObject {
    func updateUserImage(userIndex: Int, userImage: UIImage)
}

final class LeaderboardSceneViewModel {
    
    // MARK: - Properties
    
    var userInfo: UserInfo
    var fetchedUsersInfo: [UserInfo] = []
    var fetchedUserImages: [String: UIImage] = [:]
    weak var delegate: LeaderboardSceneViewModelDelegate?
    let group = DispatchGroup()
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        
        getAllUsersInfo { usersInfo in
            if let usersInfo {
                self.fetchedUsersInfo = usersInfo.sorted { $0.booksFinished.count > $1.booksFinished.count }
            }
        }
        
    }
    
    // MARK: - Methods
    
    func getAllUsersInfo(completion: @escaping ([UserInfo]?) -> Void) {
        FirebaseManager.shared.getAllUsersInfo { allUserInfo in
            completion(allUserInfo)
        }
    }
    
    func getImage(userID: UserInfo.ID) -> UIImage? {
        return CacheManager.instance.get(name: userID.uuidString)
    }

    func retrieveAllImages(completion: @escaping () -> Void) {
        self.fetchImagesSequentially(completion: completion)
    }
    
    private func fetchImagesSequentially(completion: @escaping () -> Void) {
        var index = 0
        
        func fetchNextImage() {
            guard index < fetchedUsersInfo.count else {
                completion()
                return
            }
            
            let user = fetchedUsersInfo[index]
            let imageName = user.id.uuidString
            
            if let cachedImage = CacheManager.instance.get(name: imageName) {
                delegate?.updateUserImage(userIndex: index, userImage: cachedImage)
                fetchedUserImages[user.id.uuidString] = cachedImage
                index += 1
                fetchNextImage()
            } else {
                fetchImage(imageName, userIndex: index) {
                    index += 1
                    fetchNextImage()
                }
            }
        }
        
        fetchNextImage()
    }

    private func fetchImage(_ imageName: String, userIndex: Int, completion: @escaping () -> Void)  {
//        let storageReference = Storage.storage().reference()
//        let fileReference = storageReference.child("profileImages/\(imageName).jpg")
        let userID = self.fetchedUsersInfo[userIndex].id
        
        FirebaseManager.shared.retrieveImage(userID.uuidString) { retrievedImage in
            self.delegate?.updateUserImage(userIndex: userIndex, userImage: retrievedImage)
        }
//        fileReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
//            if let data = data, error == nil, let fetchedImage = UIImage(data: data) {
//                CacheManager.instance.add(image: fetchedImage, name: userID.uuidString)
//                self.delegate?.updateUserImage(userIndex: userIndex, userImage: fetchedImage)
//                completion()
//            } else {
//                print("Error fetching image:", error?.localizedDescription ?? "Unknown error")
//                CacheManager.instance.add(image: UIImage(systemName: "person.fill")!, name: userID.uuidString)
//                self.delegate?.updateUserImage(userIndex: userIndex, userImage: UIImage(systemName: "person.fill")!)
//                completion()
//            }
//        }
    }
}
