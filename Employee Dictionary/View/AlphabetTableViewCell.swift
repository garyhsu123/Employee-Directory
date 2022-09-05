//
//  AlphabetTableViewCell.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/16.
//

import UIKit

class AlphabetTableViewCell: UITableViewCell {

//    @IBOutlet weak var alphbetLabel: UILabel!
    
    let alphbetLabel: UILabel = {
        var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        view.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.24)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        self.addSubview(self.alphbetLabel)
        self.alphbetLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
