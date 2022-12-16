//
//  IconLabelStackView.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 16.12.2022.
//

import UIKit

class IconLabelStackView: UIStackView {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let iconLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
       
        return stackView
    }()
    
    func configure(imageSystemName: String,labelValue: String){
        iconImageView.image = UIImage(systemName: imageSystemName)
        label.text = labelValue
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconLabelStackView)
        iconLabelStackView.addArrangedSubview(iconImageView)
        iconLabelStackView.addArrangedSubview(label)
        
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
