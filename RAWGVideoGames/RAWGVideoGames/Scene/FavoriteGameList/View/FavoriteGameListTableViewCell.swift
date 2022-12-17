//
//  FavoriteGameListTableViewCell.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 10.12.2022.
//

import UIKit

class FavoriteGameListTableViewCell: UITableViewCell {

    static var identifier = "FavoriteGameListTableViewCell"
    
    // MARK: UI Components
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
    
    // MARK: Configure UI Components
   private func configureConstraints() {
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
       
       
       NSLayoutConstraint.activate(gameImageViewConstraints)
       NSLayoutConstraint.activate(gameNameLabelConstraints)

   }
   
    
    private func configureSubviews() {
        addSubview(gameImageView)
        addSubview(gameNameLabel)
    }
    
    // If there is no image, the "photo" image will be used to provide a consistent structure
    func configureCell(game: FavoriteGame){
        gameNameLabel.text = game.name
        gameImageView.sd_setImage(with: URL(string: game.imageURL ?? ""),placeholderImage: UIImage(systemName: "photo"),options: .continueInBackground)
    }
    
    override func prepareForReuse() {
        gameImageView.image = nil

    }
    
    
    // MARK: Life Cycle Methods
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
     
       configureSubviews()
       configureConstraints()
           
   }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
