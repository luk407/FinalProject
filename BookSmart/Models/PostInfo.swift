
import Foundation

enum PostType: String {
    case story, announcement
}

enum AnnouncementType: String {
    case none, startedBook, finishedBook
}

struct PostInfo: Identifiable {
    let id: UUID
    let authorID: UserInfo.ID
    let type: PostType
    var header: String
    var body: String
    let postingTime: Date
    var likedBy: [UserInfo.ID]
    var comments: [CommentInfo.ID]
    var spoilersAllowed: Bool
    var announcementType: AnnouncementType
}
