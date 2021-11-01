//
//  ExpandableLabel.swift
//  NextRead
//
//  Created by Javier Fransiscus on 11/10/21.
//

import UIKit

class ExpandableLabel: UILabel {
    var isExpanded = false

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let buttonAray = superview?.subviews.filter { subViewObj -> Bool in
            subViewObj.tag == 9090
        }

        if buttonAray?.isEmpty == true {
            addReadMoreButton()
        }
    }

    // Add readmore button in the label.
    func addReadMoreButton() {
        let theNumberOfLines = numberOfLinesInLabel(yourString: text ?? "", labelWidth: frame.width, labelHeight: frame.height, font: font)

        let height = frame.height
        numberOfLines = isExpanded ? 0 : 2

        if theNumberOfLines > 2 {
            numberOfLines = 2

            let button = UIButton(frame: CGRect(x: 0, y: height + 16, width: 70, height: 16))
            button.tag = 9090
            button.frame = frame
            button.frame.origin.y = frame.origin.y + frame.size.height
            button.setTitle("Read more", for: .normal)
            button.titleLabel?.font = button.titleLabel?.font.withSize(15)
            button.backgroundColor = .clear
            button.setTitleColor(UIColor.tintColor, for: .normal)
            button.addTarget(self, action: #selector(ExpandableLabel.buttonTapped(sender:)), for: .touchUpInside)
            superview?.addSubview(button)
            superview?.bringSubviewToFront(button)
            button.setTitle("Read less", for: .selected)
            button.isSelected = isExpanded
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: leadingAnchor),
                button.topAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            ])
        } else {
            numberOfLines = 2
        }
    }

    // Calculating the number of lines. -> Int
    func numberOfLinesInLabel(yourString: String, labelWidth: CGFloat, labelHeight: CGFloat, font: UIFont) -> Int {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = labelHeight
        paragraphStyle.maximumLineHeight = labelHeight
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributes: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font, NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraphStyle]

        let constrain = CGSize(width: labelWidth, height: CGFloat(Float.infinity))

        let size = yourString.size(withAttributes: attributes)

        let stringWidth = size.width

        let numberOfLines = ceil(Double(stringWidth / constrain.width))

        return Int(numberOfLines)
    }

    // ReadMore Button Action
    @objc func buttonTapped(sender: UIButton) {
        isExpanded = !isExpanded
        sender.isSelected = isExpanded

        numberOfLines = sender.isSelected ? 0 : 2

        layoutIfNeeded()

        var viewObj: UIView? = self
        var cellObj: UITableViewCell?
        while viewObj?.superview != nil {
            if let cell = viewObj as? UITableViewCell {
                cellObj = cell
            }

            if let tableView = (viewObj as? UITableView) {
                if let indexPath = tableView.indexPath(for: cellObj ?? UITableViewCell()) {
                    tableView.beginUpdates()
                    print(indexPath)
                    tableView.endUpdates()
                }
                return
            }

            viewObj = viewObj?.superview
        }
    }
}
