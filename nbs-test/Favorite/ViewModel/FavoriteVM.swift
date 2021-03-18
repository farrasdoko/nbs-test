//
//  FavoriteVM.swift
//  nbs-test
//
//  Created by Farras Doko on 25/02/21.
//

import UIKit
import Combine
/*
struct FavoriteVM {
    var favorites: Favorite
    
    init(_ favorite: Favorite) {
        self.favorites = favorite
    }
}
*/
class FavoriteVM {
    var favorites: [Favorite]
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
        print("detailVC = \(detailVC)")
        pub.send(detailVC)
    }
}
