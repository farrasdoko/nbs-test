//
//  PopularVC.swift
//  nbs-test
//
//  Created by Farras Doko on 22/02/21.
//

import UIKit
import Combine

class PopularVC: UIViewController {
    
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var popularTable: UICollectionView!
    lazy var searchController = UISearchController()
    
    var viewModel: SearchVM?
    var cancellable: AnyCancellable?
    var imageData = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchController()
        initCollectionView()
        
        viewModel = SearchVM(services: [TmdbApi()])
        cancellable = viewModel?.$imageUrls.sink {
            urls in
            for url in urls {
                DispatchQueue.global().async {
                    guard let url = URL(string: "https://image.tmdb.org/t/p/w500"+url) else {return}
                    if let data = try? Data(contentsOf: url) {
                        print("data successfully pulled")
                        self.imageData.append(data)
                        DispatchQueue.main.async {
                            self.popularTable.reloadData()
                        }
                    }
                }
            }
        }
        
        register(popularTable)
        //        fetchApi()
        statusLb.text = ""
    }
    
    // MARK: Initialization
    func initSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    func initCollectionView() {
        popularTable.dataSource = self
        popularTable.delegate = self
    }
    func register(_ collectionView: UICollectionView) {
        let nib = UINib(nibName: PopularHelper.searchNib, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: PopularHelper.searchCellID)
    }
    
}

extension PopularVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = popularTable.dequeueReusableCell(withReuseIdentifier: PopularHelper.searchCellID, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        
        let data = imageData[indexPath.row]
        if let image = UIImage(data: data) {
            cell.setImage(image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width / 2) - 8
        let ratio: CGFloat = 2
        let height = width * ratio
        
        return CGSize(width: width, height: height)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
    //
    //        let movieID = viewModel?.popArr[indexPath.row].id
    //        if let localData = viewModel?.localData {
    //            for item in localData {
    //                if item.movieID == String(movieID ?? 0) {
    //                    detailVC.viewModel = DetailVM(item)
    //                    self.navigationController?.pushViewController(detailVC, animated: true)
    //                    return
    //                }
    //            }
    //        }
    //
    //        detailVC.viewModel = DetailVM(String(movieID ?? 0))
    //
    //        self.navigationController?.pushViewController(detailVC, animated: true)
    //    }
    
}

extension PopularVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.query = searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != "" {
            statusLb.text = "showing result of '\(searchBar.text ?? "")'"
        }
        resignFirstResponder()
    }
    /*
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
     guard let holdArr = viewModel?.holdArr else { return }
     guard let photos = viewModel?.photosHold else { return }
     
     viewModel?.popArr.removeAll()
     viewModel?.photos.removeAll()
     
     viewModel?.popArr = holdArr
     viewModel?.photos = photos
     
     resignFirstResponder()
     }
     */
}
