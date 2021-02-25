//
//  ComingSoonCell.swift
//  nbs-test
//
//  Created by Farras Doko on 23/02/21.
//

import UIKit

class ComingSoonCell: UICollectionViewCell {

    @IBOutlet weak var poster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ image: UIImage) {
        print("configure the poster image: \(image)")
        poster.image = image
    }

}
