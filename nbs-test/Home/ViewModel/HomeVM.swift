//
//  HomeVM.swift
//  nbs-test
//
//  Created by Farras Doko on 25/02/21.
//

import UIKit

class HomeVM {
    var popArray: [PopularResults]
    var comingSoonArr: [PopularResults]
    
    var popPhotos: [UIImage] {
        didSet {
            delegate?.reloadTableView()
        }
    }
    var comingSoonPhotos: [UIImage] {
        didSet {
            delegate?.reloadTableView()
        }
    }
    
    var localData: [Favorite]
    var delegate: HomeDelegate?
    
    init() {
        self.popArray = []
        self.comingSoonArr = []
        
        self.popPhotos = []
        self.comingSoonPhotos = []
        
        self.localData = []
    }
    
    func getData() {
        self.localData = CDManager.shared.loadData()
    }
    
    func fetchPopular() {
        let apiManager = ApiManager()
        apiManager.fetchPopular(isComingSoon: false, completion: { [self] response in
            switch response {
            case .success(let res):
                guard let result = res.results else { return }
                popArray = result
                DispatchQueue.global().async {
                    fetchPopImg(result: result)
                }
            case .failure(_):
                delegate?.apiFail(.popular)
            }
        })
    }
    func fetchComingSoon() {
        let apiManager = ApiManager()
        apiManager.fetchPopular(isComingSoon: true, completion: { [self] response in
            switch response {
            case .success(let res):
                guard let result = res.results else {return}
                comingSoonArr = result
                DispatchQueue.global().async {
                    fetchCsImg(result: result)
                }
            case .failure(_):
                delegate?.apiFail(.comingSoon)
            }
        })
    }
    func fetchPopImg(result: [PopularResults]) {
        for item in result {
            fetchImage(item: item, completion: { [self] img in
                delegate?.fetchImageCompleted(.popular)
                popPhotos.append(img)
            })
        }
    }
    func fetchCsImg(result: [PopularResults]) {
        for item in result {
            fetchImage(item: item, completion: { [self] img in
                delegate?.fetchImageCompleted(.comingSoon)
                comingSoonPhotos.append(img)
            })
        }
    }
    
    /*
    func fetchImae(result: [PopularResults], completion: @escaping ()->()) {
//        var images = [UIImage]()
        for item in result {
            fetchImage(item: item, completion: { [self] img in
                popPhotos.append(img)
            })
            
            guard let poster = item.posterPath else { continue }
            guard let url = URL(string: imageUrl+poster) else {continue}
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        images.append(image)
                        self.viewModel.popPhotos.append(image)
                        DispatchQueue.main.async {
                            self.statusLb.isHidden = true
                        }
                    }
                }
            
        }
    }
    */
    
    func fetchImage(item: PopularResults, completion: @escaping (_ image: UIImage)->()) {
        let imageUrl = "https://image.tmdb.org/t/p/w500"
        guard let poster = item.posterPath else { return }
        guard let url = URL(string: imageUrl+poster) else { return }
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                completion(image)
            }
        }
    }
    
}
