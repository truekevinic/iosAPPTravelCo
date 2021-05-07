//
//  AddGroupViewController.swift
//  travel&co
//
//  Created by Kevin Leon on 02/05/21.
//

import UIKit

class AddGroupViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var participantField: UITextField!
    @IBOutlet weak var doneAddButton: UIBarButtonItem!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    var participant = [String]()
    var newGroup = group()
    var currencies = ["IDR","USD","SGP","MYR","SEM","JPY"]
    var choosenCurrency: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "AddParticipantTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "AddParticipantTableViewCell")
        tableView.dataSource = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.isHidden = true
    }
    
    @IBAction func changeCurrencies(_ sender: Any) {
        currencyPicker.isHidden = false
        showToast(message: "asdd")
    }

    @IBAction func editDescriptionField(_ sender: Any) {
    }
    @IBAction func participantField(_ sender: Any) {
    }
    @IBAction func addParticipantButton(_ sender: Any) {
        
        if let isFilled = participantField.text{
            if participantField.text == "" {
                showToast(message: "nama gaboleh kosong")
                return
            }
            if(participant.count > 0){
                
            
                for n in 1...participant.count  {
                    if isFilled == participant[n-1] {
                        showToast(message: "nama gaboleh duplikat")
                        return
                    }
                }
            }
            participant.append(isFilled)
            tableView.reloadData()
        }
    }
    func deleteParticipant(participantRow : Int) -> () {
        participant.remove(at: participantRow)
        tableView.reloadData()
    }
    
    @IBAction func addGroupButton(_ sender: Any) {
        if nameField.text == "" {
            showToast(message: "isi nama grup dulu")
            return
        }
        if groups.count > 0{
            for n in 0...groups.count {
                if(groups[n].name == nameField.text){
                    showToast(message: "nama grup sudah ada")
                    return
                }
            }
        }
        if currencyField.text == "" {
            showToast(message: "pilih mata uang dulu")
            return
        }
        if participant.count < 2 {
            showToast(message: "anggota harus lebih dari 1")
            return
        }
        //masukin ke database, kemudian dismiss dan reload data di halaman awal
    }

    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - CGFloat(message.count * 10)/2, y: self.view.frame.size.height-100, width: CGFloat(message.count * 10) , height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = .systemFont(ofSize: 15)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
extension AddGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddParticipantTableViewCell", for: indexPath) as! AddParticipantTableViewCell
        cell.participantNameLabel.text = participant[indexPath.row]
        cell.configure(with: indexPath.row)
        cell.delegate = self
        return cell
    }
}
extension AddGroupViewController: AddParticipantTableViewCellDelegate{
    func deleteParticipant(with index: Int) {
        participant.remove(at: index)
        tableView.reloadData()
    }
}

extension AddGroupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            currencyField.text = currencies[row]
            newGroup.currency = row

            currencyField.resignFirstResponder()
            currencyPicker.isHidden = true
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
}
