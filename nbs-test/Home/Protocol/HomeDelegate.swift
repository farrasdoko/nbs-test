//
//  HomeDelegate.swift
//  nbs-test
//
//  Created by Farras Doko on 17/03/21.
//

import Foundation

protocol HomeDelegate {
    func apiFail(_ sender: SenderHome)
    func reloadTableView()
    func fetchImageCompleted(_ sender: SenderHome)
}
