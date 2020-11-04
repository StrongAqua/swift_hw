//
//  AllGroupsTableViewController.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    weak var timer: Timer?

    var groups: [VkApiGroupItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.setup(delegate: self)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! AllGroupsTableViewCell
        let group = groups[indexPath.row]
        cell.setup(title: group.name, imageURL: group.photo50Url)
        return cell
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.75,
            repeats: false,
            block: {
                [weak self] timer in
                self?.doSearch()
            })
    }

    func doSearch() {
        VKApi.instance.searchGroups(searchBar.searchBar.text ?? "", { [weak self] groups, event in
            if (event == .dataLoadedFromServer) {
                self?.setGroups(groups as! [VkApiGroupItem])
                self?.tableView.reloadData()
            }
        })
        tableView.reloadData()
    }
    
    func setGroups(_ groups: [VkApiGroupItem]) {
        self.groups = []
        for group in groups {
            self.groups.append(group)
        }
    }
    
}

extension AllGroupsTableViewController: UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // timer here is necessary to prevent often requests to the server,
        // limited by VK server: 3 requests in 1 sec
        startTimer()
    }
    
    func searchBarShouldEndEditing(_ _searchBar: UISearchBar) -> Bool {
        self.searchBar.cancel()
        return true
    }
    
}
