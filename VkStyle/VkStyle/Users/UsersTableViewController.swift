//
//  UsersTableViewController.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var users: [UsersInfo] = [
        UsersInfo(user: "Helga",
                  photo: UIImage(named: "1121"),
                  photoList: [UIImage(named: "1121"),
                              UIImage(named: "1131"),
                              UIImage(named: "1135")]),
        UsersInfo(user: "Ken",
                  photo: UIImage(named: "1123"),
                  photoList: [UIImage(named: "1123"),
                              UIImage(named: "1131"),
                              UIImage(named: "1134")]),
        UsersInfo(user: "Tom",
                  photo: UIImage(named: "1124"),
                  photoList: [UIImage(named: "1124"),
                              UIImage(named: "1132")]),
        UsersInfo(user: "Cat",
                  photo: UIImage(named: "1122"),
                  photoList: [UIImage(named: "1122"),
                              UIImage(named: "1133")])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersTableViewCell
        let user = users[indexPath.row]
        cell.userName.text = user.user
        cell.userPhoto.image = user.photo
        cell.cellIndex = indexPath.row

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let targetPhotoCollection
            = segue.destination as? PhotosCollectionViewController else { return }
        guard let cell = sender as? UsersTableViewCell else { return }
        guard let cellIndex = cell.cellIndex else { return }
        
        let user = users[cellIndex]
        targetPhotoCollection.setUserPhotoList(photoList: user.photoList)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
