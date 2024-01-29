//
//  LeaderboardSceneView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import UIKit

final class LeaderboardSceneView: UIViewController {
    
    // MARK: - Properties
    
    private let mainStackView = UIStackView()
    
    private let podiumStackView = UIStackView()
    
    private lazy var firstPlaceStackView: LeaderboardPodiumItemStackView = {
        let stackView = LeaderboardPodiumItemStackView(
            place: 1,
            userImage: UIImage(systemName: "person.fill")!, 
            imageSize: 90,
            username: leaderboardSceneViewModel.fetchedUsersInfo[0].userName,
            booksReadCount: leaderboardSceneViewModel.fetchedUsersInfo[0].booksFinished.count,
            shadowColor: .customGoldColor
        )
        return stackView
    }()

    private lazy var secondPlaceStackView: LeaderboardPodiumItemStackView = {
        let stackView = LeaderboardPodiumItemStackView(
            place: 2,
            userImage: UIImage(systemName: "person.fill")!, 
            imageSize: 70,
            username: leaderboardSceneViewModel.fetchedUsersInfo[1].userName,
            booksReadCount: leaderboardSceneViewModel.fetchedUsersInfo[1].booksFinished.count,
            shadowColor: .customSilverColor
        )
        return stackView
    }()
    
    private lazy var thirdPlaceStackView: LeaderboardPodiumItemStackView = {
        let stackView = LeaderboardPodiumItemStackView(
            place: 3,
            userImage: UIImage(systemName: "person.fill")!,
            imageSize: 70,
            username: leaderboardSceneViewModel.fetchedUsersInfo[2].userName,
            booksReadCount: leaderboardSceneViewModel.fetchedUsersInfo[2].booksFinished.count,
            shadowColor: .customBronzeColor
        )
        return stackView
    }()

    private let leaderboardTableView = UITableView()
    
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
//        setupFirstPlaceStackViewUI()
//        setupSecondPlaceStackViewUI()
//        setupThirdPlaceStackViewUI()
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
    
//    private func setupFirstPlaceStackViewUI() {
//        firstPlaceStackView = LeaderboardPodiumItemStackView(
//            place: 1, 
//            userImage: UIImage(systemName: "person.fill")!,
//            username: leaderboardSceneViewModel.fetchedUsersInfo[0].userName,
//            booksReadCount: leaderboardSceneViewModel.fetchedUsersInfo[0].booksFinished.count,
//            shadowColor: .customGoldColor)
//        
//        firstPlaceStackView.setUserImageUpdateHandler { [weak self] image in
//            guard let self = self else { return }
//            self.leaderboardSceneViewModel.delegate?.updateUserImage(userIndex: 0, userImage: image!)
//        }
//        
//        leaderboardSceneViewModel.retrieveImage(userIndex: 0)
//    }
//    
//    private func setupSecondPlaceStackViewUI() {
//        secondPlaceStackView = LeaderboardPodiumItemStackView(
//            place: 2,
//            userImage: UIImage(systemName: "person.fill")!,
//            username: leaderboardSceneViewModel.fetchedUsersInfo[1].userName,
//            booksReadCount: leaderboardSceneViewModel.fetchedUsersInfo[1].booksFinished.count,
//            shadowColor: .customSilverColor)
//        
//        secondPlaceStackView.setUserImageUpdateHandler { [weak self] image in
//            guard let self = self else { return }
//            self.leaderboardSceneViewModel.delegate?.updateUserImage(userIndex: 1, userImage: image!)
//        }
//        leaderboardSceneViewModel.retrieveImage(userIndex: 1)
//    }
//    
//    private func setupThirdPlaceStackViewUI() {
//        thirdPlaceStackView = LeaderboardPodiumItemStackView(
//            place: 3,
//            userImage: UIImage(systemName: "person.fill")!,
//            username: leaderboardSceneViewModel.fetchedUsersInfo[2].userName,
//            booksReadCount: leaderboardSceneViewModel.fetchedUsersInfo[2].booksFinished.count,
//            shadowColor: .customBronzeColor)
//        
//        thirdPlaceStackView.setUserImageUpdateHandler { [weak self] image in
//            guard let self = self else { return }
//            self.leaderboardSceneViewModel.delegate?.updateUserImage(userIndex: 2, userImage: image!)
//        }
//        leaderboardSceneViewModel.retrieveImage(userIndex: 2)
//    }
//    
    private func setupLeaderBoardTableViewUI() {
        leaderboardTableView.dataSource = self
        leaderboardTableView.delegate = self
        leaderboardTableView.rowHeight = UITableView.automaticDimension
        leaderboardTableView.estimatedRowHeight = 50
        leaderboardTableView.register(LeaderboardTableViewCell.self, forCellReuseIdentifier: "userCell")
    }
}

// MARK: - Extensions

extension LeaderboardSceneView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leaderboardSceneViewModel.fetchedUsersInfo.count - 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = leaderboardSceneViewModel.fetchedUsersInfo[indexPath.row + 2]
        if let cell = leaderboardTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? LeaderboardTableViewCell {
            
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension LeaderboardSceneView: UITableViewDelegate {
    
}

extension LeaderboardSceneView: LeaderboardSceneViewModelDelegate {
    
    func updateUserImage(userIndex: Int, userImage: UIImage) {
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
