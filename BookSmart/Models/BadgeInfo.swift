
import Foundation

enum BadgeCategory: String {
    case booksCount = "Books Read"
    case commentsCount = "Comments Made"
    case likesCount = "Likes Received"
    case connectionsCount = "Connections Made"
    case quotesCount = "Quotes Added"
    case oneYearClub = "1 Year Club"
    case fiveYearClub = "5 Year Club"
}

enum BadgeType: String {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case diamond = "Diamond"
}

struct BadgeInfo: Hashable {
    let category: BadgeCategory
    let type: BadgeType
}
