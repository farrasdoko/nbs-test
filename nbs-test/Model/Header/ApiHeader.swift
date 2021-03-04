//
//  ApiHeader.swift
//  nbs-test
//
//  Created by Farras Doko on 23/02/21.
//

import Foundation

enum ApiHeader: String {
    case dailyTrend = "/3/trending/all/day"
    case popular = "/3/discover/movie"
    case detail = "/3/movie"
    case search = "/3/search/movie"
}
