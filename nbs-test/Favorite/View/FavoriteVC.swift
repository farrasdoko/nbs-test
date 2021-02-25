//
//  FavoriteVC.swift
//  nbs-test
//
//  Created by Farras Doko on 22/02/21.
//

import UIKit

class FavoriteVC: UIViewController {
    
    @IBOutlet weak var favoriteTbl: UITableView!
    @IBOutlet weak var statusLb: UILabel!
    lazy var searchController = UISearchController()
    
    var viewModel = [FavoriteVM]() {
        didSet {
            DispatchQueue.main.async {
                self.favoriteTbl.reloadData()
            }
        }
    }
    var holderArr = [FavoriteVM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        
        favoriteTbl.delegate = self
        favoriteTbl.dataSource = self
        statusLb.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchBar.resignFirstResponder()
        getData()
    }
    
    func getData() {
        let favData = CDManager.shared.loadData()
        let favorites = favData.map{ FavoriteVM($0) }
        
        holderArr = favorites
        viewModel = favorites
        statusLb.isHidden = viewModel.count != 0
    }
    
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favoriteTbl.dequeueReusableCell(withIdentifier: FavoriteHelper.favoriteCellID, for: indexPath) as? FavoriteCell else {return UITableViewCell()}
        
        let item = viewModel[indexPath.row].favorites
        cell.configure(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        let movie = viewModel[indexPath.row].favorites
        
        let detail = CDDetail(movie)
        print("favorite/detail = \(detail)")
        detailVC.viewModel = DetailVM(detail)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            let id = self.viewModel[indexPath.row].favorites.objectID
            CDManager.shared.deleteData(by: id)
            self.getData()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
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
}
