
import Foundation
import Firebase

protocol PostsScenesViewModelDelegateForAnnouncement: AnyObject {
    func reloadTableViewWithAnimation()
    func reloadTableView()
}

protocol PostsScenesViewModelDelegateForStory: AnyObject {
    func reloadTableViewWithAnimation()
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
    
    var limit = 5
    var storyPostsToDisplay: [PostInfo] = []
    var announcementPostsToDisplay: [PostInfo] = []

    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo        
    }
    
    // MARK: - Methods
    
    func homeSceneViewWillAppear() {
        userInfoListener()
        getPostsInfoFromFirebase() {
            self.loadInitialStoryPosts()
            self.storyDelegate?.reloadTableViewWithAnimation()
            self.announcementDelegate?.reloadTableViewWithAnimation()
        }
    }
    
    func filterStoryPosts(with searchText: String) {
        if searchText == "" {
            storyPostsToDisplay = storyPosts
            filteredStoryPosts = storyPosts
        } else {
            filteredStoryPosts = storyPosts.filter { postInfo in
                let headerMatch = postInfo.header.localizedCaseInsensitiveContains(searchText)
                let bodyMatch = postInfo.body.localizedCaseInsensitiveContains(searchText)
                return headerMatch || bodyMatch
            }
            
            storyPostsToDisplay = storyPosts.filter { postInfo in
                let headerMatch = postInfo.header.localizedCaseInsensitiveContains(searchText)
                let bodyMatch = postInfo.body.localizedCaseInsensitiveContains(searchText)
                return headerMatch || bodyMatch
            }
        }
        
        filteredStoryPosts.sort(by: { $0.postingTime > $1.postingTime })
        storyPostsToDisplay.sort(by: { $0.postingTime > $1.postingTime })
        storyDelegate?.reloadTableViewWithAnimation()
    }
    
    func loadInitialStoryPosts() {
        limit = 5
        storyPostsToDisplay = []
        
        var itemIndex = 0
        
        while itemIndex < limit && itemIndex < filteredStoryPosts.count {
            storyPostsToDisplay.append(filteredStoryPosts[itemIndex])
            itemIndex += 1
        }
    }
    
    func loadMoreStoryPosts() {
        if storyPostsToDisplay.count < filteredStoryPosts.count {
            var itemIndex = storyPostsToDisplay.count
            limit = itemIndex + 5
            while itemIndex < limit && itemIndex < filteredStoryPosts.count {
                storyPostsToDisplay.append(filteredStoryPosts[itemIndex])
                itemIndex += 1
            }
            storyDelegate?.reloadTableView()
        }
    }
    
    func loadInitialAnnouncementPosts() {
        limit = 5
        announcementPostsToDisplay = []
        
        var itemIndex = 0
        
        while itemIndex < limit && itemIndex < announcementPosts.count {
            announcementPostsToDisplay.append(announcementPosts[itemIndex])
            itemIndex += 1
        }
    }
    
    func loadMoreAnnouncementPosts() {
        if announcementPostsToDisplay.count < announcementPosts.count {
            var itemIndex = announcementPostsToDisplay.count
            limit = itemIndex + 5
            while itemIndex < limit && itemIndex < announcementPosts.count {
                announcementPostsToDisplay.append(announcementPosts[itemIndex])
                itemIndex += 1
            }
            announcementDelegate?.reloadTableView()
        }
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

