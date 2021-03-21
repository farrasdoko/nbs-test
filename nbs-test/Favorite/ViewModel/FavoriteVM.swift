//
//  FavoriteVM.swift
//  nbs-test
//
//  Created by Farras Doko on 25/02/21.
//

import UIKit
import Combine

class FavoriteVM {
    @Published var favorites: [Favorite]
    var manager: CDManager
    let pub = PassthroughSubject<UIViewController, Never>()
    
    init() {
        manager = CDManager()
        favorites = manager.loadData()
    }
    
    func refreshData() {
        favorites = manager.loadData()
    }
    func selectedRow(_ row: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        let movie = favorites[row]
        detailVC.viewModel = DetailVM(movie)
        pub.send(detailVC)
    }
    func deleteMovie(_ index: Int) {
        let id = favorites[index].objectID
        manager.deleteData(by: id)
        refreshData()
    }
}
