//
//  UsersViewController.swift
//  VkStyle
//
//  Created by aprirez on 8/19/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let targetPhotoCollection
            = segue.destination as? PhotosCollectionViewController else { return }
        guard let cell = sender as? UsersTableViewCell else { return }
        guard let indexPath = cell.indexPath else { return }
        
        if let user = UsersManager.shared.getUserByIndexPath(indexPath) {
            targetPhotoCollection.setUserPhotoList(photoList: user.photoList)
            targetPhotoCollection.navigationItem.title = user.user
        }
    }
}

extension UsersViewController: UITableViewDataSource {

    func numberOfSections(in: UITableView) -> Int {
        return UsersManager.shared.alphabet.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = UsersManager.shared.alphabet[section]
        return UsersManager.shared.dict[letter]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let letter = UsersManager.shared.alphabet[section]
        return String(letter)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersTableViewCell

        if let user = UsersManager.shared.getUserByIndexPath(indexPath) {
            cell.setup(user: user)
            cell.indexPath = indexPath
        }
        
        return cell
    }
}

extension UsersViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        UsersManager.shared.alphabet.count
    }
}

extension UsersViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return String(UsersManager.shared.alphabet[row])
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        let indexPath = IndexPath(row: 0, section: row)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
    }
}
