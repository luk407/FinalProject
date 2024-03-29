
import SwiftUI

struct AnnouncementPostView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AnnouncementPostViewModel
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                searchList
                
                if viewModel.selectedBook != nil {
                    selectedBookInfo
                }
                
                spoilersToggle
                
                announcementPicker
                
                addPostButton
                    .padding()
            }
            .onReceive(viewModel.objectWillChange, perform: { _ in
                
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .customBackgroundColor))
        }
        .searchable(text: $viewModel.searchText, prompt: "Enter book name...")
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .foregroundStyle(Color(uiColor: .customAccentColor))
    }
    
    // MARK: - Views
    private var searchList: some View {
        if viewModel.searchText.isEmpty {
            return AnyView(Spacer())
        } else {
            return AnyView(
                List {
                    ForEach(viewModel.booksArray, id: \.self) { result in
                        Text(result.title)
                            .foregroundStyle(Color(uiColor: .customAccentColor))
                            .listRowBackground(Color(uiColor: .customBackgroundColor))
                            .onTapGesture {
                                viewModel.selectedBook = result
                                viewModel.searchText = ""
                            }
                    }
                }
                .listStyle(.plain)
            )
        }
    }
    
    private var selectedBookInfo: some View {
        VStack(spacing: 16) {
            switch viewModel.selectedAnnouncementType {
            case .none:
                EmptyView()
            case .startedBook:
                Text(viewModel.headerTextForStart)
                    .foregroundStyle(Color(uiColor: .customAccentColor))
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
            case .finishedBook:
                Text(viewModel.headerTextForFinish)
                    .foregroundStyle(Color(uiColor: .customAccentColor))
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
            }
            
            Text("The book is written by \(viewModel.formattedAuthorNames)")
                .foregroundStyle(Color(uiColor: .customAccentColor))
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        }
    }
    
    private var spoilersToggle: some View {
        Toggle("Allow Spoilers", isOn: $viewModel.isSpoilersAllowed)
            .padding()
            .foregroundColor(Color(uiColor: .customAccentColor))
            .tint(Color(uiColor: .customAccentColor))
    }
    
    private var announcementPicker: some View {
        Picker("Announcement Type", selection: $viewModel.selectedAnnouncementType) {
            Text("Started a Book").tag(AnnouncementType.startedBook)
            Text("Finished a Book").tag(AnnouncementType.finishedBook)
        }
        .pickerStyle(SegmentedPickerStyle())
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = .customAccentColor
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.customBackgroundColor], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.customAccentColor], for: .normal)
        }
        .padding()
        .foregroundColor(Color(uiColor: .customAccentColor))
        .tint(Color(uiColor: .customAccentColor))
    }
    
    private var addPostButton: some View {
        Button {
            viewModel.addPost()
            dismiss()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 50)
                .overlay(content: {
                    Text("Add Post")
                        .foregroundStyle(Color(uiColor: .customBackgroundColor))
                })
        }
    }
}
