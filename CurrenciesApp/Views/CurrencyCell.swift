//
//  CurrencyCell.swift
//  CurrenciesApp
//
//  Created by Alex Ch on 19.01.25.
//

import UIKit

class CurrencyCell: UITableViewCell {
    final let identifier = "CurrencyCell"
    var nameLabel = UILabel()
    var valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        let boxView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.contentView.backgroundColor = .white
        boxView.backgroundColor = .white
        self.contentView.addSubview(boxView)
        boxView.layer.cornerRadius = 2.0;
        
        
        nameLabel = UILabel(frame:CGRect(x:12, y:0, width: 40, height: 40) )
        boxView.addSubview(nameLabel)
        nameLabel.textColor = UIColor.black
        
        valueLabel = UILabel(frame:CGRect(x: nameLabel.frame.width + 36 , y:0 , width: boxView.frame.width - nameLabel.frame.width + 36, height: 40) )
        boxView.addSubview(valueLabel)
        valueLabel.textColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
