//
//  AddParticipantTableViewCell.swift
//  travel&co
//
//  Created by Kevin Leon on 03/05/21.
//

import UIKit
protocol AddParticipantTableViewCellDelegate: AnyObject {
    func deleteParticipant(with index: Int)
}
class AddParticipantTableViewCell: UITableViewCell {
    weak var delegate : AddParticipantTableViewCellDelegate?
    @IBOutlet weak var deleteParticipantButton: UIButton!
    @IBOutlet weak var participantNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    private var index:Int = -1
    @IBAction func deleteParticipan(){
        delegate?.deleteParticipant(with: index)
    }
    func configure(with index:Int)->(){
        self.index = index
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
