//
//  GameDetailViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    var gameId: Int?
    private var viewModel: GameDetailViewModelProtocol = GameDetailViewModel()

    
    // MARK: UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let gamePlatformLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Game platforms"
        return label
    }()
    
    private let gamePlatformContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let gameGenreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Game Genres"
        return label
    }()
    
    private let gameGenreContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let gameReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Release date"
        return label
    }()
    
    private let gameReleaseDateContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let gameTagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Tags"
        return label
    }()
    
    private let gameTagContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let gameDescriptionContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    // MARK: Configure UI Components
   private func configureConstraints() {
       
       let scrollViewConstraints = [
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
       ]
       let contentViewConstraints = [
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 200)
       ]
       
       let gameImageViewConstraints = [
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            gameImageView.widthAnchor.constraint(equalToConstant: 350),
            gameImageView.heightAnchor.constraint(equalToConstant: 150)
       ]
       let gameNameLabelConstraints = [
            gameNameLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor,constant: 20),
            gameNameLabel.centerXAnchor.constraint(equalTo: gameImageView.centerXAnchor)
        ]
       
       let gamePlatformLabelConstraints = [
            gamePlatformLabel.leadingAnchor.constraint(equalTo: gameImageView.leadingAnchor),
            gamePlatformLabel.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 10)
       ]
       
       let gamePlatformContentLabelConstraints = [
            gamePlatformContentLabel.leadingAnchor.constraint(equalTo: gamePlatformLabel.leadingAnchor),
            gamePlatformContentLabel.topAnchor.constraint(equalTo: gamePlatformLabel.bottomAnchor, constant: 10),
            gamePlatformContentLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -80)
            
       ]
       
       let gameGenreLabelConstraints = [
            gameGenreLabel.leadingAnchor.constraint(equalTo: gamePlatformLabel.trailingAnchor, constant: 20),
            gameGenreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            gameGenreLabel.topAnchor.constraint(equalTo: gamePlatformLabel.topAnchor)
        
       ]
       
       let gameGenreContentLabelConstraints = [
            gameGenreContentLabel.leadingAnchor.constraint(equalTo: gameGenreLabel.leadingAnchor),
            gameGenreContentLabel.trailingAnchor.constraint(equalTo: gameGenreLabel.trailingAnchor),
            gameGenreContentLabel.topAnchor.constraint(equalTo: gameGenreLabel.bottomAnchor, constant: 10),
            gameGenreContentLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -80)
        
       ]
       
       let gameReleaseDateLabelConstraints = [
            gameReleaseDateLabel.leadingAnchor.constraint(equalTo: gameImageView.leadingAnchor),
            gameReleaseDateLabel.topAnchor.constraint(equalTo: gamePlatformContentLabel.bottomAnchor, constant: 10)
       ]
       
       let gameReleaseDateContentLabelConstraints = [
            gameReleaseDateContentLabel.leadingAnchor.constraint(equalTo: gameImageView.leadingAnchor),
            gameReleaseDateContentLabel.topAnchor.constraint(equalTo: gameReleaseDateLabel.bottomAnchor, constant: 10),
            
       ]
   
       let gameTagsLabelConstraints = [
            gameTagLabel.leadingAnchor.constraint(equalTo: gameGenreLabel.leadingAnchor),
            gameTagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            gameTagLabel.topAnchor.constraint(equalTo: gameReleaseDateLabel.topAnchor)
        
       ]
       
       let gameTagsContentLabelConstraints = [
            gameTagContentLabel.leadingAnchor.constraint(equalTo: gameTagLabel.leadingAnchor),
            gameTagContentLabel.trailingAnchor.constraint(equalTo: gameTagLabel.trailingAnchor),
            gameTagContentLabel.topAnchor.constraint(equalTo: gameTagLabel.bottomAnchor, constant: 10)
        
       ]
       
       let gameDescriptionContentLabelConstraints = [
            gameDescriptionContentLabel.leadingAnchor.constraint(equalTo: gamePlatformLabel.leadingAnchor),
            gameDescriptionContentLabel.trailingAnchor.constraint(equalTo: gameGenreLabel.trailingAnchor),
            gameDescriptionContentLabel.topAnchor.constraint(equalTo: gameTagContentLabel.bottomAnchor, constant: 20)
        
       ]
       
       NSLayoutConstraint.activate(scrollViewConstraints)
       NSLayoutConstraint.activate(contentViewConstraints)
       NSLayoutConstraint.activate(gameImageViewConstraints)
       NSLayoutConstraint.activate(gameNameLabelConstraints)
       NSLayoutConstraint.activate(gamePlatformLabelConstraints)
       NSLayoutConstraint.activate(gamePlatformContentLabelConstraints)
       NSLayoutConstraint.activate(gameGenreLabelConstraints)
       NSLayoutConstraint.activate(gameGenreContentLabelConstraints)
       NSLayoutConstraint.activate(gameReleaseDateLabelConstraints)
       NSLayoutConstraint.activate(gameReleaseDateContentLabelConstraints)
       NSLayoutConstraint.activate(gameTagsLabelConstraints)
       NSLayoutConstraint.activate(gameTagsContentLabelConstraints)
       NSLayoutConstraint.activate(gameDescriptionContentLabelConstraints)

     

   }
    
    private func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(gameImageView)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(gamePlatformLabel)
        contentView.addSubview(gamePlatformContentLabel)
        contentView.addSubview(gameGenreLabel)
        contentView.addSubview(gameGenreContentLabel)
        contentView.addSubview(gameReleaseDateLabel)
        contentView.addSubview(gameReleaseDateContentLabel)
        contentView.addSubview(gameTagLabel)
        contentView.addSubview(gameTagContentLabel)
        contentView.addSubview(gameDescriptionContentLabel)
       
            
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        configureConstraints()
        
        guard let id = gameId else { return }
        viewModel.delegate = self
        viewModel.fetchGameDetail(id: id)
    }
    
}
extension GameDetailViewController: GameDetailViewModelDelegate {
    func gameLoaded() {
        gameNameLabel.text = viewModel.getGameName()
        gamePlatformContentLabel.text = viewModel.getGamePlatform()
        gameGenreContentLabel.text = viewModel.getGameGenre()
        gameReleaseDateContentLabel.text = viewModel.getGameReleaseDate()
        gameTagContentLabel.text = viewModel.getGameTag()
        gameDescriptionContentLabel.text = viewModel.getGameDescription()
        guard let url = viewModel.getGameImageURL() else { return }
        gameImageView.sd_setImage(with: url,placeholderImage: UIImage(systemName: "photo"),options: .continueInBackground)

    }
}
