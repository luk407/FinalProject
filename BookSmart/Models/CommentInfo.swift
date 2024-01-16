//
//  CommentInfo.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation

struct CommentInfo: Identifiable {
    let id = UUID()
    let authorID: [UserInfo.ID]
    let commentTime: String
    var body: String
    var likedBy: [UserInfo.ID]
    var comments: [CommentInfo]
}
