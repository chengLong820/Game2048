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
//        label.backgroundColor = UIColor.orange
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        switch self.number {
        case "2":
            label.backgroundColor = hexStringToUIColor("FAE7D7")
        case "4":
            label.backgroundColor = hexStringToUIColor("FFE4CC")
        case "8":
            label.backgroundColor = hexStringToUIColor("FFC37C")
        case "16":
            label.backgroundColor = hexStringToUIColor("FF9D2B")
        case "32":
            label.backgroundColor = hexStringToUIColor("FF8B00")
        case "64":
            label.backgroundColor = hexStringToUIColor("FF6C00")
        case "128":
            label.backgroundColor = hexStringToUIColor("D6BB9F")
        case "256":
            label.backgroundColor = hexStringToUIColor("BEAC91")
        case "512":
            label.backgroundColor = hexStringToUIColor("FFE098")
        case "1024":
            label.backgroundColor = hexStringToUIColor("EAC572")
        case "2048":
            label.backgroundColor = hexStringToUIColor("FFC441")
        default:
            label.backgroundColor = .white
        }
        
        
        
        
    }
    
    /**
     let emptyTile=hexStringToUIColor("DED1C0")
     let notWhite=hexStringToUIColor("A29789")
     let n2=hexStringToUIColor("FAE7D7")
     let n4=hexStringToUIColor("FFE4CC")
     let n8=hexStringToUIColor("FFC37C")
     let n16=hexStringToUIColor("FF9D2B")
     let n32=hexStringToUIColor("FF8B00")
     let n64=hexStringToUIColor("FF6C00")
     let n128=hexStringToUIColor("D6BB9F")
     let n256=hexStringToUIColor("BEAC91")
     let n512=hexStringToUIColor("FFE098")
     let n1024=hexStringToUIColor("EAC572")
     let n2048=hexStringToUIColor("FFC441")
     let n4096=hexStringToUIColor("FFB000")
     
     */
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
