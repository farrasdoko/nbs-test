//
//  CDDetail.swift
//  nbs-test
//
//  Created by Farras Doko on 24/02/21.
//

import UIKit

struct CDDetail {
    var title: String
    var genre: String
    var year: String
    var image: UIImage?
    var banner: UIImage?
    var body: String
    var movieID: String
    
    init(_ favorite: Detail) {
        self.title = favorite.title ?? ""
        self.genre = Utils.getGenres(favorite.genres)
        self.year = favorite.releaseDate ?? ""
        self.body = favorite.overview ?? ""
        self.movieID = String(favorite.id ?? 0)
    }
    
    init(_ favorite: Favorite) {
        self.title = favorite.title ?? ""
        self.genre = favorite.genre ?? ""
        self.year = favorite.year ?? ""
        self.body = favorite.body ?? ""
        self.movieID = favorite.movieID ?? ""
        if let data = favorite.image {
            self.image = UIImage(data: data)
        }
        if let data = favorite.banner {
            self.banner = UIImage(data: data)
        }
    }
    
    mutating func addBanner(image: UIImage?) {
        self.banner = image
    }
    mutating func addPoster(image: UIImage?) {
        self.image = image
    }
}
