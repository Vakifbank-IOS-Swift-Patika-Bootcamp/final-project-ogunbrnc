//
//  GameListViewController.swift
//  RAWGVideoGames
//
//  Created by Ogün Birinci on 9.12.2022.
//

import UIKit

final class GameListViewController: BaseViewController {
    
    private let searchController = UISearchController()
    
    private var currentSorting: String?
    private var selectedSortingRow: Int = 0
    private var sortingOptions: [String] = []
    private var toolBar = UIToolbar()
    private var sortingPickerView  = UIPickerView()
    
    @IBOutlet private weak var gameListTableView: UITableView! {
        didSet {
            gameListTableView.register(GameListTableViewCell.self, forCellReuseIdentifier: GameListTableViewCell.identifier)
            gameListTableView.delegate = self
            gameListTableView.dataSource = self
            gameListTableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    
    private var viewModel: GameListViewModelProtocol = GameListViewModel()
    
    private func configureSearchController(){
       navigationItem.searchController = searchController
       searchController.searchResultsUpdater = self
       searchController.searchBar.delegate = self
           
   }
    private func configurePickerviews(){
        sortingOptions = viewModel.getSortingOptions()
        
        sortingPickerView = UIPickerView()
        sortingPickerView.delegate = self
        sortingPickerView.dataSource = self
        sortingPickerView.backgroundColor = UIColor.label
        sortingPickerView.setValue(UIColor.systemBackground, forKey: "textColor")
        sortingPickerView.autoresizingMask = .flexibleWidth
        sortingPickerView.contentMode = .center
        sortingPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(sortingPickerView)
    }
    
    private func configureToolbar() {
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .black
        toolBar.items = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
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
        
        configurePickerviews()
        configureToolbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        indicatorView.startAnimating()
        viewModel.fetchGames()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Order by", style: .plain, target: self, action: #selector(addTapped))

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
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameDetailViewController") as? GameDetailViewController else { return }
            detailVC.gameId = viewModel.getGameId(at: indexPath.row)
            navigationController?.pushViewController(detailVC, animated: true)
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
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

