//
//  UIImage+Extension.swift
//  nbs-test
//
//  Created by Farras Doko on 23/02/21.
//

import UIKit

extension UIImageView {
    func load(_ imgUrl: String, completion: @escaping ()->()?) {
        DispatchQueue.global().async { [weak self] in
            let imageUrl = "https://image.tmdb.org/t/p/w500"
            guard let url = URL(string: imageUrl+imgUrl) else {return}
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion()
                    }
                }
            }
        }
    }
}
