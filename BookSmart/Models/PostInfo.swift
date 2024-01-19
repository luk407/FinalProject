//
//  PostInfo.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation

enum PostType: String {
    case story, achievement
}

enum AchievementType: String {
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
    var comments: [CommentInfo]
    var spoilersAllowed: Bool
    var achievementType: AchievementType = .none
}
