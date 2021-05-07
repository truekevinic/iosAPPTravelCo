//
//  ViewController.swift
//  travel&co
//
//  Created by Kevin Leon on 30/04/21.
//

import UIKit

class ViewController: UIViewController {
    var groups = DBHelper.instance.tarikGroup()
    
    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        let nib = UINib(nibName: "GroupsTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "GroupsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
    }


}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            
        cell.titleLabel.text = groups?[indexPath.row].groupName ?? "no group"
        cell.subtitleLable.text = groups?[indexPath.row].groupDesc ?? "no description"
               
        return cell
    }
}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)

        let DestVC = Storyboard.instantiateViewController(withIdentifier: "ExpenseViewController") as! ExpenseViewController
        if let grupygdipilih = groups {
            DestVC.selectedGroup = grupygdipilih[indexPath.row]
        }
        self.navigationController?.pushViewController(DestVC, animated: true)

    }
}
public struct group {
    var participants: [String]?
    var currency : Int?
    var name: String?
    var description : String?
}
public var groupsStruct = [group]()
