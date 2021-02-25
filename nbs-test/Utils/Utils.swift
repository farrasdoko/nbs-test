//
//  Utils.swift
//  nbs-test
//
//  Created by Farras Doko on 24/02/21.
//

import Foundation

class Utils {
    class func getGenres(_ genres: [Genres]?) -> String {
        if let genres = genres {
            var genreString = ""
            for (i, genre) in genres.enumerated() {
                genreString.append(genre.name ?? "")
                if i < (genres.count-1) {
                    genreString.append(" - ")
                }
            }
            return genreString
        }
        return ""
    }
}
