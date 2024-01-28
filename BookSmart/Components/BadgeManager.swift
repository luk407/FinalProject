//
//  BadgeManager.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 28.01.24.
//

import Foundation

struct BadgeManager {
    
    static func calculateBadges(for user: UserInfo) -> [BadgeInfo] {
        
        let booksCount = user.booksFinished.count
        let commentsCount = user.comments.count
        let connectionsCount = user.connections.count
        let likesCount = user.likedPosts.count
        let quotesCount = user.quotesUsed.count
        let timeSinceRegistration = Calendar.current.dateComponents([.year], from: user.registrationDate, to: Date()).year ?? 0
        
        var badges: [BadgeInfo] = []

        switch booksCount {
        case 0:
            badges.append(BadgeInfo(category: .booksCount, type: .bronze))
        case 1...5:
            badges.append(BadgeInfo(category: .booksCount, type: .silver))
        case 6...10:
            badges.append(BadgeInfo(category: .booksCount, type: .gold))
        case 11...:
            badges.append(BadgeInfo(category: .booksCount, type: .diamond))
        default:
            break
        }
        
        switch commentsCount {
        case 0:
            badges.append(BadgeInfo(category: .commentsCount, type: .bronze))
        case 1...10:
            badges.append(BadgeInfo(category: .commentsCount, type: .silver))
        case 11...20:
            badges.append(BadgeInfo(category: .commentsCount, type: .gold))
        case 21...:
            badges.append(BadgeInfo(category: .commentsCount, type: .diamond))
        default:
            break
        }
        
        switch connectionsCount {
        case 0:
            badges.append(BadgeInfo(category: .connectionsCount, type: .bronze))
        case 1...5:
            badges.append(BadgeInfo(category: .connectionsCount, type: .silver))
        case 6...10:
            badges.append(BadgeInfo(category: .connectionsCount, type: .gold))
        case 11...:
            badges.append(BadgeInfo(category: .connectionsCount, type: .diamond))
        default:
            break
        }
        
        switch likesCount {
        case 0:
            badges.append(BadgeInfo(category: .likesCount, type: .bronze))
        case 1...10:
            badges.append(BadgeInfo(category: .likesCount, type: .silver))
        case 11...20:
            badges.append(BadgeInfo(category: .likesCount, type: .gold))
        case 21...:
            badges.append(BadgeInfo(category: .likesCount, type: .diamond))
        default:
            break
        }
        
        switch quotesCount {
        case 0:
            badges.append(BadgeInfo(category: .quotesCount, type: .bronze))
        case 1...5:
            badges.append(BadgeInfo(category: .quotesCount, type: .silver))
        case 6...10:
            badges.append(BadgeInfo(category: .quotesCount, type: .gold))
        case 11...:
            badges.append(BadgeInfo(category: .quotesCount, type: .diamond))
        default:
            break
        }
        
        switch timeSinceRegistration {
        case 1:
            badges.append(BadgeInfo(category: .oneYearClub, type: .gold))
        case 5:
            badges.append(BadgeInfo(category: .fiveYearClub, type: .diamond))
        default:
            break
        }

        return badges
    }
}


