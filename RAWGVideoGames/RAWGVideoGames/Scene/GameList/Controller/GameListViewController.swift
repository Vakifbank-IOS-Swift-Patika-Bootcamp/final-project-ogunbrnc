//
//  GameListViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import UIKit

final class GameListViewController: BaseViewController {
    
    private let searchController = UISearchController()
    private var sortingPickerView  = UIPickerView()
    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        button.tintColor = .label
        return button
    }()
    
    private var currentSorting: String?
    private var selectedSortingRow: Int = 0
    private var sortingOptions: [String] = []
    private var toolBar = UIToolbar()
   
    
    
    
    @IBOutlet private weak var gameListTableView: UITableView! {
        didSet {
            gameListTableView.register(GameListTableViewCell.self, forCellReuseIdentifier: GameListTableViewCell.identifier)
            gameListTableView.delegate = self
            gameListTableView.dataSource = self
            gameListTableView.estimatedRowHeight = 150
        }
    }
    
    private var viewModel: GameListViewModelProtocol = GameListViewModel()
    
    private func configureSearchController(){
       navigationItem.searchController = searchController
       searchController.searchResultsUpdater = self
       searchController.searchBar.delegate = self
           
   }
    private func configurePickerview(){
        sortingOptions = viewModel.getSortingOptions()
        
        sortingPickerView = UIPickerView()
        sortingPickerView.delegate = self
        sortingPickerView.dataSource = self
        
        sortingPickerView.backgroundColor = .systemBackground
        sortingPickerView.setValue(UIColor.label, forKey: "textColor")
        sortingPickerView.autoresizingMask = .flexibleWidth
        sortingPickerView.contentMode = .center
        sortingPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(sortingPickerView)
    }
    
    private func configureToolbar() {
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .label
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(onDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .done, target: self, action: #selector(onCancelButtonTapped))
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        self.view.addSubview(toolBar)
    }
    
    @objc func onCancelButtonTapped() {
        toolBar.removeFromSuperview()
        sortingPickerView.removeFromSuperview()
    }
    
    @objc func onDoneButtonTapped() {
        let selectedSorting = sortingOptions[selectedSortingRow]
        if selectedSorting != currentSorting {
            currentSorting = selectedSorting
            indicatorView.startAnimating()
            viewModel.fetchGamesSorted(by: selectedSorting)
        }

        toolBar.removeFromSuperview()
        sortingPickerView.removeFromSuperview()
    }
    
    @objc func addTapped() {
        
        configurePickerview()
        configureToolbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        indicatorView.startAnimating()
        viewModel.fetchGames()
        
        
        sortButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)

        configureSearchController()
        

    }
}

extension GameListViewController: GameListViewModelDelegate {
    func gamesLoaded() {
        gameListTableView.reloadData()
        indicatorView.stopAnimating()
    }
}

extension GameListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameListTableViewCell",for: indexPath) as? GameListTableViewCell, let model = viewModel.getGame(at: indexPath.row) else { return UITableViewCell() }
        cell.configureCell(game: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameDetailViewController") as? GameDetailViewController else { return }
        detailVC.gameId = viewModel.getGameId(at: indexPath.row)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getGameCount() - 1 && !viewModel.isSearching() {
            viewModel.fetchMoreGames()
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension GameListViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if !(text.isEmpty) {
            viewModel.searchGame(with: text)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        guard let text = searchBar.text else {
            return
        }
        if !(text.isEmpty) {
            viewModel.searchGame(with: text)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        viewModel.searchGameCancel()
    }
}

extension GameListViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortingOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingOptions[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        selectedSortingRow = row
    }
    
}

