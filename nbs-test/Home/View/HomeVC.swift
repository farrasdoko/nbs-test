//
//  HomeVC.swift
//  nbs-test
//
//  Created by Farras Doko on 22/02/21.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var popularTable: UICollectionView!
    @IBOutlet weak var comingSoonTable: UICollectionView!
    
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var statusCsLb: UILabel!
    
    @IBOutlet weak var banner1: UIImageView!
    @IBOutlet weak var banner2: UIImageView!
    @IBOutlet weak var banner3: UIImageView!
    
    var viewModel = HomeVM() {
        didSet {
            DispatchQueue.main.async {
                self.popularTable.reloadData()
                self.comingSoonTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popularTable.dataSource = self
        popularTable.delegate = self
        
        comingSoonTable.dataSource = self
        comingSoonTable.delegate = self
        
        let logo = UIImage(named: "movie_logo")
        self.navigationItem.titleView = UIImageView(image: logo)
        
        registerNib()
        fetchApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getData()
    }
    
    // MARK: - Collection View Protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case popularTable:
            return viewModel.popPhotos.count
        case comingSoonTable:
            return viewModel.comingSoonPhotos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case popularTable:
            guard let cell = popularTable.dequeueReusableCell(withReuseIdentifier: HomeHelper.popularCellID, for: indexPath) as? PopulaCell else {break}
            let item = viewModel.popPhotos[indexPath.row]
            cell.configure(item)
            return cell
            
        case comingSoonTable:
            guard let cell = comingSoonTable.dequeueReusableCell(withReuseIdentifier: HomeHelper.comingSoonCellID, for: indexPath) as? ComingSoonCell else {break}
            let item = viewModel.comingSoonPhotos[indexPath.row]
            cell.configure(item)
            
            return cell
        default:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2 tables are identical size
        guard let cell = Bundle.main.loadNibNamed(HomeHelper.popularNib, owner: self, options: nil)?.first as? UICollectionViewCell else { return CGSize.zero }
        return cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        outerLoop: switch collectionView {
        case popularTable:
            
            let movieID = viewModel.popArray[indexPath.row].id
            for item in viewModel.localData {
                if item.movieID == String(movieID ?? 0) {
                    detailVC.viewModel = DetailVM(item)
                    break outerLoop
                }
            }
            detailVC.viewModel = DetailVM(String(movieID ?? 0))
            break
            
        case comingSoonTable:
            let movieID = viewModel.comingSoonArr[indexPath.row].id
            for item in viewModel.localData {
                if item.movieID == String(movieID ?? 0) {
                    detailVC.viewModel = DetailVM(item)
                    break outerLoop
                }
            }
            
            detailVC.viewModel = DetailVM(String(movieID ?? 0))
            break
            
        default:
            break
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - other func
    func registerNib() {
        let nib = UINib(nibName: HomeHelper.popularNib, bundle: nil)
        popularTable.register(nib, forCellWithReuseIdentifier: HomeHelper.popularCellID)
        
        let comingSoonNib = UINib(nibName: HomeHelper.comingSoonNib, bundle: nil)
        comingSoonTable.register(comingSoonNib, forCellWithReuseIdentifier: HomeHelper.comingSoonCellID)
    }
    
    func fetchApi() {
        statusLb.text = "Loading..."
        let apiManager = ApiManager.init()
        apiManager.fetchPopular(isComingSoon: false, completion: {result in
            
            switch result {
            case .success(let popular):
                guard let result = popular.results else { return }
                self.viewModel.popArray = result
                
                DispatchQueue.global().async {
                    self.fetchBanner()
                }
                
                DispatchQueue.global().async {
                    self.fetchImage()
                }
                
                break
            case .failure(let error):
                if let err = error as? ApiError {
                    switch err {
                    case .noData:
                        self.statusLb.text = "No data available"
                    case .cantDecode:
                        self.statusLb.text = "Can't decode data"
                    }
                }
                print(error)
                break
            }
        })
        statusCsLb.text = "Loading..."
        apiManager.fetchPopular(isComingSoon: true, completion: {result in
            
            switch result {
            case .success(let comingSoon):
                guard let result = comingSoon.results else { return }
                self.viewModel.comingSoonArr = result
                DispatchQueue.global().async {
                    self.fetchImageCS()
                }
                break
            case .failure(let error):
                if let err = error as? ApiError {
                    switch err {
                    case .noData:
                        self.statusCsLb.text = "No data available"
                    case .cantDecode:
                        self.statusLb.text = "Can't decode data"
                    }
                }
                print(error)
                break
            }
        })
    }
    
    func fetchImage() {
        let imageUrl = "https://image.tmdb.org/t/p/w500"
        for item in viewModel.popArray {
            guard let poster = item.posterPath else { continue }
            guard let url = URL(string: imageUrl+poster) else {continue}
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self.viewModel.popPhotos.append(image)
                        DispatchQueue.main.async {
                            self.statusLb.isHidden = true
                        }
                    }
                }
            
        }
    }
    
    func fetchImageCS() {
        let imageUrl = "https://image.tmdb.org/t/p/w500"
        for item in viewModel.comingSoonArr {
            guard let poster = item.posterPath else {continue }
            guard let url = URL(string: imageUrl+poster) else {continue}
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self.viewModel.comingSoonPhotos.append(image)
                        DispatchQueue.main.async {
                            self.statusCsLb.isHidden = true
                        }
                    }
                }
            
        }
    }
    
    func fetchBanner() {
        if let path = viewModel.popArray.first?.backdropPath {
            print("banner1 fetching")
            self.banner1.load(path, completion: {
                print("banner1 completed")
            })
        }
        
        if let path = viewModel.popArray[1].backdropPath {
            print("banner2 fetching")
            self.banner2.load(path, completion: {
                print("banner2 completed")
            })
        }
        
        if let path = viewModel.popArray[2].backdropPath {
            print("banner3 fetching")
            self.banner3.load(path, completion: {
                print("banner3 copmleted")
            })
        }
    }
}
