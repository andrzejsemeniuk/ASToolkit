//
//  UICalibratorPropertyList.swift
//  ASToolkit
//
//  Created by andrej on 6/30/19.
//  Copyright © 2019 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

class UICalibratorPropertyList : UITableView {

	var properties : [String]
	var selected   : String
	var completion : (String?)->()
	typealias Cellulator = (UITableViewCell)->()
//	var cellulator : Cellulator
	typealias Labelizor = (UILabel)->()
//	var labelizor	: Labelizor
	var colorBackgroundSelected: UIColor
	var colorTextSelected: UIColor
	var colorText: UIColor
	var fontText: UIFont
	var fontTextSelected : UIFont



	init(properties: [String],
		 selected: String,
		 colorBackground: UIColor,
		 colorBackgroundSelected: UIColor,
		 colorTextSelected: UIColor,
		 colorText: UIColor,
		 fontText: UIFont,
		 fontTextSelected: UIFont,
		 /* labelizor: @escaping Labelizor, */ completion: @escaping (String?)->())
	{

		self.properties		= properties
		self.selected 		= selected
//		self.labelizor 		= labelizor
		self.colorBackgroundSelected	= colorBackgroundSelected
		self.colorTextSelected		= colorTextSelected
		self.colorText		= colorText
		self.fontText		= fontText
		self.fontTextSelected = fontTextSelected
		self.completion 	= completion

		super.init(frame: .zero, style: .plain)

		self.backgroundColor = colorBackground

		self.delegate 		= self
		self.appSource 	= self

		self.cornerRadius 	= 8
		self.rowHeight 		= fontText.lineHeight + 6
		self.separatorStyle = .none
		self.showsHorizontalScrollIndicator = false
//		self.contentInset.set(left: 0, right: 0, top: 0, bottom: 0)
//		self.isScrollEnabled = false

		self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handlerForGestureRecognizerForTap(_:))))

//		self.contentSize.width -= 60
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension UICalibratorPropertyList : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return properties.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = UITableViewCell.init()

		let label = UILabel.init()

		cell.contentView.addSubview(label)

		let title = properties[indexPath.row]

		if title == selected {
			label.backgroundColor = colorBackgroundSelected
			label.attributedText = title | colorTextSelected | fontTextSelected
		} else {
			label.backgroundColor = .clear
			label.attributedText = title | colorText | fontText
		}

		label.sizeToFit()

		label.constrainToSuperview()

		cell.sizeToFit()

		cell.backgroundColor = .clear // UIColor.init(white: 1, alpha: 0.8)

//		cell.borderColor = .red
//		cell.borderWidth = 1
//		cell.cornerRadius = 4

		return cell
	}

	@objc func handlerForGestureRecognizerForTap(_ recognizer: UITapGestureRecognizer) {

		let point = recognizer.location(in: self)

		if let path = self.indexPathForRow(at: point) {
			self.selectRow(at: path, animated: false, scrollPosition: .none)
			self.completion(properties[path.row])
		}
	}

}

extension UICalibratorPropertyList : UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.completion(properties[indexPath.row])
	}

}
