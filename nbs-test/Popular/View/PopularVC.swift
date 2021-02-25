//
//  PopularVC.swift
//  nbs-test
//
//  Created by Farras Doko on 22/02/21.
//

import UIKit

class PopularVC: UIViewController {
    
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var popularTable: UICollectionView!
    lazy var searchController = UISearchController()
    
    var viewModel: SearchVM? {
        didSet {
            DispatchQueue.main.async {
                self.popularTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        
        popularTable.dataSource = self
        popularTable.delegate = self
        
        register(popularTable)
        fetchApi()
        statusLb.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.getData()
    }
    
    func register(_ collectionView: UICollectionView) {
        let nib = UINib(nibName: PopularHelper.searchNib, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: PopularHelper.searchCellID)
    }
    
    func fetchApi() {
        let manager = ApiManager()
        manager.fetchPopular(isComingSoon: false, completion: {
            result in
            switch result {
            case .success(let populer):
                guard let results = populer.results else { return }
                self.viewModel = SearchVM(results)
                self.fetchImage()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func fetchImage() {
        let imageUrl = "https://image.tmdb.org/t/p/w500"
        guard let items = viewModel?.holdArr else { return }
        guard let isChanged = viewModel?.changed else { return }
        
        for item in items {
            guard let poster = item.posterPath else { continue }
            guard let url = URL(string: imageUrl+poster) else {continue}
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    if !isChanged {
                        viewModel?.addPhoto(image)
                        continue
                    }
                    viewModel?.photosHold.append(image)
                }
            }
        }
    }
    
}

extension PopularVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = popularTable.dequeueReusableCell(withReuseIdentifier: PopularHelper.searchCellID, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        
        if let item = viewModel?.popArr[indexPath.row] {
            cell.configure(item)
            if let image = viewModel?.photos[indexPath.row] {
                cell.setImage(image)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width / 2) - 8
        let ratio: CGFloat = 2
        let height = width * ratio
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        let movieID = viewModel?.popArr[indexPath.row].id
        if let localData = viewModel?.localData {
            for item in localData {
                if item.movieID == String(movieID ?? 0) {
                    detailVC.viewModel = DetailVM(item)
                    self.navigationController?.pushViewController(detailVC, animated: true)
                    return
                }
            }
        }
        
        detailVC.viewModel = DetailVM(String(movieID ?? 0))
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension PopularVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // prevent error
        viewModel?.changed = true
        viewModel?.popArr.removeAll()
        viewModel?.photos.removeAll()
        
        guard let holdArr = self.viewModel?.holdArr, holdArr.count > 0, let photosHold = viewModel?.photosHold else { return }
        for index in 0 ... (photosHold.count-1) {
            guard let title = holdArr[index].title else {continue}
            let item = holdArr[index]
            let photo = photosHold[index]
            
            if title.contains(searchText) {
                viewModel?.popArr.append(item)
                viewModel?.photos.append(photo)
            }
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != "" {
            statusLb.text = "showing result of '\(searchBar.text ?? "")'"
        }
        resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let holdArr = viewModel?.holdArr else { return }
        guard let photos = viewModel?.photosHold else { return }
        
        viewModel?.popArr.removeAll()
        viewModel?.photos.removeAll()
        
        viewModel?.popArr = holdArr
        viewModel?.photos = photos
        
        resignFirstResponder()
    }
}
