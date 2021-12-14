//
//  CollectionViewCell.swift
//  Game2048
//
//  Created by admin on 2021/12/12.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static var identifier:String = "CollectionViewCell"
    var label = UILabel()
    var number: String = "0"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configCellWithNumber(number: String, tag:Int) {
        self.number = number
        self.tag = tag
        if number != " " {
            setupUI()
        }
    }
    
    override func prepareForReuse() {
        label.text = " "
        label.backgroundColor = .black
    }
    
    func setupUI() {
        label.text = self.number
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.backgroundColor = UIColor.orange
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
    }
    
}
