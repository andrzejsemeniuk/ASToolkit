//
//  UIViewShowcase.swift
//  TGF
//
//  Created by andrzej semeniuk on 5/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

class UIViewShowcase : UIViewController {
    
    override func viewDidLoad() {

        self.view.backgroundColor = .blue
        
        self.testUIViewPaneSide()
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeLeft, UIInterfaceOrientationMask.landscapeRight]
    }
    
    private func testUILabelWithInsetsAndCenteredCircle() {
        
        self.view.backgroundColor = .red
        
        let label1 = UILabelWithInsetsAndCenteredCircle()
        
        label1.circle.radius    = 48
        label1.circle.fillColor = UIColor(white:1, alpha:0.6).cgColor
        label1.attributedText   = "\u{226B}" | UIColor.white | UIFont.systemFont(ofSize: 64)
        label1.textAlignment    = .center
        //        label1.insets.left += 14
        label1.insets.bottom   += 8
        
        self.view.addSubview(label1)
        
        label1          .translatesAutoresizingMaskIntoConstraints = false
        label1          .centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label1          .centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        label1          .widthAnchor.constraint(equalToConstant: label1.circle.radius).isActive = true
        label1          .heightAnchor.constraint(equalToConstant: label1.circle.radius).isActive = true
    }
    
    private func testUILabelWithRectangularBackground() {

        self.view.backgroundColor = UIColor(rgba: [0.5,0.8,0.6,1])
        
        let label1 = UILabel()
        
        label1.backgroundColor = .clear
        label1.attributedText = "  TITLE  "
//            | (name:NSBackgroundColorAttributeName, value:UIColor.black)
            | (name:NSForegroundColorAttributeName, value:UIColor.white)
            | UIFont.systemFont(ofSize: 48)
        
        label1.sizeToFit()
        
        label1.layer.borderWidth = 1
        label1.layer.borderColor = UIColor.white.cgColor
        
        self.view.addSubview(label1)
        
        label1          .translatesAutoresizingMaskIntoConstraints = false
        label1          .centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label1          .centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func testUIViewPane1() {
        // tap on view to open pane
        // tap on pane to close pane
        
        let pane1 = UIView()
        
        pane1.backgroundColor = .orange
        
        let bounds = UIScreen.main.bounds
        
        pane1.frame = CGRect(x: bounds.maxX, y: bounds.minY, width: bounds.width * 0.33, height: bounds.height)
        
//        pane1.layer.borderColor = UIColor.white.cgColor
//        pane1.layer.borderWidth = 0.5
        
        let label1 = UILabel()

        pane1.addSubview(label1)
        
        label1.attributedText = " LABEL 1 " | UIColor.white | UIFont.systemFont(ofSize: 32)
        label1.layer.borderWidth = 1
        label1.layer.borderColor = UIColor(white:1, alpha:0.7).cgColor
        label1.translatesAutoresizingMaskIntoConstraints=false
        label1.centerXAnchor.constraint(equalTo: pane1.centerXAnchor).isActive=true
        label1.centerYAnchor.constraint(equalTo: pane1.centerYAnchor).isActive=true

        self.view.addSubview(pane1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.transition(with: pane1,
                              duration: 0.5,
                              options: [
                                UIViewAnimationOptions.curveEaseOut,
                ],
                              animations: {
                                pane1.frame.origin.x = self.view.frame.maxX - pane1.frame.width
            },
                              completion: { flag in
                                print("done")
            }
                              )
        }
        
//        panel.size(from:bounds, width:0.33, height:1.0)
//        pane1.align(from:bounds, x:1.0, y:1.0)
        

        
    }
    
    private func testUIViewGroupValueHue() {
        
    }
    
    private func testUIViewPaneSide() {
        
        self.view.backgroundColor = .lightGray
        
        let pane = UIViewPaneSide.create(on:self.view, side:.right, length:400)
        
        pane.backgroundColor = .darkGray
        
        pane.set(title      : " TITLE " | UIColor.white | UIFont.systemFont(ofSize: 16),
                 side       : .bottom,
                 border     : UIViewBorderParameters(thickness:1,color:UIColor.white,insets:2))
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
            let _ = pane.open(duration:3) { flag in
                print("opened, \(flag)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    let _ = pane.close(duration:1) { flag in
                        print("closed, \(flag)")
                    }
                }
            }
        }
    }

    
}
