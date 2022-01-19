//
//  MainViewController.swift
//  Giphy App
//
//  Created by meekam okeke on 1/17/22.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    var tableView                        = UITableView()
    var trendingResponse: [TrendingData] = []
    var searchResponse: [SearchData]     = []
    var getByIDResponse: [GetByID]       = []
    var isSearching                      = false
    var rating                           = "pg"
    
    struct Cells {
        static let gifDetailCell = "GifDetailCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchController()
        fetchData()
        
    }
    
    func configureSearchController() {
        let searchController                                  = UISearchController()
        searchController.searchResultsUpdater                 = self
        searchController.searchBar.placeholder                = "Search for GIF"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController                       = searchController
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewConstraints()
        setTableViewDelegate()
        tableView.rowHeight = 120
        tableView.register(GifDetailCell.self, forCellReuseIdentifier: Cells.gifDetailCell)
    }
    
    func setTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setTableViewDelegate() {
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    func fetchData() {
        NetworkManager.shared.fetchTrendingData(rating: rating) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let trendingResponse):
                self.trendingResponse = trendingResponse.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(.invalidData):
                print("Invalid data.")
            case .failure(.unableToComplete):
                print("Unable to complete.")
            case .failure(.invalidResponse):
                print("Invalid response.")
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchResponse.isEmpty {
            return searchResponse.count
        }
        return trendingResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.gifDetailCell) as! GifDetailCell
        if !searchResponse.isEmpty {
            cell.setCellForSearchData(search: searchResponse[indexPath.row])
        } else {
            cell.setCellForTrendingData(trending: trendingResponse[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSearching == true {
            let response = searchResponse[indexPath.row]
            let vc = DetailViewController(ID: response.id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text
        if !query!.isEmpty {
            isSearching = true
            NetworkManager.shared.fetchSearchData(query: query!) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case.success(let searchResponse):
                    self.searchResponse = searchResponse.data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(.invalidData):
                    print("Invalid data")
                case .failure(.unableToComplete):
                    print("Unable to complete")
                case .failure(.invalidResponse):
                    print("Invalid response")
                }
            }
        } else {
            searchResponse.removeAll()
            isSearching = false
            fetchData()
        }
    }
}
