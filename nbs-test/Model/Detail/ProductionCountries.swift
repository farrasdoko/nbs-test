//
//  ProductionCountries.swift
//
//  Created by Farras Doko on 23/02/21
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct ProductionCountries: Codable {

  // MARK: Properties
  public var name: String?
  public var iso31661: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case iso31661 = "iso_3166_1"
    }

}
