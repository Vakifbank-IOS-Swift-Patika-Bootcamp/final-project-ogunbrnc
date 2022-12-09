//
//  BaseViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import UIKit

class BaseViewController: UIViewController {

    //MARK: UI Components
    var indicatorView: UIActivityIndicatorView = {
      let view = UIActivityIndicatorView(style: .medium)
      view.color = .label
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    //MARK: Configure UI Components
    func setupActivityIndicatorView() {
        view.addSubview(indicatorView)
        setupActivityIndicatorViewConstraints()
    }
        
    func setupActivityIndicatorViewConstraints() {
      NSLayoutConstraint.activate([
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
    }
    
    func showAlert(title: String, message:String, completion:  (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicatorView()
    }

}
