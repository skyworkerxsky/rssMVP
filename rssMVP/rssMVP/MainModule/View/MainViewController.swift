//
//  ViewController.swift
//  rssMVP
//
//  Created by Алексей Макаров on 28.02.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var presenter: MainViewPrecenterProtocol!
    
    // MARK: - Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "rss"
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rssItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = .none
        
        if let item = presenter.rssItems?[indexPath.row] {
            cell.item = item
            
            if !item.image.isEmpty {
                Network.getImage(url: item.image) { (image) in
                    DispatchQueue.main.async {
                        cell.img.image = image
                    }
                }
            } else {
                cell.img.isHidden = true
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        
        tableView.beginUpdates()
         if let item = presenter.rssItems?[indexPath.row] {
            
            if !cell.descriptionLabel.text!.isEmpty {
                cell.descriptionLabel.text = ""
            } else {
                cell.descriptionLabel.text = item.description
            }
        }
        tableView.endUpdates()
    }
    
}

extension MainViewController: MainViewProtocol {
    
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
}

