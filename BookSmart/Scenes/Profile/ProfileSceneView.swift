//
//  ProfileSceneViewModel.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import SwiftUI

struct ProfileSceneView: View {
    
    // MARK: - Properties
    
    @ObservedObject var profileSceneViewModel: ProfileSceneViewModel
    
    // MARK: - Body
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                profilePictureView
                
                Spacer()
                
                optionsView
                
            }
            
            namesView
            
            bioView
            
            displayInfoPicker
            
            selectedDisplayInfoView(profileSceneViewModel.displayInfoType)
            
        }
        .background(Color(uiColor: .customBackgroundColor))
        .padding()
        .onAppear {
            profileSceneViewModel.postsInfoListener()
            profileSceneViewModel.commentInfoListener()
            profileSceneViewModel.connectionsInfoListener()
        }
    }
    
    // MARK: - Views
    
    private var profilePictureView: some View {
        Image(systemName: "person.fill")
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(
                Circle()
            )
    }
    
    private var optionsView: some View {
        //MARK: if user is me setting, else add connection
        VStack {
            
            Button {
                
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color(uiColor: .customAccentColor))
            }
        }
    }
    
    private var namesView: some View {
        
        VStack {
            
            TextField("", text: $profileSceneViewModel.userInfo.displayName)
                .font(.system(size: 20).bold())
                .foregroundStyle(.white)
                .disabled(true)
            
            TextField("", text: $profileSceneViewModel.userInfo.userName)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
                .disabled(true)
        }
    }
    
    private var bioView: some View {

        VStack(spacing: 8) {
            
            Text("Bio")
                .font(.system(size: 16).bold())
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Nothing to see here...", text: $profileSceneViewModel.userInfo.bio)
                .font(.system(size: 14))
                .disabled(true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(uiColor: .customAccentColor.withAlphaComponent(0.7)))
                .padding(.vertical, 10)
                
        )
    }
    
    private var badgesView: some View {
        HStack {
            LazyHStack {
                ScrollView(.horizontal) {
                    ForEach(profileSceneViewModel.userInfo.badges, id: \.self) { badge in
                        // MARK: finish this
                    }
                }
            }
        }
    }
    
    private var displayInfoPicker: some View {
        Picker("", selection: $profileSceneViewModel.displayInfoType) {
            Text("POSTS").tag(DisplayInfoType.posts)
            Text("COMMENTS").tag(DisplayInfoType.comments)
            Text("CONNECTIONS").tag(DisplayInfoType.connections)
        }
        .pickerStyle(SegmentedPickerStyle())
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = .customAccentColor
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        }
        .padding()
        .foregroundColor(.white)
        .tint(Color(uiColor: .customAccentColor))
    }
    
    private func selectedDisplayInfoView(_ displayInfoType: DisplayInfoType) -> some View {
        switch profileSceneViewModel.displayInfoType {
        case .posts:
            return AnyView(postsList)
        case .comments:
            return AnyView(commentsList)
        case .connections:
            return AnyView(connectionsList)
        }
    }
    
    private var postsList: some View {
        if profileSceneViewModel.postsInfo.isEmpty {
            return AnyView(EmptyStateView())
        } else {
            return AnyView(
                List {
                    ForEach(profileSceneViewModel.postsInfo) { post in
                        HStack(spacing: 8) {
                            Text(post.body)
                                .font(.system(size: 12))
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(5)
                            
                            VStack(spacing: 8) {
                                Text(profileSceneViewModel.timeAgoString(from: post.postingTime))
                                    .font(.system(size: 10))
                                Spacer()
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(uiColor: .customAccentColor.withAlphaComponent(0.7)))
                            .padding(.vertical, 10)
                    )
                }
                    .scrollContentBackground(.hidden)
                    .listRowSeparator(.hidden)
            )
        }
    }
    
    private var commentsList: some View {
        if profileSceneViewModel.commentsInfo.isEmpty {
            return AnyView(EmptyStateView())
        } else {
            return AnyView(
                List {
                    ForEach(profileSceneViewModel.commentsInfo) { comment in
                        HStack(spacing: 8) {
                            Text(comment.body)
                                .font(.system(size: 12))
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(5)
                            
                            VStack {
                                Text(profileSceneViewModel.timeAgoString(from: comment.commentTime))
                                    .font(.system(size: 10))
                                Spacer()
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(uiColor: .customAccentColor.withAlphaComponent(0.7)))
                            .padding(.vertical, 10)
                    )
                }
                    .scrollContentBackground(.hidden)
                    .listRowSeparator(.hidden)
            )
        }
    }
    
    private var connectionsList: some View {
        if profileSceneViewModel.connectionsInfo.isEmpty {
            return AnyView(EmptyStateView())
        } else {
            return AnyView(
                List {
                    ForEach(profileSceneViewModel.connectionsInfo) { connection in
                        HStack(spacing: 8) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            
                            VStack(spacing: 8) {
                                Text(connection.displayName)
                                    .font(.system(size: 14).bold())
                                    .foregroundStyle(.black)
                                
                                Text(connection.userName)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(uiColor: .customAccentColor.withAlphaComponent(0.7)))
                            .padding(.vertical, 10)
                    )
                }
                    .scrollContentBackground(.hidden)
                    .listRowSeparator(.hidden)
            )
        }
    }
}
