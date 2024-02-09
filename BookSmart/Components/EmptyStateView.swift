
import SwiftUI

struct EmptyStateView: View {
    
    var body: some View {
        
        VStack {
            
            Image(systemName: "questionmark.app.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundStyle(.gray)
            
            Text("NOTHING HERE")
                .font(.system(size: 30).bold())
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .customBackgroundColor))
    }
}
