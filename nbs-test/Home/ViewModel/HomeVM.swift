//
//  HomeVM.swift
//  nbs-test
//
//  Created by Farras Doko on 25/02/21.
//

import UIKit

struct HomeVM {
    var popArray: [PopularResults]
    var comingSoonArr: [PopularResults]
    
    var popPhotos: [UIImage]
    var comingSoonPhotos: [UIImage]
    
    var localData: [Favorite]
    
    init() {
        self.popArray = []
        self.comingSoonArr = []
        
        self.popPhotos = []
        self.comingSoonPhotos = []
        
        self.localData = []
    }
    
    mutating func getData() {
        self.localData = CDManager.shared.loadData()
    }
    
}
