//
//  DetailVC.swift
//  nbs-test
//
//  Created by Farras Doko on 23/02/21.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var durationLb: UILabel!
    @IBOutlet weak var hdIcon: UIImageView!
    @IBOutlet weak var genresLb: UILabel!
    @IBOutlet weak var addToFav: UIButton!
    @IBOutlet weak var bodyLb: UITextView!
    
    var viewModel: DetailVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBtnTitle()
        
        guard let isFavorite = viewModel?.addedToFav else {return }
        if !isFavorite {
            fetchMovie()
            return
        }
        
        showData()
    }
    
    @IBAction func addToFav(_ sender: UIButton) {
        guard let favoriteMovie = viewModel?.movie else { print("is nil"); return }
        guard let isFav = viewModel?.addedToFav else { return }
        
        if isFav {
            CDManager.shared.deleteData(by: favoriteMovie.movieID)
        } else {
            CDManager.shared.addData(movie: favoriteMovie)
        }
        
        viewModel?.addedToFav = !isFav
        setBtnTitle()
    }
    
    func fetchMovie() {
        let apiManager = ApiManager()
        guard let id = viewModel?.movieID else { return }
        
        apiManager.fetchDetail(id, completion: { result in
            switch result {
            case .success(let detail):
                print("suceess")
                DispatchQueue.main.async {
                    self.viewModel?.addMovie(detail)
                    if let poster = detail.posterPath {
                        self.bannerImg.load(poster) {
                            self.viewModel?.addPoster(self.bannerImg.image)
                        }
                    }
                    if let banner = detail.backdropPath {
                        let image = self.fetchImage(banner)
                        self.viewModel?.addBanner(image)
                    }
                    self.titleLb.text = detail.title
                    self.genresLb.text = Utils.getGenres(detail.genres)
                    self.bodyLb.text = detail.overview
                    if detail.overview == "" {
                        self.bodyLb.text = "no overview available."
                    }
                }
                break
            case .failure(_):
                print("fail")
                break
            }
        })
    }
    
    func setBtnTitle() {
        guard let isFav = viewModel?.addedToFav else { return }
        addToFav.setTitle(isFav ? "Remove From Favorite":"Add To Favorite", for: .normal)
    }
    
    func showData() {
        self.bannerImg.image = viewModel?.movie?.image
        self.titleLb.text = viewModel?.movie?.title
        self.genresLb.text = viewModel?.movie?.genre
        self.bodyLb.text = viewModel?.movie?.body
    }
    
    func fetchImage(_ imgID: String) -> UIImage? {
        let imageUrl = "https://image.tmdb.org/t/p/w500\(imgID)"
        guard let url = URL(string: imageUrl) else {return nil}
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
    
}
