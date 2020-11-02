//
//  MyNewsTableViewController.swift
//  VkStyle
//
//  Created by aprirez on 8/30/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class MyNewsTableViewController: UITableViewController {
    
    var news: [VkApiNewsItem] = []
    let refreshCtrl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil),
                           forCellReuseIdentifier: "NewsCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        reloadNews()
        
        tableView.addSubview(refreshCtrl)
        refreshCtrl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        reloadNews()
    }
    
    func reloadNews() {
        VKApi.instance.getNewsList({ [weak self] news, event in
            if (event == .dataLoadedFromDB) {
                debugPrint("completion block: update UI (tableView), \(news.count)");
                let newsList = news as! [VkApiNewsItem]
                self?.news = newsList.sorted(by: {$0.date > $1.date})
                self?.tableView.reloadData()
            }
            self?.refreshCtrl.endRefreshing()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        // Configure the cell...
        let item = news[indexPath.row]
        cell.setup(item)
        return cell
    }
    
}
