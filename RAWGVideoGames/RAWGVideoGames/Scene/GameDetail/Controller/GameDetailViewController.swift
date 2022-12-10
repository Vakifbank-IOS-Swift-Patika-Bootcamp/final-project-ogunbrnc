//
//  GameDetailViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import UIKit

class GameDetailViewController: UIViewController {
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gamePlatformLabel: UILabel!
    @IBOutlet weak var gameGenresLabel: UILabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    @IBOutlet weak var gameTagsLabel: UILabel!
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    
    private let button : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(GameDetailViewController.self, action: #selector(fbButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        return button
    }()
    
    var gameId: Int?
    private var viewModel: GameDetailViewModelProtocol = GameDetailViewModel()
    
    
    @objc func fbButtonPressed() {

        print("Share to fb")
    }
    
    
    
    private func configureFavoriteButton() {
        let iconName = viewModel.isItFavoriteGame() ? "star.fill" : "star"
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.addTarget(self, action: #selector(fbButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = gameId else { return }
        viewModel.delegate = self
        viewModel.fetchGameDetail(id: id)
        
        
        
    }
    
    
    
}
extension GameDetailViewController: GameDetailViewModelDelegate {
    func gameLoaded() {
        gameNameLabel.text = viewModel.getGameName()
        gamePlatformLabel.text = viewModel.getGamePlatform()
        gameGenresLabel.text = viewModel.getGameGenre()
        gameDateLabel.text = viewModel.getGameReleaseDate()
        gameTagsLabel.text = viewModel.getGameTag()
        gameDescriptionLabel.text = viewModel.getGameDescription()
        guard let url = viewModel.getGameImageURL() else { return }
        gameImageView.sd_setImage(with: url,placeholderImage: UIImage(systemName: "photo"),options: .continueInBackground)
        
        configureFavoriteButton()


    }
}

