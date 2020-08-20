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
    
    var users: [UsersInfo] = [
        UsersInfo(user: "Cat",
                  photo: UIImage(named: "1122"),
                  photoList: [UIImage(named: "1122"),
                              UIImage(named: "1133")]),
        UsersInfo(user: "Helga",
                  photo: UIImage(named: "1121"),
                  photoList: [UIImage(named: "1121"),
                              UIImage(named: "1131"),
                              UIImage(named: "1135")]),
        UsersInfo(user: "Todd",
                  photo: UIImage(named: "1123"),
                  photoList: [UIImage(named: "1123"),
                              UIImage(named: "1131"),
                              UIImage(named: "1134")]),
        UsersInfo(user: "Tom",
                  photo: UIImage(named: "1124"),
                  photoList: [UIImage(named: "1124"),
                              UIImage(named: "1132")])
    ]

    var letters: Set<Character> = []
    var lettersArray: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for el in users {
            if let name = el.user, let letter = name.first {
                letters.insert(letter)
            }
        }
        lettersArray = letters.sorted()
        // let primeStrings = primes.sorted().map(String.init)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let targetPhotoCollection
            = segue.destination as? PhotosCollectionViewController else { return }
        guard let cell = sender as? UsersTableViewCell else { return }
        guard let userIndex = cell.userIndex else { return }
        
        let user = users[userIndex]
        targetPhotoCollection.setUserPhotoList(photoList: user.photoList)
        targetPhotoCollection.navigationItem.title = user.user
    }
}

extension UsersViewController: UITableViewDataSource {

    func numberOfSections(in: UITableView) -> Int {
        return lettersArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        for el in users {
            if el.user?.first == lettersArray[section] {
                rowCount += 1
            }
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(lettersArray[section])
    }
    
    func getUserIndex(_ tableView: UITableView, _ indexPath: IndexPath) -> Int {
        var userIndex: Int = 0
        for i in 0..<indexPath.section {
            userIndex += tableView.numberOfRows(inSection: i)
        }
        return userIndex + indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersTableViewCell
        let userIndex = getUserIndex(tableView, indexPath)
        let user = users[userIndex]
        cell.setup(user: user)
        cell.userIndex = userIndex
        
        return cell
    }
}

extension UsersViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lettersArray.count
    }
}

extension UsersViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return String(lettersArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        let indexPath = IndexPath(row: 0, section: row)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
    }
}
