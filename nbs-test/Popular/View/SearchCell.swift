//
//  SearchCell.swift
//  nbs-test
//
//  Created by Farras Doko on 22/02/21.
//

import UIKit

class SearchCell: UICollectionViewCell {

    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var castLb: UILabel!
    @IBOutlet weak var genreLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, cast: String, genres: String) {
        titleLb.text = title
        castLb.text = cast
        genreLb.text = genres
    }
    
    func configure(_ result: PopularResults) {
        titleLb.text = result.title
        castLb.text = "NO CAST DATA."
        genreLb.text = "Action, Horror"
    }
    
    func setImage(_ image: UIImage) {
        posterImg.image = image
    }

}
