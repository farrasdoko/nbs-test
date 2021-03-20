//
//  DetailVM.swift
//  nbs-test
//
//  Created by Farras Doko on 25/02/21.
//

import UIKit
import Combine

class DetailVM {
    
    var movieID: String?
    var moviePub: Future<CDDetail, Never>!
    @Published var btnTitle = BtnTitle.add
    var movie: CDDetail?
    
    init(_ movie: CDDetail) {
        self.movie = movie
    }
    
    init(_ movie: Favorite) {
        addMovie(movie)
    }
    
    init(_ id: String) {
        self.movieID = id
        moviePub = Future { promise in
            DispatchQueue.global().async {
                self.fetchMovie { movie in
                    promise(.success(movie))
                }
            }
        }
    }
    
    func addMovie(_ movie: CDDetail) {
        self.movie = movie
    }
    
    func addMovie(_ favorite: Detail) {
        self.movie = CDDetail(favorite)
    }
    
    func addMovie(_ favorite: Favorite) {
        self.movie = CDDetail(favorite)
        btnTitle = .remove
        moviePub = Future { [self] promise in
            promise(.success(movie!))
        }
    }
    
    func addBanner(_ image: UIImage?) {
        self.movie?.addBanner(image: image)
    }
    
    func addPoster(_ image: UIImage?) {
        self.movie?.addPoster(image: image)
    }
    
    func fetchMovie(_ completion: @escaping (_ movie: CDDetail)->Void) {
        let apiManager = ApiManager()
        guard let id = movieID else { return }
        
        apiManager.fetchDetail(id) { [self] result in
            switch result {
            case .success(let detail):
                addMovie(detail)
                fetchImage(detail.posterPath) { img in addPoster(img) }
                fetchImage(detail.backdropPath) { img in addBanner(img) }
                guard movie != nil else { print("movie nil"); return }
                completion(movie!)
                break
            case .failure(_):
                print("fail")
                break
            }
        }
    }
    
    private func fetchImage(_ posterPath: String?, completion: @escaping (_ image:UIImage)->()) {
        let imageUrl = "https://image.tmdb.org/t/p/w500"
        guard let poster = posterPath, let url = URL(string: imageUrl+poster) else {return}
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                completion(image)
            }
        }
    }
    
    func addToFavorite() {
        switch btnTitle {
        case .add:
            guard movie != nil else { return }
            CDManager.shared.addData(movie: movie!)
            btnTitle = .remove
        case .remove:
            guard let id = movie?.movieID else {return}
            print("delete data \(id)")
            CDManager.shared.deleteData(by: id)
            btnTitle = .add
        }
    }
}
