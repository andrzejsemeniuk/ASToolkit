//
//  ExtensionForUIKitUIViewController.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/9/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    public convenience init(view:UIView) {
        self.init()
        self.view = view
    }
}
