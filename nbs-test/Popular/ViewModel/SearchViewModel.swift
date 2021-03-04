//
//  SearchViewModel.swift
//  nbs-test
//
//  Created by Farras Doko on 25/02/21.
//

import UIKit
import Combine

class SearchVM {
    
    var services: [ImageService]
    var cancellables = Set<AnyCancellable>()
    
    @Published var imageUrls = [String]()
    @Published var query: String = ""
    
    var queryPublisher: AnyPublisher<String, Never> {
        return $query
            .filter{ $0.count >= 3}
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    init(services: [ImageService]) {
        self.services = services
        queryPublisher
            .flatMap { queryString in
                return Publishers.MergeMany( services.map{$0.search(queryString)} )
                    .collect()
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink{ self.imageUrls = $0.flatMap{$0} }
            .store(in: &cancellables)
    }
    
    /*
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
 */
}
