//
//  BadgeInfo.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation

enum BadgeCategory {
    case booksCount, commentsCount, likesCount, connectionsCount, quotesCount, oneYearClub, fiveYearClub
}

enum BadgeType {
    case bronze, silver, gold, diamond
}

struct BadgeInfo {
    let category: BadgeCategory
    let type: BadgeType
}
