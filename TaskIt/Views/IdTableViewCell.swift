//
//  IdTableViewCell.swift
//  TaskIt
//
//  Created by Robert Wais on 8/3/18.
//

import UIKit

class IdTableViewCell: UITableViewCell {
    
    @IBOutlet weak var companyId: UILabel!
    var name = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurecell(companyId: CompanyId){
        guard let id = companyId.id,
        let name = companyId.name
        else{
            self.name = ""
            self.companyId.text = ""
            return
        }
        self.name = name
        self.companyId.text = id
    }

}
