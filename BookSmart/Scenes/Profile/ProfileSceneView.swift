
import SwiftUI

struct ProfileSceneView: View {
    
    // MARK: - Properties
    
    @ObservedObject var profileSceneViewModel: ProfileSceneViewModel
    
    private let gridColumns = [GridItem(.fixed(40)), GridItem(.fixed(40)), GridItem(.fixed(40))]
    
    // MARK: - Body
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                profilePictureView
                
                Spacer()
                
                badgesVGrid
            }
            
            HStack {
                
                namesView
                
                Spacer()
                
                optionsView
            }
            
            bioView
            
            displayInfoPicker
            
            selectedDisplayInfoView(profileSceneViewModel.displayInfoType)
            
        }
        .background(Color(uiColor: .customBackgroundColor))
        .padding()
        .task {
            profileSceneViewModel.viewOnAppear()
        }
        .sheet(isPresented: $profileSceneViewModel.isImagePickerShowing) {
            ImagePicker(
                selectedImage: $profileSceneViewModel.selectedImage,
                isPickerShowing: $profileSceneViewModel.isImagePickerShowing)
        }
    }
    
    // MARK: - Views
    
    private var profilePictureView: some View {
        ZStack {
            
            Circle()
                .stroke(lineWidth: 4)
                .frame(width: 110, height: 110)
                .foregroundStyle(Color(uiColor: .customAccentColor))
            
            Image(uiImage: (profileSceneViewModel.selectedImage == nil ? profileSceneViewModel.fetchedOwnerImage : profileSceneViewModel.selectedImage)!)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(
                    Circle()
                )
                .overlay(alignment: .bottomTrailing) {
                    if profileSceneViewModel.isEditable {
                        Button {
                            profileSceneViewModel.isImagePickerShowing = true
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color(uiColor: .customBackgroundColor))
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color(uiColor: .customDarkGreenColor))
                            }
                        }
                    }
                }
        }
    }
    
    private var optionsView: some View {
        
        VStack {
            if profileSceneViewModel.isOwnProfile {
                editProfileButton
            } else {
                addRemoveConnectionButton
            }
        }
    }
    
    private var editProfileButton: some View {
        Button {
            profileSceneViewModel.editProfile()
        } label: {
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color(uiColor: profileSceneViewModel.isEditable ? .customDarkRedColor : .customDarkGreenColor))
        }
    }
    
    private var addRemoveConnectionButton: some View {
        Button {
            profileSceneViewModel.addRemoveConnections()
        } label: {
            Image(systemName: profileSceneViewModel.isInConnections ? "person.fill.badge.minus" : "person.fill.badge.plus")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color(uiColor: profileSceneViewModel.isInConnections ? .customDarkRedColor : .customDarkGreenColor))
        }
    }
    
    private var namesView: some View {
        
        VStack {
            
            TextField("", text: $profileSceneViewModel.fetchedOwnerDisplayName)
                .autocorrectionDisabled()
                .font(.system(size: 24).bold())
                .foregroundStyle(.white)
                .disabled(!profileSceneViewModel.isEditable)
            
            TextField("", text: $profileSceneViewModel.fetchedOwnerUsername)
                .autocorrectionDisabled()
                .font(.system(size: 16))
                .foregroundStyle(.gray)
                .disabled(!profileSceneViewModel.isEditable)
        }
        .padding(.horizontal, 20)
    }
    
    private var bioView: some View {

        VStack(spacing: 8) {
            
            Text("Bio")
                .font(.system(size: 16).bold())
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Nothing to see here...", text: $profileSceneViewModel.fetchedOwnerBio)
                .autocorrectionDisabled()
                .font(.system(size: 14))
                .foregroundStyle(.black)
                .disabled(!profileSceneViewModel.isEditable)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(uiColor: .customAccentColor.withAlphaComponent(0.7)))
                .padding(.vertical, 10)
        )
    }
    
    private var badgesVGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 10) {
            ForEach(profileSceneViewModel.ownerBadges, id: \.self) { badge in
                BadgeView(badge: badge)
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
        if profileSceneViewModel.ownerPostsInfo.isEmpty {
            return AnyView(EmptyStateView())
        } else {
            return AnyView(
                List {
                    ForEach(profileSceneViewModel.ownerPostsInfo) { post in
                       postListItem(post)
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
    
    private func postListItem(_ post: PostInfo) -> some View {
        NavigationLink(destination: PostDetailsSceneViewRepresentable(userInfo: profileSceneViewModel.userInfo, postInfo: post).ignoresSafeArea()) {
            
            HStack(spacing: 8) {
                
                Text(post.header)
                    .font(.system(size: 12))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(5)
                
                VStack(spacing: 8) {
                    Text(MethodsManager.shared.timeAgoString(from: post.postingTime))
                        .font(.system(size: 10))
                        .foregroundStyle(.black)
                    Spacer()
                }
            }
            .padding(.vertical, 10)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if profileSceneViewModel.isOwnProfile {
                Button {
                    profileSceneViewModel.deletePost(post)
                } label: {
                    Text("Delete")
                }
                .tint(.clear)
            }
        }
    }
    
    private var commentsList: some View {
        if profileSceneViewModel.commentsInfo.isEmpty {
            return AnyView(EmptyStateView())
        } else {
            return AnyView(
                List {
                    ForEach(profileSceneViewModel.commentsInfo) { comment in
                        commentsListItem(comment)
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
    
    private func commentsListItem(_ comment: CommentInfo) -> some View {
        if let post = profileSceneViewModel.findPostInfo(for: comment.id) {
            return AnyView(
                NavigationLink(destination: PostDetailsSceneViewRepresentable(userInfo: profileSceneViewModel.userInfo, postInfo: post).ignoresSafeArea()) {
                HStack(spacing: 8) {
                    Text(comment.body)
                        .font(.system(size: 12))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(5)
                    
                    VStack {
                        Text(MethodsManager.shared.timeAgoString(from: comment.commentTime))
                            .font(.system(size: 10))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                }
                .padding(.vertical, 10)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                if profileSceneViewModel.isOwnProfile {
                    Button {
                        profileSceneViewModel.deleteComment(comment, for: post)
                    } label: {
                        Text("Delete")
                    }
                    .tint(.clear)
                }
            })
        } else {
            return AnyView(EmptyStateView())
        }
    }
    
    private var connectionsList: some View {
        if profileSceneViewModel.connectionsInfo.isEmpty {
            return AnyView(EmptyStateView())
        } else {
            return AnyView(
                List {
                    ForEach(profileSceneViewModel.connectionsInfo) { connection in
                        connectionListItem(connection)
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
    
    private func connectionListItem(_ connection: UserInfo) -> some View {
        NavigationLink(destination: ProfileSceneView(profileSceneViewModel: ProfileSceneViewModel(profileOwnerInfoID: connection.id, userInfo: profileSceneViewModel.userInfo)).background(Color(uiColor: .customBackgroundColor))) {
            HStack(spacing: 16) {
                Image(uiImage: profileSceneViewModel.getImageFromCache(userIDString: connection.id.uuidString))
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(connection.displayName)
                        .font(.system(size: 16).bold())
                        .foregroundStyle(.black)
                    
                    Text("@\(connection.userName)")
                        .font(.system(size: 12))
                        .foregroundStyle(.black.opacity(0.8))
                }
            }
            .padding(.vertical, 10)
        }
    }
}
