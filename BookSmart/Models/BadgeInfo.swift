//
//  BadgeInfo.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation

enum BadgeCategory: String {
    case booksCount, commentsCount, likesCount, connectionsCount, quotesCount, oneYearClub, fiveYearClub
}

enum BadgeType: String {
    case bronze, silver, gold, diamond
}

struct BadgeInfo: Hashable {
    let category: BadgeCategory
    let type: BadgeType
}
