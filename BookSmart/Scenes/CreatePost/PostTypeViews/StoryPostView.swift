//
//  StoryPostView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 20.01.24.
//

import SwiftUI
import Firebase

struct StoryPostView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    @State var headerText: String = ""
    @State private var bodyText: String = ""
    @State private var isSpoilersAllowed: Bool = false
    @State private var isAddPostSheetPresented: Bool = false
    
    var userInfo: UserInfo
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 8) {
                
                headerTextField
                
                bodyTextField
                
                Spacer()
                
                spoilersToggle
                
                addPostButton
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color(uiColor: .customBackgroundColor))
            .navigationBarItems(trailing: addQuoteButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $isAddPostSheetPresented) {
            Text("New Page Content")
        }
    }
    
    // MARK: - Views
    
    private var headerTextField: some View {
        
        TextField("", text: $headerText, prompt: Text("Post Header...").foregroundColor(.black), axis: .vertical)
            .textFieldStyle(.plain)
            .lineLimit(1)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(uiColor: .customAccentColor.withAlphaComponent(0.5)))
            )
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
    }
    
    private var bodyTextField: some View {
        
        TextField("", text: $bodyText, prompt: Text("Post Body...").foregroundColor(.black), axis: .vertical)
            .frame(height: 200, alignment: .topLeading)
            .textFieldStyle(.plain)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(uiColor: .customAccentColor.withAlphaComponent(0.5)))
            )
            .foregroundColor(.black)
    }
    
    private var spoilersToggle: some View {
        Toggle("Allow Spoilers", isOn: $isSpoilersAllowed)
            .padding()
            .foregroundColor(.white)
            .tint(Color(uiColor: .customAccentColor))
    }
    
    private var addQuoteButton: some View {
        Button(action: {
            isAddPostSheetPresented.toggle()
        }) {
            Text("Add Quote")
        }
    }
    
    private var addPostButton: some View {
        Button {
            addPost()
            dismiss()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 50)
                .overlay(content: {
                    Text("Add Post")
                        .foregroundStyle(.black)
                })
        }
    }
    
    // MARK: - Methods
    
    private func addPost() {
        let newPost = PostInfo(
            id: UUID(),
            authorID: userInfo.id,
            type: .story,
            header: headerText,
            body: bodyText,
            postingTime: Date(),
            likedBy: [],
            comments: [],
            spoilersAllowed: isSpoilersAllowed,
            announcementType: .none
        )
        
        addPostToFirebase(post: newPost)
        
        updateUserDataOnFirebase(postID: newPost.id)
    }
    
    private func addPostToFirebase(post: PostInfo) {
        let database = Firestore.firestore()
        let postReference = database.collection("PostInfo").document(post.id.uuidString)
        
        let postData: [String: Any] = [
            "id": post.id.uuidString,
            "authorID": post.authorID.uuidString,
            "type": post.type.rawValue,
            "header": post.header,
            "body": post.body,
            "postingTime": post.postingTime,
            "likedBy": post.likedBy.map { $0.uuidString },
            "comments": post.comments.map { $0.uuidString },
            "spoilersAllowed": post.spoilersAllowed,
            "announcementType": post.announcementType.rawValue
        ]
        
        postReference.setData(postData)
    }
    
    private func updateUserDataOnFirebase(postID: UUID) {
        let database = Firestore.firestore()
        let userReference = database.collection("UserInfo").document(userInfo.id.uuidString)
        
        userReference.updateData(["posts": FieldValue.arrayUnion([postID.uuidString])]) { error in
            if let error = error {
                print("Error updating user data on Firebase: \(error.localizedDescription)")
            }
        }
    }
}
