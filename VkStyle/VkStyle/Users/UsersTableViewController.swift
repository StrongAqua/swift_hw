//
//  UsersTableViewController.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    
    let refreshCtrl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Register the custom header view.
        tableView.register(UsersTableCustomHeader.self,
                           forHeaderFooterViewReuseIdentifier: "usersSectionHeader")
        
        searchBar.setup(delegate: self)
        reloadFriends()
        
        tableView.addSubview(refreshCtrl)
        refreshCtrl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        reloadFriends()
    }
    
    func reloadFriends() {
        VKApi.instance.getFriendsList({ [weak self] friends, event in
            if (event == .dataLoadedFromDB) {
                debugPrint("completion block: update UI (tableView)");
                UsersManager.shared.setUsersInfo(friends as! [VkApiUsersItem])
                UsersManager.shared.rebuild()
                self?.tableView.reloadData()
            }
            self?.refreshCtrl.endRefreshing()
        })
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return UsersManager.shared.alphabet.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let userKey = UsersManager.shared.alphabet[section]
        return UsersManager.shared.dict[userKey]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersTableViewCell
        let userKey = UsersManager.shared.alphabet[indexPath.section]
        if let user = UsersManager.shared.dict[userKey] {
            cell.setup(user: user[indexPath.row])
            cell.indexPath = indexPath
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let targetPhotoCollection
            = segue.destination as? PhotosCollectionViewController else { return }
        guard let cell = sender as? UsersTableViewCell else { return }
        guard let indexPath = cell.indexPath else { return }
        guard let user = UsersManager.shared.getUserByIndexPath(indexPath) else { return }
        
        targetPhotoCollection.setUser(user: user)
        targetPhotoCollection.navigationItem.title = user.user
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            "usersSectionHeader") as! UsersTableCustomHeader
        view.setup(UsersManager.shared.alphabet[section])
        return view
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UsersManager.shared.alphabet
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

extension UsersTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UsersManager.shared.applyFilter(searchText)
        tableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ _searchBar: UISearchBar) -> Bool {
        self.searchBar.cancel()
        return true
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


