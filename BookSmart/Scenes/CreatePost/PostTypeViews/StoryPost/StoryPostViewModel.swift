
import Foundation
import Firebase

final class StoryPostViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var headerText: String = ""
    @Published var bodyText: String = ""
    @Published var isSpoilersAllowed: Bool = false
    @Published var isAddPostSheetPresented: Bool = false
    @Published var selectedQuotes: [Quote] = []
    
    var userInfo: UserInfo
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    // MARK: - Methods
    
    func addQuote(_ quote: Quote) {
        selectedQuotes.append(quote)
    }
    
    func addPost() {
        let newPost = PostInfo(
            id: UUID(),
            authorID: userInfo.id,
            type: .story,
            header: headerText,
            body: bodyText,
            postingTime: Date(),
            likedBy: [],
            comments: [],
            spoilersAllowed: isSpoilersAllowed,
            announcementType: .none
        )
        
        addPostToFirebase(post: newPost)
        
        addQuotesToFirebase(quotes: selectedQuotes)

        updateUserDataOnFirebase(postID: newPost.id)
    }
    
    private func addPostToFirebase(post: PostInfo) {
        FirebaseManager.shared.addPostToFirebase(post: post)
    }
    
    private func addQuotesToFirebase(quotes: [Quote]) {
        FirebaseManager.shared.addQuotesToFirebase(userInfoIDString: userInfo.id.uuidString, quotes: quotes)
    }
    
    private func updateUserDataOnFirebase(postID: UUID) {
        FirebaseManager.shared.updateUserPostsOnFirebase(userInfoIDString: userInfo.id.uuidString, postID: postID)
    }
}
