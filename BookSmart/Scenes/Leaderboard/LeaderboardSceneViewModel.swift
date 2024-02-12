
import UIKit

protocol LeaderboardSceneViewModelDelegate: AnyObject {
    func updateUserImage(userIndex: Int, userImage: UIImage)
    func updatePodiumUI()
    func updateTableViewRows(indexPaths: [IndexPath])
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
    }
    
    // MARK: - Methods
    
    func refetchInfo(completion: @escaping () -> Void) {
        getAllUsersInfo { usersInfo in
            if let usersInfo {
                self.fetchedUsersInfo = usersInfo.sorted { $0.booksFinished.count > $1.booksFinished.count }
                
                self.retrieveAllImages {
                    self.delegate?.updatePodiumUI()
                    completion()
                }
            }
        }
    }
    
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
        completion()
    }
    
    private func fetchImagesSequentially(completion: @escaping () -> Void) {
        fetchNextImage(index: 0)
        
        func fetchNextImage(index: Int) {
            guard index < fetchedUsersInfo.count else {
                notifyTableViewRowsUpdated()
                completion()
                return
            }
            
            let user = fetchedUsersInfo[index]
            let imageName = user.id.uuidString
            
            if let cachedImage = CacheManager.instance.get(name: imageName) {
                delegate?.updateUserImage(userIndex: index, userImage: cachedImage)
                fetchedUserImages[user.id.uuidString] = cachedImage
            } else {
                fetchImage(imageName, userIndex: index) { retrievedImage in
                    self.fetchedUserImages[user.id.uuidString] = retrievedImage
                    CacheManager.instance.add(image: retrievedImage, name: user.id.uuidString)
                }
            }
            fetchNextImage(index: index + 1)
        }
    }

    private func fetchImage(_ imageName: String, userIndex: Int, completion: @escaping (UIImage) -> Void)  {
        let userID = self.fetchedUsersInfo[userIndex].id
        
        FirebaseManager.shared.retrieveImage(userID.uuidString) { retrievedImage in
            self.delegate?.updateUserImage(userIndex: userIndex, userImage: retrievedImage)
            completion(retrievedImage)
        }
    }
    
    private func notifyTableViewRowsUpdated() {
        guard fetchedUsersInfo.count > 3 else { return }
        let indexPaths = (0..<fetchedUsersInfo.count - 3).map { IndexPath(row: $0, section: 0) }
        delegate?.updateTableViewRows(indexPaths: indexPaths)
    }
}
