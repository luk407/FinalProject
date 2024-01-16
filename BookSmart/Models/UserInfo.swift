//
//  UserInfo.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation

struct UserInfo: Identifiable {
    let id = UUID()
    var userName: String
    var email: String
    var password: String
    var displayName: String
    let registrationDate: String
    var bio: String
    var image: String
    var badges: [BadgeInfo]
    var posts: [PostInfo]
    var comments: [CommentInfo]
    var likedPosts: [PostInfo]
    var connections: [UserInfo]
    var booksFinished: [Book]
    var quotesUsed: [Quote]
}
