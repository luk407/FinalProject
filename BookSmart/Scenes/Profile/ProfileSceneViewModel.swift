
import SwiftUI

enum DisplayInfoType {
    case posts, comments, connections
}

final class ProfileSceneViewModel: ObservableObject {
    // MARK: - Properties
    var profileOwnerInfoID: UserInfo.ID
    @Published var userInfo: UserInfo
    @Published var fetchedOwnerInfo: UserInfo?
    let connectionGroup = DispatchGroup()
    let dispatchGroup = DispatchGroup()
    
    @Published var displayInfoType: DisplayInfoType = .posts
    @Published var ownerPostsInfo: [PostInfo] = []
    @Published var allPostsInfo: [PostInfo] = []
    @Published var commentsInfo: [CommentInfo] = []
    @Published var connectionsInfo: [UserInfo] = []
    @Published var selectedImage: UIImage?
    @Published var isOwnProfile = false
    @Published var isEditable = false
    @Published var isInConnections = false
    @Published var isImagePickerShowing = false
    @Published var fetchedOwnerDisplayName: String = ""
    @Published var fetchedOwnerUsername: String = ""
    @Published var fetchedOwnerBio: String = ""
    @Published var fetchedOwnerImage = UIImage()
    
    var ownerBadges: [BadgeInfo] {
        var badges: [BadgeInfo] = []

        if let fetchedOwnerInfo = fetchedOwnerInfo {
            badges = BadgeManager.calculateBadges(for: fetchedOwnerInfo)
        }
        
        return badges
    }
    
    // MARK: - Init
    init(profileOwnerInfoID: UserInfo.ID, userInfo: UserInfo) {
        self.profileOwnerInfoID = profileOwnerInfoID
        self.userInfo = userInfo
    }
    
    // MARK: - Methods
    func viewOnAppear() {
        fetchOwnerInfo() { [self] in
            userInfoListener()
            postsInfoListener()
            commentInfoListener()
            fetchConnectionsInfo { connectionsInfo in
                self.connectionsInfo = connectionsInfo
            }
            
            checkProfileOwner()
            checkIfInConnections()
        }
    }
    
    private func checkProfileOwner() {
        if profileOwnerInfoID == userInfo.id {
            isOwnProfile = true
        } else {
            isOwnProfile = false
        }
    }
    
    private func checkIfInConnections() {
        if userInfo.connections.contains(where: { $0.uuidString == profileOwnerInfoID.uuidString }) {
            isInConnections = true
        } else {
            isInConnections = false
        }
    }
  
    func addRemoveConnections() {
        if self.isInConnections {
            DispatchQueue.main.async {
                self.removeConnection() {
                    self.isInConnections = false
                }
                self.scheduleNotification(message: "You are no longer connected with \(self.fetchedOwnerDisplayName)")
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.addConnection() {
                    self.isInConnections = true
                }
                self.scheduleNotification(message: "You are now connected with \(self.fetchedOwnerDisplayName)")
            }
        }
    }
    
    func findPostInfo(for commentID: UUID) -> PostInfo? {
        for post in allPostsInfo {
            if post.comments.contains(commentID) {
                return post
            }
        }
        return nil
    }

    func scheduleNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "BookSmart"
        content.body = message
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: "connectionNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }

    func editProfile() {
        if isEditable {
            isEditable = false
            if selectedImage != nil {
                uploadImage()
            }
            updateUserProfile()
        } else {
            isEditable = true
        }
    }

    // MARK: - Firebase Methods
    private func userInfoListener() {
        FirebaseManager.shared.userInfoListener(userIDString: userInfo.id.uuidString) { userInfo in
            self.userInfo = userInfo
        }
    }
    
    private func fetchOwnerInfo(completion: @escaping () -> Void) {
        fetchOwnerInfo(with: profileOwnerInfoID) { userInfo in
            if let userInfo = userInfo {
                self.fetchedOwnerInfo = userInfo
                self.fetchedOwnerDisplayName = userInfo.displayName
                self.fetchedOwnerUsername = "@\(userInfo.userName)"
                self.fetchedOwnerBio = userInfo.bio
                self.fetchOwnerImage()
            }
            completion()
        }
    }
    
    private func fetchOwnerImage() {
        guard let fetchedOwnerInfo = fetchedOwnerInfo else { return }
        
        retrieveImage(for: fetchedOwnerInfo) { image in
            DispatchQueue.main.async {
                self.fetchedOwnerImage = image ?? UIImage(systemName: "person.fill")!
            }
        }
    }
    
    private func postsInfoListener() {
        FirebaseManager.shared.postsInfoListenerForProfile(profileOwnerID: profileOwnerInfoID) { postsInfo in
            let filteredPosts = postsInfo.filter { $0.authorID == self.profileOwnerInfoID }
            
            self.allPostsInfo = postsInfo
            self.ownerPostsInfo = filteredPosts
        }
    }
    
    func deletePost(_ post: PostInfo) {
        FirebaseManager.shared.deletePost(post)
    }
    
    private func commentInfoListener() {
        FirebaseManager.shared.commentInfoListenerForProfile(profileOwnerIDString: profileOwnerInfoID.uuidString) { commentsInfo in
            self.commentsInfo = commentsInfo
        }
    }
    
    func deleteComment(_ comment: CommentInfo, for post: PostInfo) {
        FirebaseManager.shared.deleteComment(comment, for: post)
    }
    
    private func connectionsInfoListener() {
        FirebaseManager.shared.connectionsInfoListener(profileOwnerIdString: profileOwnerInfoID.uuidString) { connectionsInfo in
            self.connectionsInfo = connectionsInfo
        }
    }
    
    private func fetchConnectionsInfo(completion: @escaping ([UserInfo]) -> Void) {
        guard fetchedOwnerInfo != nil else { return }
        
        var connectionsArray: [UserInfo] = []
        let group = DispatchGroup()
        
        for connection in fetchedOwnerInfo!.connections {
            group.enter()
            FirebaseManager.shared.getUserInfo(userIDString: connection.uuidString) { connectionInfo in
                connectionsArray.append(connectionInfo)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.connectionsInfo = connectionsArray
        }
    }
    
    private func fetchOwnerInfo(with userID: UUID, completion: @escaping (UserInfo?) -> Void) {
        FirebaseManager.shared.userInfoListener(userIDString: userID.uuidString) { ownerInfo in
            completion(ownerInfo)
        }
    }
    
    private func addConnection(completion: @escaping () -> Void) {
        FirebaseManager.shared.addConnection(userIDString: userInfo.id.uuidString,
                                             profileOwnerIDString: profileOwnerInfoID.uuidString)
        completion()
    }

    private func removeConnection(completion: @escaping () -> Void) {
        FirebaseManager.shared.removeConnection(userIDString: userInfo.id.uuidString,
                                                profileOwnerIDString: profileOwnerInfoID.uuidString)
        completion()
    }

    private func uploadImage() {
        guard let selectedImage else { return }
        FirebaseManager.shared.uploadImage(selectedImage: selectedImage, userIDString: userInfo.id.uuidString)
    }
    
    func retrieveImage(for user: UserInfo, completion: @escaping (UIImage?) -> Void) {
        FirebaseManager.shared.retrieveImage(user.id.uuidString) { retrievedImage in
            completion(retrievedImage)
        }
    }
    
    func getImageFromCache(userIDString: String) -> UIImage {
        return CacheManager.instance.get(name: userIDString) ?? UIImage(systemName: "person.fill")!
    }
    
    func updateUserProfile() {
        FirebaseManager.shared.updateUserProfile(userIDString: userInfo.id.uuidString,
                                                 displayName: fetchedOwnerDisplayName,
                                                 username: String(fetchedOwnerUsername.dropFirst()),
                                                 bio: fetchedOwnerBio,
                                                 badges: ownerBadges)
    }
}
