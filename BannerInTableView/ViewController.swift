//
//  ViewController.swift
//  BannerInTableView
//
//  Created by Ashish Samanta on 20/04/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tabView: UITableView!
    
    let imageURL = "https://images.unsplash.com/photo-1587394012759-f48c3073c93c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2700&q=80"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView()
        self.tabView.register(UINib(nibName: "BannerCell", bundle:Bundle(for: BannerCell.self)), forCellReuseIdentifier: "BannerCell")
        self.tabView.register(UINib(nibName: "randomCell", bundle:Bundle(for: randomCell.self)), forCellReuseIdentifier: "randomCell")
    }


}

extension ViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        if section == 0{
            return 7
        }
        else if section == 1{
            return 1
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "randomCell", for: indexPath) as! randomCell
            cell.keyTextLabel.text = "Random Data"
            return cell
        }
        else if indexPath.section == 1{
            let cell = tabView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerCell
                cell.collectionViewHeight.constant = 100
            cell.collectionViewWidth.constant = UIScreen.main.bounds.width
            cell.imageURL = imageURL
            return cell
        }
        else{
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if indexPath.section == 0{
            return 40
        }
        else if indexPath.section == 1{
            return 100
        }
        else{
            return 0
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}

