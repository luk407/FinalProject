
import Foundation
import Firebase

protocol PostsScenesViewModelDelegateForAnnouncement: AnyObject {
    func reloadTableView()
}

protocol PostsScenesViewModelDelegateForStory: AnyObject {
    func reloadTableView()
}

@MainActor
final class PostsScenesViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var userInfo: UserInfo
    
    var fetchedPostsInfo: [PostInfo] = []
    var storyPosts: [PostInfo] = []
    var announcementPosts: [PostInfo] = []
    var filteredStoryPosts: [PostInfo] = []

    weak var storyDelegate: PostsScenesViewModelDelegateForStory?
    weak var announcementDelegate: PostsScenesViewModelDelegateForAnnouncement?

    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo        
    }
    
    // MARK: - Methods
    
    func homeSceneViewWillAppear() {
        //dispatchGroup.enter()
        userInfoListener()
        //dispatchGroup.leave()
        
        //dispatchGroup.enter()
        getPostsInfoFromFirebase() {
            self.storyDelegate?.reloadTableView()
            self.announcementDelegate?.reloadTableView()
        }
       // dispatchGroup.leave()
        
        //dispatchGroup.notify(queue: .main) { [weak self] in
//            self?.storyDelegate?.reloadTableView()
//            self?.announcementDelegate?.reloadTableView()
       // }
    }
    
    func filterStoryPosts(with searchText: String) {
        if searchText == "" {
            filteredStoryPosts = storyPosts
        } else {
            filteredStoryPosts = storyPosts.filter { postInfo in
                let headerMatch = postInfo.header.localizedCaseInsensitiveContains(searchText)
                let bodyMatch = postInfo.body.localizedCaseInsensitiveContains(searchText)
                return headerMatch || bodyMatch
            }
        }
        
        filteredStoryPosts.sort(by: { $0.postingTime > $1.postingTime })
        storyDelegate?.reloadTableView()
    }

    // MARK: - Firebase Methods
    
    func getPostsInfoFromFirebase(completion: @escaping () -> Void) {
        
        FirebaseManager.shared.getPostsInfoFromFirebaseForPostsScenes { fetchedPostsInfo, storyPosts, filteredStoryPosts, announcementPosts in
            
            self.fetchedPostsInfo.removeAll()
            self.storyPosts.removeAll()
            self.announcementPosts.removeAll()
            self.filteredStoryPosts.removeAll()

            self.fetchedPostsInfo = fetchedPostsInfo.sorted(by: { $0.postingTime > $1.postingTime })
            self.storyPosts = storyPosts.sorted(by: { $0.postingTime > $1.postingTime })
            self.filteredStoryPosts = filteredStoryPosts.sorted(by: { $0.postingTime > $1.postingTime })
            self.announcementPosts = announcementPosts.sorted(by: { $0.postingTime > $1.postingTime })
            completion()
        }
    }
    
    private func userInfoListener() {
        
        FirebaseManager.shared.userInfoListener(userIDString: userInfo.id.uuidString) { userInfo in
            self.userInfo = userInfo
        }
    }

    func getAuthorInfo(with authorID: UserInfo.ID, completion: @escaping (UserInfo?) -> Void) {
        FirebaseManager.shared.getAuthorInfo(with: authorID) { userInfo in
            completion(userInfo)
        }
    }
}

