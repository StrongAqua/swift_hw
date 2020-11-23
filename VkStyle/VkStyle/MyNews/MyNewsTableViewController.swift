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
    var expandedCells: [Int: Bool] = [:]
    let refreshCtrl = UIRefreshControl()
    let dataService = DataService()
    let vkNews = VKApiNews()
    
    var isLoading = false
    var nextFrom = ""
    
    let loadBlockCount = 10
    let startPrefetchCount = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil),
                           forCellReuseIdentifier: "NewsCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        reloadNews()

        tableView.refreshControl = refreshCtrl
        tableView.prefetchDataSource = self
        refreshCtrl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        reloadNews()
    }
    
    func reloadNews() {
        let lastDate = news.first?.date
        vkNews.get(
            args: lastDate != nil
                ? ["start_time": (lastDate ?? 0) + 1]
                : ["count": loadBlockCount],
            completion: { [weak self] news, nextFrom, source in
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else { return }
                    if (source == .live) {
                        guard let newsList = news as? [VkApiNewsItem] else {return}
                        self.news = newsList.sorted(by: {$0.date > $1.date}) + self.news
                        self.nextFrom = nextFrom
                        debugPrint("\(newsList.count) news records added")
                        self.tableView.reloadData()
                    }
                    self.refreshCtrl.endRefreshing()
                }
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
        cell.setup(item, dataService, self.expandedCells[indexPath.row] ?? false)
        { // on show more button pressed
            [weak self] cell in
            guard let self = self else {return}
            guard let indexPath = self.tableView.indexPath(for: cell) else {return}
            if let _ = self.expandedCells[indexPath.row] {
                self.expandedCells.removeValue(forKey: indexPath.row)
            } else {
                self.expandedCells[indexPath.row] = true
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
    
}

extension MyNewsTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastRow = indexPaths.map({ $0.row }).max() else { return }
        if lastRow > news.count - startPrefetchCount && !isLoading {
            isLoading = true
            var args: [String: Any] = ["count": loadBlockCount]
            if nextFrom.isEmpty == false {
                args["start_from"] = nextFrom
            }
            vkNews.get(
                args: args,
                completion: { [weak self] news, nextFrom, source in
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let self = self else { return }
                        if (source == .live) {
                            guard let newsList = news as? [VkApiNewsItem] else {return}

                            // calculating set of row indexes for new loaded posts
                            var indexes: [IndexPath] = []
                            for index in self.news.count ..< self.news.count + newsList.count {
                                indexes.append(IndexPath(row: index, section: 0))
                            }
                            
                            let sortedList = newsList.sorted(by: {$0.date > $1.date})
                            self.news.append(contentsOf: sortedList)
                            self.nextFrom = nextFrom

                            self.tableView.insertRows(at: indexes, with: .automatic)
                        }
                        self.isLoading = false
                    }
                })
            
        }
    }
}
