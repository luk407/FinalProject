
import SwiftUI
import Combine
import GenericNetworkLayer
 
final class AnnouncementPostViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var searchTextCancellable: AnyCancellable?
    private var disposeBag = Set<AnyCancellable>()

    @Published var searchText: String = ""
    @Published var isSpoilersAllowed: Bool = false
    @Published var selectedAnnouncementType: AnnouncementType = .startedBook
    @Published var selectedBook: Book? = nil
    
    @Published var userInfo: UserInfo
    
    @Published var booksArray: [Book] = [] {
        didSet {
            objectWillChange.send()
        }
    }
    
    var formattedAuthorNames: String {
        guard let selectedBook = selectedBook else { return "" }
        return selectedBook.authorName?.joined(separator: ", ") ?? ""
    }

    var headerTextForStart: String {
        "\(userInfo.displayName) has just started reading a book \"\(selectedBook?.title ?? "")\""
    }
    
    var headerTextForFinish: String {
        "\(userInfo.displayName) has just finished reading a book \"\(selectedBook?.title ?? "")\""
    }
    
    var bodyText: String {
        "The book is written by \(formattedAuthorNames)"
    }
    
    // MARK: - Init
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        setupDebouncedTextChanges()
    }
    
    // MARK: - Methods
    
    private func setupDebouncedTextChanges() {
        searchTextCancellable = $searchText
            .debounce(for: 1.0, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                print("Search Text:", searchText)
                if searchText.count > 3 {
                    self?.fetchBooksData(with: searchText)
                }
            }
    }

    func addPost() {
        if selectedAnnouncementType == .finishedBook {
            let newPost = PostInfo(
                id: UUID(),
                authorID: userInfo.id,
                type: .announcement,
                header: headerTextForFinish,
                body: bodyText,
                postingTime: Date(),
                likedBy: [],
                comments: [],
                spoilersAllowed: isSpoilersAllowed,
                announcementType: selectedAnnouncementType
            )
            
            addPostToFirebase(post: newPost)
            
            updateUserDataOnFirebase(postID: newPost.id)
        } else {
            let newPost = PostInfo(
                id: UUID(),
                authorID: userInfo.id,
                type: .announcement,
                header: headerTextForStart,
                body: bodyText,
                postingTime: Date(),
                likedBy: [],
                comments: [],
                spoilersAllowed: isSpoilersAllowed,
                announcementType: selectedAnnouncementType
            )
            
            addPostToFirebase(post: newPost)
            
            updateUserDataOnFirebase(postID: newPost.id)
        }
    }
    
    private func addPostToFirebase(post: PostInfo) {
        FirebaseManager.shared.addPostToFirebase(post: post)
    }
    
    private func updateUserDataOnFirebase(postID: UUID) {
        
        guard let selectedBook else { return }
        
        FirebaseManager.shared.updateUserPostsAndFinishedBooksOnFirebase(userInfo: userInfo,
                                                        postID: postID,
                                                        selectedAnnouncementType: selectedAnnouncementType,
                                                        selectedBook: selectedBook)
    }

    func fetchBooksData(with titleString: String) {
        guard let url = URL(string: "https://openlibrary.org/search.json?title=\(titleString)") else { return }
        
        NetworkManager().request(with: url) { [ weak self ] (result: Result<BooksData, Error>) in
            switch result {
            case .success(let books):
                DispatchQueue.main.async {
                    self?.booksArray = books.docs
                    print(books.docs)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
