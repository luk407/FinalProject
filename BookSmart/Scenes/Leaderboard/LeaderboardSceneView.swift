
import SwiftUI

final class LeaderboardSceneView: UIViewController {
    // MARK: - Properties
    private let mainStackView = UIStackView()
    
    private let podiumStackView = UIStackView()
    
    private lazy var firstPlaceStackView = LeaderboardPodiumItemStackView(place: 1,
                                                                          userImage: UIImage(systemName: "person.fill")!,
                                                                          imageSize: 90,
                                                                          username: "",
                                                                          booksReadCount: 0,
                                                                          shadowColor: .customGoldColor)
    
    
    private lazy var secondPlaceStackView = LeaderboardPodiumItemStackView(place: 2,
                                                                           userImage: UIImage(systemName: "person.fill")!,
                                                                           imageSize: 70,
                                                                           username: "",
                                                                           booksReadCount: 0,
                                                                           shadowColor: .customSilverColor)
    
    
    private lazy var thirdPlaceStackView = LeaderboardPodiumItemStackView(place: 3,
                                                                          userImage: UIImage(systemName: "person.fill")!,
                                                                          imageSize: 70,
                                                                          username: "",
                                                                          booksReadCount: 0,
                                                                          shadowColor: .clear)
    
    private let leaderboardTableView = UITableView(frame: .zero, style: .grouped)
    
    var leaderboardSceneViewModel: LeaderboardSceneViewModel
    
    // MARK: - Init
    init(leaderboardSceneViewModel: LeaderboardSceneViewModel) {
        self.leaderboardSceneViewModel = leaderboardSceneViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardSceneViewModel.delegate = self
        view.backgroundColor = .customBackgroundColor
        setupSubViews()
        setupConstraints()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        leaderboardSceneViewModel.refetchInfo() {
            DispatchQueue.main.async {
                self.leaderboardTableView.reloadData()
                print("finished fetching")
            }
        }
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    private func setupSubViews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(podiumStackView)
        podiumStackView.addArrangedSubview(secondPlaceStackView)
        podiumStackView.addArrangedSubview(firstPlaceStackView)
        podiumStackView.addArrangedSubview(thirdPlaceStackView)
        mainStackView.addArrangedSubview(leaderboardTableView)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupPodiumStackViewConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupPodiumStackViewUI()
        setupLeaderBoardTableViewUI()
    }
    
    // MARK: - Constraints
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupPodiumStackViewConstraints() {
        NSLayoutConstraint.activate([
            podiumStackView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    // MARK: - UI
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
    }
    
    private func setupPodiumStackViewUI() {
        podiumStackView.axis = .horizontal
        podiumStackView.spacing = 16
        podiumStackView.distribution = .fillEqually
        podiumStackView.alignment = .lastBaseline
    }
    
    private func setupLeaderBoardTableViewUI() {
        leaderboardTableView.translatesAutoresizingMaskIntoConstraints = false
        leaderboardTableView.backgroundColor = .clear
        leaderboardTableView.backgroundView = .none
        leaderboardTableView.separatorColor = .clear
        leaderboardTableView.dataSource = self
        leaderboardTableView.delegate = self
        leaderboardTableView.rowHeight = UITableView.automaticDimension
        leaderboardTableView.estimatedRowHeight = 50
        leaderboardTableView.register(LeaderboardTableViewCell.self, forCellReuseIdentifier: "userCell")
    }
    
    // MARK: - Methods
    @objc private func podiumStackViewItemTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tappedView = gestureRecognizer.view else { return }
        
        var index: Int
        
        if tappedView == firstPlaceStackView {
            index = 0
        } else if tappedView == secondPlaceStackView {
            index = 1
        } else if tappedView == thirdPlaceStackView {
            index = 2
        } else {
            return
        }
        
        podiumStackViewItemTapped(index: index, tappedView: tappedView as! UIStackView)
    }
    
    private func podiumStackViewItemTapped(index: Int, tappedView: UIStackView) {
        MethodsManager.shared.fadeAnimation(elements: tappedView) {
            self.navigateToProfileScene(index: index)
        }
    }
    
    private func navigateToProfileScene(index: Int) {
        let profileSceneView = UIHostingController(rootView: ProfileSceneView(
            profileSceneViewModel: ProfileSceneViewModel(
                profileOwnerInfoID: leaderboardSceneViewModel.fetchedUsersInfo[index].id,
                userInfo: leaderboardSceneViewModel.userInfo)).background(Color(uiColor: .customBackgroundColor)))
        navigationController?.pushViewController(profileSceneView, animated: true)
    }
}

// MARK: - Extensions
extension LeaderboardSceneView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(leaderboardSceneViewModel.fetchedUsersInfo.count - 3, 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row + 2 < leaderboardSceneViewModel.fetchedUsersInfo.count else {
            let emptyCell = UITableViewCell()
            emptyCell.backgroundColor = .customBackgroundColor
            return emptyCell
        }
        
        let userInfo = leaderboardSceneViewModel.fetchedUsersInfo[indexPath.row + 3]
        let cell = leaderboardTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! LeaderboardTableViewCell
        let userImage = leaderboardSceneViewModel.getImage(userID: userInfo.id) ?? UIImage(systemName: "person.fill")!
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.configureCell(userInfo: userInfo,
                           place: indexPath.row + 4,
                           userImage: userImage)
        print("got the image")
        return cell
    }
}

extension LeaderboardSceneView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        MethodsManager.shared.fadeAnimation(elements: cell) {
            self.navigateToProfileScene(index: indexPath.row + 3)
        }
    }
}

extension LeaderboardSceneView: LeaderboardSceneViewModelDelegate {
    func updatePodiumUI() {
        guard let firstUser = leaderboardSceneViewModel.fetchedUsersInfo.first else {
            return
        }
        
        let firstGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(podiumStackViewItemTapped(_:)))
        let secondGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(podiumStackViewItemTapped(_:)))
        let thirdGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(podiumStackViewItemTapped(_:)))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            firstPlaceStackView.setupUI(
                place: 1,
                userImage: leaderboardSceneViewModel.getImage(userID: firstUser.id) ?? UIImage(systemName: "person.fill")!,
                imageSize: 90,
                username: firstUser.userName,
                booksReadCount: firstUser.booksFinished.count,
                shadowColor: .customGoldColor
            )
            firstPlaceStackView.addGestureRecognizer(firstGestureRecognizer)
            firstPlaceStackView.isUserInteractionEnabled = true
            
            if leaderboardSceneViewModel.fetchedUsersInfo.count > 1 {
                let secondUser = leaderboardSceneViewModel.fetchedUsersInfo[1]
                secondPlaceStackView.setupUI(
                    place: 2,
                    userImage: leaderboardSceneViewModel.getImage(userID: secondUser.id) ?? UIImage(systemName: "person.fill")!,
                    imageSize: 70,
                    username: secondUser.userName,
                    booksReadCount: secondUser.booksFinished.count,
                    shadowColor: .customSilverColor
                )
                secondPlaceStackView.addGestureRecognizer(secondGestureRecognizer)
                secondPlaceStackView.isUserInteractionEnabled = true
            }
            
            if leaderboardSceneViewModel.fetchedUsersInfo.count > 2 {
                let thirdUser = leaderboardSceneViewModel.fetchedUsersInfo[2]
                thirdPlaceStackView.setupUI(
                    place: 3,
                    userImage: leaderboardSceneViewModel.getImage(userID: thirdUser.id) ?? UIImage(systemName: "person.fill")!,
                    imageSize: 70,
                    username: thirdUser.userName,
                    booksReadCount: thirdUser.booksFinished.count,
                    shadowColor: .customBronzeColor
                )
                thirdPlaceStackView.addGestureRecognizer(thirdGestureRecognizer)
                thirdPlaceStackView.isUserInteractionEnabled = true
            }
        }
    }
    
    func updateUserImage(userIndex: Int, userImage: UIImage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            switch userIndex {
            case 0:
                firstPlaceStackView.updateUserImage(image: userImage)
            case 1:
                secondPlaceStackView.updateUserImage(image: userImage)
            case 2:
                thirdPlaceStackView.updateUserImage(image: userImage)
            default:
                break
            }
        }
    }
    
    func updateTableViewRows(indexPaths: [IndexPath]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.leaderboardTableView.reloadRows(at: indexPaths, with: .fade)
        }
    }
}
