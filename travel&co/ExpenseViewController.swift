//
//  ExpenseViewController.swift
//  travel&co
//
//  Created by Kevin Leon on 04/05/21.
//

import UIKit
struct expense{
    var expenseName: String?
    var currency: Int?
    var amount: Float?
    var participant: [Int]?
    var date: Date?
    var paidDebt: Int?
    var advancedSplit:Bool?
}
struct sharedExpense{
}
class ExpenseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedGroup: Group?
    var transactions : [Transaction]?
    override func viewDidLoad() {
        
        
        if let groupId = selectedGroup {
            transactions = DBHelper.instance.tarikExpenses(group: groupId)
        }
        super.viewDidLoad()
        let nib = UINib(nibName: "ExpenseTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "ExpenseTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
    }
}
extension ExpenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedGroup?.transactions?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as! ExpenseTableViewCell
        if let transaksiyangada = transactions {
            cell.amountLabel.text = String(transaksiyangada[indexPath.row].transactionTotal)
            cell.categoryLabel.text = String(transaksiyangada[indexPath.row].aCategory?.categoryName ?? "nul")
            cell.expenseNameLabel.text = String(transaksiyangada[indexPath.row].transactionName!)
        }else{
            cell.amountLabel.text = "kosong"
            cell.categoryLabel.text = "gda"
            cell.expenseNameLabel.text = "kosong"
        }
        return cell
    }
}
extension ExpenseViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)

        let DestVC = Storyboard.instantiateViewController(withIdentifier: "BookmarkViewController2") as! BookmarkViewController2

        DestVC.getQuizName = bookmark[indexPath.row] as! String
        DestVC.topikIndex = indexPath.row
        self.navigationController?.pushViewController(DestVC, animated: true)

    }
}
