//
//  DetailVM.swift
//  nbs-test
//
//  Created by Farras Doko on 25/02/21.
//

import UIKit

struct DetailVM {
    var addedToFav = false
    var movie: CDDetail?
    var movieID: String?
    
    init(_ movie: CDDetail) {
        self.movie = movie
        self.addedToFav = true
    }
    
    init(_ movie: Favorite) {
        addMovie(movie)
        self.addedToFav = true
    }
    
    init(_ id: String) {
        self.movieID = id
        self.addedToFav = false
    }
    
    mutating func addMovie(_ movie: CDDetail) {
        self.movie = movie
    }
    
    mutating func addMovie(_ favorite: Detail) {
        self.movie = CDDetail(favorite)
    }
    
    mutating func addMovie(_ favorite: Favorite) {
        self.movie = CDDetail(favorite)
    }
    
    mutating func addBanner(_ image: UIImage?) {
        self.movie?.addBanner(image: image)
    }
    
    mutating func addPoster(_ image: UIImage?) {
        self.movie?.addPoster(image: image)
    }
    
}
