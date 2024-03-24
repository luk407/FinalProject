
import SwiftUI

struct BadgeView: View {
    // MARK: - Properties
    @State private var isShowingBadgeInfo = false
    var badge: BadgeInfo
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            isShowingBadgeInfo.toggle()
        }) {
            badgeView
        }
        .alert(isPresented: $isShowingBadgeInfo) {
            Alert(
                title: Text(badge.category.rawValue),
                message: Text("Badge Type: \(badge.type.rawValue)"),
                dismissButton: .default(Text("OK")))
        }
    }
    
    private var badgeView: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .frame(width: 35, height: 35)
                .foregroundStyle(getColor())
            
            Circle()
                .frame(width: 25, height: 25)
                .foregroundStyle(getColor())
                .overlay {
                    getImageForBadge()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color(uiColor: .black))
                }
        }
    }
    
    private func getColor() -> Color {
        switch badge.category {
        case .oneYearClub:
            return Color(uiColor: .customGoldColor)
        case .fiveYearClub:
            return Color(uiColor: .customDiamondColor)
        default:
            break
        }
        
        switch badge.type {
        case .bronze:
            return Color(uiColor: .customBronzeColor)
        case .silver:
            return Color(uiColor: .customSilverColor)
        case .gold:
            return Color(uiColor: .customGoldColor)
        case .diamond:
            return Color(uiColor: .customDiamondColor)
        }
    }
    
    private func getImageForBadge() -> Image {
        switch badge.category {
        case .booksCount:
            return Image(systemName: "book.fill")
        case.commentsCount:
            return Image(systemName: "text.bubble.fill")
        case .connectionsCount:
            return Image(systemName: "person.3.fill")
        case .likesCount:
            return Image(systemName: "hand.thumbsup.fill")
        case .quotesCount:
            return Image(systemName: "quote.closing")
        case .oneYearClub:
            return Image(systemName: "1.circle")
        case .fiveYearClub:
            return Image(systemName: "5.circle")
        }
    }
}

#Preview {
    BadgeView(badge: BadgeInfo(category: .fiveYearClub, type: .bronze))
}
