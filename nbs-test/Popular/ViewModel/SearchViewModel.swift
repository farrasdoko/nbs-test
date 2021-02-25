//
//  SearchViewModel.swift
//  nbs-test
//
//  Created by Farras Doko on 25/02/21.
//

import UIKit

struct SearchVM {
    var changed = false
    var photos: [UIImage]
    var photosHold: [UIImage]
    
    var holdArr: [PopularResults]
    var popArr: [PopularResults]
    
    var localData: [Favorite]
    
    init(_ results: [PopularResults]) {
        self.holdArr = results
        self.popArr = results
        
        self.photos = []
        self.photosHold = []
        
        self.localData = CDManager.shared.loadData()
    }
    
    mutating func addPhoto(_ photo: UIImage) {
        self.photos.append(photo)
        self.photosHold.append(photo)
    }
    
    mutating func getData() {
        self.localData = CDManager.shared.loadData()
    }
}
