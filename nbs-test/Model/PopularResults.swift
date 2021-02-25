//
//  PopularResults.swift
//
//  Created by Farras Doko on 23/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation

struct PopularResults: Codable {
    
    // MARK: Properties
    public var posterPath: String?
    public var backdropPath: String?
    public var genreIds: [Int]?
    public var voteCount: Int?
    public var overview: String?
    public var originalTitle: String?
    public var popularity: Float?
    public var releaseDate: String?
    public var id: Int?
    public var video: Bool? = false
    public var originalLanguage: String?
    public var voteAverage: Float?
    public var title: String?
    public var adult: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case voteCount = "vote_count"
        case overview = "overview"
        case originalTitle = "original_title"
        case popularity = "popularity"
        case releaseDate = "release_date"
        case id = "id"
        case video = "video"
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
        case title = "title"
        case adult = "adult"
    }
}
