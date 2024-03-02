
import SwiftUI

struct PostDetailsSceneViewRepresentable: UIViewControllerRepresentable {
    
    let userInfo: UserInfo
    let postInfo: PostInfo
    
    func makeUIViewController(context: Context) -> PostDetailsSceneView {
        let viewController = PostDetailsSceneView(viewModel: PostDetailsSceneViewModel(userInfo: userInfo, postInfo: postInfo))
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: PostDetailsSceneView, context: Context) {
        
    }
}
