//
//  FavoriteVC.swift
//  nbs-test
//
//  Created by Farras Doko on 22/02/21.
//

import UIKit
import Combine

class FavoriteVC: UIViewController {
    
    @IBOutlet weak var favoriteTbl: UITableView!
    @IBOutlet weak var statusLb: UILabel!
    lazy var searchController = UISearchController()
    var bag = Set<AnyCancellable>()
    
    var viewModel: FavoriteVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchController()
        initTable()
        statusLb.isHidden = true
        viewModel = FavoriteVM()
        
        viewModel.pub.sink { vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &bag)
        viewModel.$favorites.sink { v in
            print("\(v.count) V counted:")
            self.favoriteTbl.reloadData()
        }.store(in: &bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchBar.resignFirstResponder()
        viewModel.refreshData()
        statusLb.isHidden = viewModel.favorites.count != 0
//        favoriteTbl.reloadData()
    }
    
    func initSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    func initTable() {
        favoriteTbl.delegate = self
        favoriteTbl.dataSource = self
    }
    
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("counted here: \(viewModel.favorites.count)")
        return viewModel.favorites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favoriteTbl.dequeueReusableCell(withIdentifier: FavoriteHelper.favoriteCellID, for: indexPath) as? FavoriteCell else {return UITableViewCell()}
        
        let item = viewModel.favorites[indexPath.row]
        cell.configure(item)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.selectedRow(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.viewModel.deleteMovie(indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    /*
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.removeAll()
        
        guard self.holderArr.count > 0 else { return }
        for index in 0 ... (self.holderArr.count-1) {
            guard let title = self.holderArr[index].favorites.title else {continue}
            guard let genres = self.holderArr[index].favorites.genre else {continue}
            let item = self.holderArr[index].favorites
            
            if title.contains(searchText) || genres.contains(searchText) {
                viewModel.append(FavoriteVM(item))
            }
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        resignFirstResponder()
    }
    */
}
