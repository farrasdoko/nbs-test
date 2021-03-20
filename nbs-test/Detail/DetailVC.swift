//
//  DetailVC.swift
//  nbs-test
//
//  Created by Farras Doko on 23/02/21.
//

import UIKit
import Combine

class DetailVC: UIViewController {
    
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var durationLb: UILabel!
    @IBOutlet weak var hdIcon: UIImageView!
    @IBOutlet weak var genresLb: UILabel!
    @IBOutlet weak var addToFav: UIButton!
    @IBOutlet weak var bodyLb: UITextView!
    
    var viewModel: DetailVM?
    var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.$btnTitle.sink { value in
            self.addToFav.setTitle(value.rawValue, for: .normal)
        }.store(in: &bag)
        
        viewModel?.moviePub
            .receive(on: DispatchQueue.main)
            .sink { movie in
                self.titleLb.text = movie.title
                self.genresLb.text = movie.genre
                self.bodyLb.text = movie.body == "" ? "No overview available." : movie.body
                self.bannerImg.image = movie.banner
            }.store(in: &bag)
    }
    
    @IBAction func addToFav(_ sender: UIButton) {
        viewModel?.addToFavorite()
    }
    
}
