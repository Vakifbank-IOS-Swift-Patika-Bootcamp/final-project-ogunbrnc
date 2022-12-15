//
//  GameDetailViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import UIKit

class GameDetailViewController: BaseViewController {
    
    @IBOutlet weak var gameRatingSkipLabel: UILabel!
    @IBOutlet weak var gameRatingMehLabel: UILabel!
    @IBOutlet weak var gameRatingRecommendedLabel: UILabel!
    @IBOutlet weak var gameRatingExceptionalLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gamePlatformLabel: UILabel!
    @IBOutlet weak var gameGenresLabel: UILabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    @IBOutlet weak var gameTagsLabel: UILabel!
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    
    private var favoriteButton = UIButton(type: .custom)
    
    var gameId: Int?
    private var viewModel: GameDetailViewModelProtocol = GameDetailViewModel()
    
    
    @objc func addFavoriteTapped() {
        viewModel.addGameToFavoriteList {result in
            if result {
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
                favoriteButton.addTarget(self, action: #selector(removeFavoriteTapped), for: .touchUpInside)
            }
        }
    }
    
    @objc func removeFavoriteTapped() {
        viewModel.deleteGameFromFavoriteList {result in
            if result {
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
                favoriteButton.addTarget(self, action: #selector(addFavoriteTapped), for: .touchUpInside)
            }
        }
    }

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
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = gameId else { return }
        
        indicatorView.startAnimating()

        viewModel.delegate = self
        viewModel.fetchGameDetail(id: id)
    }
    
    
    
}
extension GameDetailViewController: GameDetailViewModelDelegate {
    func gameLoaded() {
        
        gameNameLabel.text = viewModel.getGameName()
        guard let url = viewModel.getGameImageURL() else { return }
        gameImageView.sd_setImage(with: url,placeholderImage: UIImage(systemName: "photo"),options: .continueInBackground)
        gameRatingExceptionalLabel.text = String(viewModel.getGameRatingExceptionalCount())
        gameRatingRecommendedLabel.text = String(viewModel.getGameRatingRecommendedCount())
        gameRatingMehLabel.text = String(viewModel.getGameRatingMehCount())
        gameRatingSkipLabel.text = String(viewModel.getGameRatingSkipCount())

        configureFavoriteButton()
        indicatorView.stopAnimating()


    }
}

