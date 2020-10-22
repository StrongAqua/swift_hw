//
//  MyGroupsTableViewController.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class MyGroupsTableViewController: UITableViewController {
    
    var groups: [VkApiGroupItem] = []
    
    let refreshCtrl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadGroups()
        
        tableView.addSubview(refreshCtrl)
        refreshCtrl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        reloadGroups()
    }
    
    func reloadGroups() {
         VKApi.instance.getGroupsList({ [weak self] groups, event in
            if (event == .dataLoadedFromDB) {
                self?.setGroups(groups as! [VkApiGroupItem])
                self?.tableView.reloadData()
            }
            self?.refreshCtrl.endRefreshing()
        })
    }
    func setGroups(_ groups: [VkApiGroupItem]) {
        self.groups = []
        for group in groups {
            self.groups.append(group)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsTableViewCell
        let group = groups[indexPath.row]
        cell.setup(title: group.name, imageURL: group.photo_50_url)
        return cell
    }
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверяем идентификатор, чтобы убедиться, что это нужный переход
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let allGroupsTableViewController = segue.source as! AllGroupsTableViewController
            
            // Получаем индекс выделенной ячейки
            if let indexPath = allGroupsTableViewController.tableView.indexPathForSelectedRow {
                // Получаем группу по индексу
                let group = allGroupsTableViewController.groups[indexPath.row]
                // Проверяем, что такой группы нет в списке
                if !groups.contains(group) {
                    // Добавляем группу в список выбранных групп
                    debugPrint("Append group \(group.name)")
                    groups.append(group)
                    VKApi.instance.saveGroups([group])
                }
            }
        }
    }
}
