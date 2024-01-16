//
//  PostInfo.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation

enum PostType {
    case story, achievement
}

enum AchievementType {
    case startedBook, finishedBook
}

struct PostInfo: Identifiable {
    let id = UUID()
    let type: PostType
    var header: String
    var body: String
    let postingTime: String
    var likedBy: [UserInfo.ID]
    var comments: [CommentInfo]
    var spoilersAllowed: Bool
    var achievementType: AchievementType?
}
