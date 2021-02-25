//
//  ProductionCompanies.swift
//
//  Created by Farras Doko on 23/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct ProductionCompanies: Codable {
    
    // MARK: Properties
    public var originCountry: String?
    public var name: String?
    public var id: Int?
    public var logoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case originCountry = "origin_country"
        case name = "name"
        case id = "id"
        case logoPath = "logo_path"
    }
}
