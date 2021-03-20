//
//  FavoriteCell.swift
//  nbs-test
//
//  Created by Farras Doko on 23/02/21.
//

import UIKit
import CoreData

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var yearLb: UILabel!
    @IBOutlet weak var genresLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ favorite: Favorite) {
        if let data = favorite.image {
            posterImg.image = UIImage(data: data)
        }
        titleLb.text = favorite.title
        yearLb.text = favorite.year
        genresLb.text = favorite.genre
    }

}
