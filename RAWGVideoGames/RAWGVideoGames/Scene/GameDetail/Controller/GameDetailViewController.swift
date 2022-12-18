//
//  GameDetailViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import SDWebImage
import UIKit

final class GameDetailViewController: BaseViewController {
    // MARK: IBOutlets

    @IBOutlet var gameRatingAverageLabel: UILabel!
    @IBOutlet var gameRatingCountLabel: UILabel!
    @IBOutlet var gameTimeLabel: UILabel!
    @IBOutlet var gameRatingSkipLabel: UILabel!
    @IBOutlet var gameRatingMehLabel: UILabel!
    @IBOutlet var gameRatingRecommendedLabel: UILabel!
    @IBOutlet var gameRatingExceptionalLabel: UILabel!
    @IBOutlet var gameImageView: UIImageView!
    @IBOutlet var gameNameLabel: UILabel!
    @IBOutlet var gamePlatformLabel: UILabel!
    @IBOutlet var gameGenresLabel: UILabel!
    @IBOutlet var gameTagsLabel: UILabel!
    @IBOutlet var gameDescriptionLabel: UILabel!

    // MARK: Variable Declarations

    private var favoriteButton = UIButton(type: .custom)
    var gameId: Int?
    private var viewModel: GameDetailViewModelProtocol = GameDetailViewModel()

    // MARK: Selector Functions

    @objc func addFavoriteTapped() {
        viewModel.addGameToFavoriteList { result in
            if result {
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
                favoriteButton.addTarget(self, action: #selector(removeFavoriteTapped), for: .touchUpInside)
            }
        }
    }

    @objc func removeFavoriteTapped() {
        viewModel.deleteGameFromFavoriteList { result in
            if result {
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
                favoriteButton.addTarget(self, action: #selector(addFavoriteTapped), for: .touchUpInside)
            }
        }
    }

    @objc func favoriteGameDeleted() {
        configureFavoriteButton()
    }

    // MARK: Configure UI Components

    private func configureFavoriteButton() {
        if viewModel.isItFavoriteGame() {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favoriteButton.addTarget(self, action: #selector(removeFavoriteTapped), for: .touchUpInside)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            favoriteButton.addTarget(self, action: #selector(addFavoriteTapped), for: .touchUpInside)
        }

        favoriteButton.frame = CGRect(x: 0, y: 0, width: 64, height: 64)

        let barButton = UIBarButtonItem(customView: favoriteButton)
        navigationItem.rightBarButtonItem = barButton
    }

    // MARK: Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = gameId else { return }

        indicatorView.startAnimating()

        NotificationCenter.default.addObserver(self, selector: #selector(favoriteGameDeleted), name: NSNotification.Name(rawValue: "FavoriteGameDeletedInList"), object: nil)

        viewModel.delegate = self
        viewModel.fetchGameDetail(id: id)
    }
}

// MARK: GameDetailViewModelDelegate extension

extension GameDetailViewController: GameDetailViewModelDelegate {
    func gameLoadingError(error: Error) {
        showAlert(title: "Error occured".localized(), message: error.localizedDescription)
    }

    func gameLoaded() {
        gameNameLabel.text = viewModel.getGameName()
        guard let url = viewModel.getGameImageURL() else { return }
        gameImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"), options: .continueInBackground)
        gameRatingExceptionalLabel.text = String(viewModel.getGameRatingExceptionalCount())
        gameRatingRecommendedLabel.text = String(viewModel.getGameRatingRecommendedCount())
        gameRatingMehLabel.text = String(viewModel.getGameRatingMehCount())
        gameRatingSkipLabel.text = String(viewModel.getGameRatingSkipCount())
        gamePlatformLabel.text = viewModel.getGamePlatform()
        gameTagsLabel.text = viewModel.getGameTag()
        gameGenresLabel.text = viewModel.getGameGenre()
        gameDescriptionLabel.text = viewModel.getGameDescription()
        gameTimeLabel.text = String(viewModel.getGameTime())
        gameRatingCountLabel.text = String(viewModel.getGameRatingCount())
        gameRatingAverageLabel.text = String(viewModel.getGameRatingAverage())

        configureFavoriteButton()
        indicatorView.stopAnimating()
    }
}
