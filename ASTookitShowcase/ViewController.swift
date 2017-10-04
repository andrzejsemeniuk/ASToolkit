//
//  ViewController.swift
//  ASTookitShowcase
//
//  Created by andrzej semeniuk on 8/29/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import UIKit
import ASToolkit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if false {
            let picker = GenericControllerOfPickerOfColor()
            picker.rowHeight = 80
            let colors:[[UIColor]] = [
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.gray],
                ]
            picker.flavor = .matrixOfSolidCircles(selected: .white, colors: colors, diameter: 60, space: 16)
        }
        else if true {
            
            // display, controls, storage
            // display = circle, 2 circles, fill, custom, text on bg
            
            let picker = GenericPickerOfColor.create(withComponents: [
                .colorDisplay           (height:64,kind:.dot),
                //                .sliderRed              (height:16),
                //                .sliderGreen            (height:16),
                //                .sliderBlue             (height:16),
                .sliderAlpha            (height:32),
                .sliderHue              (height:16),
                .sliderSaturation       (height:16),
                .sliderBrightness       (height:16),
                //                .sliderCyan             (height:32),
                //                .sliderMagenta          (height:32),
                //                .sliderYellow           (height:32),
                //                .sliderKey              (height:32),
                .storageDots            (radius:16, columns:6, rows:3, colors:[.white,.gray,.black,.orange,.red,.blue,.green,.yellow])
                ])
            picker.frame = UIScreen.main.bounds
            self.view = picker
            picker.backgroundColor = UIColor(white:0.95)
            picker.handler = { color in
                print("new color\(color)")
            }
            picker.set(color:UIColor(rgb:[0.64,0.13,0.78]), animated:true)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

