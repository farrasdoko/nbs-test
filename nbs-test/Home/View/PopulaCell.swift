//
//  PopulaCell.swift
//  nbs-test
//
//  Created by Farras Doko on 23/02/21.
//

import UIKit

class PopulaCell: UICollectionViewCell {

    @IBOutlet weak var posterImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ image: UIImage) {
        self.posterImg.image = image
        print("configure the populer image: \(image)")
    }

}
