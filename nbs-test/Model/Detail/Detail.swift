//
//  Detail.swift
//
//  Created by Farras Doko on 23/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct Detail: Codable {

  // MARK: Properties
  public var budget: Int?
  public var backdropPath: String?
  public var revenue: Int?
  public var voteCount: Int?
  public var overview: String?
  public var video: Bool? = false
  public var imdbId: String?
  public var id: Int?
  public var title: String?
  public var homepage: String?
  public var productionCompanies: [ProductionCompanies]?
  public var belongsToCollection: BelongsToCollection?
  public var posterPath: String?
  public var adult: Bool? = false
  public var genres: [Genres]?
  public var spokenLanguages: [SpokenLanguages]?
  public var status: String?
  public var runtime: Int?
  public var originalTitle: String?
  public var releaseDate: String?
  public var originalLanguage: String?
  public var popularity: Float?
  public var tagline: String?
  public var productionCountries: [ProductionCountries]?

    enum CodingKeys: String, CodingKey {
        case budget = "budget"
        case backdropPath = "backdrop_path"
        case revenue = "revenue"
        case voteCount = "vote_count"
        case overview = "overview"
        case video = "video"
        case imdbId = "imdb_id"
        case id = "id"
        case title = "title"
        case homepage = "homepage"
        case productionCompanies = "production_companies"
        case belongsToCollection = "belongs_to_collection"
        case posterPath = "poster_path"
        case adult = "adult"
        case genres = "genres"
        case spokenLanguages = "spoken_languages"
        case status = "status"
        case runtime = "runtime"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case popularity = "popularity"
        case tagline = "tagline"
        case productionCountries = "production_countries"
    }

}
