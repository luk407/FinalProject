//
//  CommentInfo.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation

struct CommentInfo: Identifiable, Codable, Hashable {
    let id: UUID
    let authorID: UserInfo.ID
    let commentTime: Date
    var body: String
    var likedBy: [UserInfo.ID]
    var comments: [CommentInfo.ID]
}
