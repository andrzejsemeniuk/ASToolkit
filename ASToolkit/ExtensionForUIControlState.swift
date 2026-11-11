//
//  ExtensionForUIKitUIControl.State.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 9/16/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension UIControl.State : RawRepresentable {

}

extension UIControl.State : CustomStringConvertible {

	public var description: String {
		return name
	}

	public var name : String {
		switch self {
		case .application                 : return "application"
		case .disabled                    : return "disabled"
		case .focused                     : return "focused"
		case .highlighted                 : return "highlighted"
		case .normal                      : return "normal"
		case .reserved                    : return "reserved"
		case .selected                    : return "selected"
		default:
			return String(self.rawValue)
		}
	}

}

extension UIControl.State : Hashable {
    
    public var hashValue : Int {
        switch self {
        case .normal        : return 1
        case .highlighted   : return 4
        case .disabled      : return 3
        case .selected      : return 2
        case .focused       : return 5
        case .application   : return 6
        case .reserved      : return 7
        default:
            return 8
        }
    }
}

extension UIControl.State : Equatable {
    
}
