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

extension UIViewController {
    
	open func presentAlertForInput(animated:Bool = true, title:String, message:String, value:String = "", select:Bool = true, ok:String = "Ok", cancel:String = "Cancel", setter:@escaping (String)->()) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.text = value
        }
        let ok = UIAlertAction.init(title: ok, style: UIAlertAction.Style.default) { action in
            setter(alert.textFields?[safe:0]?.text ?? "")
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction.init(title: cancel, style: UIAlertAction.Style.cancel) { action in
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(cancel)
		self.present(alert, animated: animated) {
			if select {
				alert.textFields?.first?.selectAll(self)
			}
		}
    }
    
    open func presentAlertForAnswer                (animated:Bool = true, title:String, message:String, ok:String = "Ok", handler:(()->())? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: ok, style: UIAlertAction.Style.default) { action in
            handler?()
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: animated)
    }
    
    open func presentAlertForQuestion            (animated:Bool = true, title:String, message:String, ok:String = "Ok", cancel:String = "Cancel", handler:@escaping ()->() ) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: ok, style: UIAlertAction.Style.default) { action in
            handler()
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction.init(title: cancel, style: UIAlertAction.Style.cancel) { action in
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(cancel)
        self.present(alert, animated: animated)
    }
    
	open func presentAlertForUITextField         (_ field:UITextField, animated:Bool = true, title:String, message:String, select:Bool = true, ok:String = "Ok", cancel:String = "Cancel", setter:@escaping (String)->()) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.text = field.text
        }
        let ok = UIAlertAction.init(title: ok, style: UIAlertAction.Style.default) { action in
            setter(alert.textFields?[safe:0]?.text ?? "")
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction.init(title: cancel, style: UIAlertAction.Style.cancel) { action in
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(cancel)
		self.present(alert, animated: animated) {
			if select {
				alert.textFields?.first?.selectAll(self)
			}
		}
    }
    
    open func presentAlertForChoice              (animated:Bool = true, title:String, message:String, choices:[String], cancel:String = "Cancel", handler:@escaping (String)->()) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        for choice in choices {
            let ok = UIAlertAction.init(title: choice, style: .destructive) { action in
                handler(choice)
                //                alert.dismiss(animated: true) {
                //                }
            }
            alert.addAction(ok)
        }
        let cancel = UIAlertAction.init(title: cancel, style: .cancel) { action in
            alert.dismiss(animated: animated) {
            }
        }
        alert.addAction(cancel)
        self.present(alert, animated: animated)
    }
    
}

