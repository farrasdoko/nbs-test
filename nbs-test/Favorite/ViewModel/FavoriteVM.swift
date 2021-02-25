//
//  FavoriteVM.swift
//  nbs-test
//
//  Created by Farras Doko on 25/02/21.
//

import Foundation

struct FavoriteVM {
    var favorites: Favorite
    
    init(_ favorite: Favorite) {
        self.favorites = favorite
    }
}
