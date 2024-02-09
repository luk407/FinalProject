
import SwiftUI
import Firebase


protocol PostDetailsSceneViewDelegateForStory: AnyObject {
    func updateLikeButtonUI(isLiked: Bool)
}

protocol PostDetailsSceneViewDelegateForAnnouncement: AnyObject {
    func updateLikeButtonUI(isLiked: Bool)
}

protocol PostDetailsSceneViewDelegate: AnyObject {
    func postUpdated()
    func commentAdded()
}

final class PostDetailsSceneViewModel {
    
    // MARK: - Properties
    
    var userInfo: UserInfo
    var postInfo: PostInfo
    var commentsInfo: [CommentInfo]?
    
    weak var delegate: PostDetailsSceneViewDelegate?
    weak var storyCellDelegate: PostDetailsSceneViewDelegateForStory?
    weak var announcementCellDelegate: PostDetailsSceneViewDelegateForAnnouncement?
    
    private var dispatchGroup = DispatchGroup()
    
    // MARK: - Init
    
    init(userInfo: UserInfo, postInfo: PostInfo) {
        self.userInfo = userInfo
        self.postInfo = postInfo
    }
    
    // MARK: - Methods
    
    func postDetailsSceneViewWillAppear() {
        dispatchGroup.enter()
        commentsInfoListener() {
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.delegate?.postUpdated()
        }
    }
    
    // MARK: - Methods for posts
    
    func toggleLikePost(completion: @escaping (Bool) -> Void) {
        
        FirebaseManager.shared.toggleLikePost(userInfoIDString: userInfo.id.uuidString,
                                              postInfoIDString: postInfo.id.uuidString) { hasLiked in
            
            completion(hasLiked)
        }
    }
    
    // MARK: - Methods for comments
    
    func commentsInfoListener(completion: @escaping () -> Void) {
        FirebaseManager.shared.commentInfoListenerForPostDetails(commentsIDs: postInfo.comments) { commentsArray in
            self.commentsInfo = commentsArray
        }
        completion()
    }
    
    func submitCommentButtonTapped(commentText: String) {
        addCommentToFirebase(commentText: commentText) {
            self.dispatchGroup.enter()
            self.commentsInfoListener() {
                self.dispatchGroup.leave()
            }
            
            self.dispatchGroup.notify(queue: .main) {
                self.delegate?.commentAdded()
            }
        }
    }
    
    private func addCommentToFirebase(commentText: String, completion: @escaping () -> Void) {
        FirebaseManager.shared.addCommentToFirebase(userInfoID: userInfo.id,
                                                    postInfoIDString: postInfo.id.uuidString,
                                                    commentText: commentText) { newCommentID in
            self.postInfo.comments.append(newCommentID)
        }
        completion()
    }
    
    func getCommentInfo(for commentID: UUID) -> CommentInfo? {
        return commentsInfo?.first { $0.id == commentID }
    }
    
    func getAuthorInfo(with authorID: UserInfo.ID, completion: @escaping (UserInfo?) -> Void)  {
        
        FirebaseManager.shared.getAuthorInfo(with: authorID) { authorInfo in
            completion(authorInfo)
        }
    }
}
