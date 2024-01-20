//
//  CreatePostSceneView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 20.01.24.
//

import SwiftUI

struct CreatePostSceneView: View {
    
    // MARK: - Properties
    
    @State private var selectedTab: Int = 0
    var userInfo: UserInfo
    
    // MARK: - Body
    
    var body: some View {
        
        VStack {
            
            TabView(selection: $selectedTab) {
                
                StoryPostView(viewModel: StoryPostViewModel(userInfo: userInfo))
                    .tabItem {
                        Label("Story", systemImage: "book.pages.fill")
                    }
                    .tag(0)
                
                AnnouncementPostView(viewModel: AnnouncementPostViewModel(userInfo: userInfo))
                    .tabItem {
                        Label("Announcement", systemImage: "megaphone.fill")
                    }
                    .tag(1)
            }
            .accentColor(Color(uiColor: .customAccentColor))
        }
    }
}
