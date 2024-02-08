
import Foundation

struct UserInfo: Identifiable {
    let id: UUID
    var userName: String
    var email: String
    var password: String
    var displayName: String
    let registrationDate: Date
    var bio: String
    var image: String
    var badges: [BadgeInfo]
    var posts: [PostInfo.ID]
    var comments: [CommentInfo.ID]
    var likedPosts: [PostInfo.ID]
    var connections: [UserInfo.ID]
    var booksFinished: [Book]
    var quotesUsed: [Quote]
}
