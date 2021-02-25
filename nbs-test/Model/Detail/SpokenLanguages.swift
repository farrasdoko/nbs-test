//
//  SpokenLanguages.swift
//
//  Created by Farras Doko on 23/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct SpokenLanguages: Codable {
    
    // MARK: Properties
    public var englishName: String?
    public var name: String?
    public var iso6391: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case name = "name"
        case iso6391 = "iso_639_1"
    }
    
}
