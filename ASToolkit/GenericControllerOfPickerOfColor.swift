//
//  GenericControllerOfColor
//  ASToolkit
//
//  Created by Andrzej Semeniuk on 3/25/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class GenericControllerOfPickerOfColor : UITableViewController
{
    public enum Flavor {
        case list                   (selected:UIColor, colors:[UIColor])
        case listOfSolidCircles     (selected:UIColor, colors:[[UIColor]], diameter:CGFloat, space:CGFloat)
        case listOfSolidSquares     (selected:UIColor, colors:[[UIColor]], side:CGFloat, space:CGFloat)
        case matrix                 (selected:UIColor, colors:[[UIColor]])
        case slidersForRGB          (selected:UIColor)
        case slidersForRGBA         (selected:UIColor)
        case slidersForHSB          (selected:UIColor)
        case slidersForHSBA         (selected:UIColor)
    }
    
    
    
    public var rowHeight    : CGFloat           = 44
    
    //    public var flavor       : Flavor            = .list(selected:.white, colors:GenericControllerOfPickerOfColor.generateListOfDefaultColors()) {
    
    public var flavor       : Flavor            = .listOfSolidCircles(selected  : .white,
                                                                      colors    : GenericControllerOfPickerOfColor.generateListOfDefaultColorsForCircles(),
                                                                      diameter  : 36,
                                                                      space     : 8)
        {
        didSet {
            
            switch flavor {
            case .list(let selected, let colors):
                self.selected = selected
            case .listOfSolidCircles(let selected, let colors, let diameter, let space):
                self.selected = selected
            case .listOfSolidSquares(let selected, let colors, let side, let space):
                self.selected = selected
            case .matrix(let selected, let colors):
                self.selected = selected
            case .slidersForHSB(let selected):
                self.selected = selected
            case .slidersForRGB(let selected):
                self.selected = selected
            case .slidersForHSBA(let selected):
                self.selected = selected
            case .slidersForRGBA(let selected):
                self.selected = selected
            }
            
            reload()
        }
    }
    
    private var buttons     : [AnyObject]       = []
    
    public var selected     : UIColor           = .white
    
    
    override open func viewDidLoad()
    {
        tableView.dataSource = self
        
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        reload()
        
        super.viewDidLoad()
    }
    
    
    
    
    static open func generateListOfDefaultColors() -> [UIColor] {
        
        var colors = [
            UIColor.GRAY(1.00,1),
            UIColor.GRAY(0.90,1),
            UIColor.GRAY(0.80,1),
            UIColor.GRAY(0.70,1),
            UIColor.GRAY(0.60,1),
            UIColor.GRAY(0.50,1),
            UIColor.GRAY(0.40,1),
            UIColor.GRAY(0.30,1),
            UIColor.GRAY(0.20,1),
            UIColor.GRAY(0.10,1),
            UIColor.GRAY(0.00,1),
            ]
        
        let hues        : [Float]   = [0,0.06,0.1,0.14,0.2,0.3,0.4,0.53,0.6,0.7,0.8,0.9]
        let saturations : [Float]   = [0.4,0.6,0.8,1]
        let values      : [Float]   = [1]
        
        for h in hues {
            for v in values {
                for s in saturations {
                    colors.append(UIColor.HSBA(h,s,v,1))
                }
            }
        }
        
        return colors
    }
    
    
    
    static open func generateListOfDefaultColorsForCircles() -> [[UIColor]] {
        
        var colors:[[UIColor]] = []
        
        colors.append(stride(from:1.0,to:0.5,by:-0.5/7.0).asArray.asArrayOfCGFloat.map { UIColor(white:$0) })
        colors.append(stride(from:0.0,to:0.5,by:0.5/7.0).asArray.asArrayOfCGFloat.map { UIColor(white:$0) })
        
        //        let hues        : [Float]   = [0,0.06,0.1,0.14,0.2,0.3,0.4,0.53,0.6,0.7,0.8,0.9]
        let hues        : [Float]   = stride(from:0.0,to:0.95,by:0.04).asArray.asArrayOfFloat
        let saturations : [Float]   = [0.15,0.28,0.42,0.58,0.7,0.84,1]
        let values      : [Float]   = [1]
        
        for h in hues {
            var row:[UIColor] = []
            for v in values {
                for s in saturations {
                    row.append(UIColor.HSBA(h,s,v,1))
                }
            }
            colors.append(row)
        }
        
        return colors
    }
    
    
    
    
    override open func numberOfSections      (in: UITableView) -> Int
    {
        return 1
    }
    
    override open func tableView             (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch flavor {
        case .list                  (_, let colors)             : return colors.count
        case .listOfSolidCircles    (_, let colors, _, _)       : return colors.count
        case .listOfSolidSquares    (_, let colors, _, _)       : return colors.count
        case .matrix                (_, let colors)             : return colors.count
        case .slidersForHSB                                     : return 3
        case .slidersForRGB                                     : return 3
        case .slidersForHSBA                                    : return 4
        case .slidersForRGBA                                    : return 4
        }
        return 0
    }
    
    override open func tableView             (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell
        
        cell = UITableViewCell(style:.default,reuseIdentifier:nil)
        
        
        switch flavor {
            
        case .list(let selected, let colors):
            
            let color = colors[indexPath.row]
            
            cell.backgroundColor = color
            
            cell.selectionStyle = .default
            
            if color.components_RGBA_UInt8_equals(selected) {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
            
        case .listOfSolidCircles(let selected, let colors, let diameter, let space):
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .equalSpacing
            stack.spacing = space
            
            for color in colors[indexPath.row] {
                let circle = UIButtonWithCenteredCircle(frame:CGRect(side:diameter))
                circle.circle(for: .normal).radius = diameter/2
                circle.circle(for: .normal).fillColor = color.cgColor
                circle.circle(for: .selected).radius = diameter/2+space/2
                circle.circle(for: .selected).fillColor = color.cgColor
                circle.widthAnchor.constraint(equalToConstant: diameter).isActive=true
                circle.heightAnchor.constraint(equalToConstant: diameter).isActive=true
                circle.addTarget(self, action: #selector(GenericControllerOfPickerOfColor.handleTapOnCircle(_:)), for: .touchUpInside)
                self.buttons.append(circle)
                stack.addArrangedSubview(circle)
                if color == self.selected {
                    circle.isSelected = true
                }
            }
            
            
            cell.contentView.backgroundColor = self.selected //UIColor(white:0.97) // TODO: ADD ASSOCIATED VALUE TO ENUM ?
            cell.contentView.addSubview(stack)
            
            stack.translatesAutoresizingMaskIntoConstraints=false
            stack.centerXAnchor.constraint(equalTo: stack.superview!.centerXAnchor).isActive=true
            stack.centerYAnchor.constraint(equalTo: stack.superview!.centerYAnchor).isActive=true
            
            break
            
        case .listOfSolidSquares(let selected, let colors, let side, let space):
            
            var views = [UIView]()
            for color in colors[indexPath.row] {
                let frame = CGRect(x:0,
                                   y:rowHeight/2-side/2,
                                   width:side/2,
                                   height:side/2)
                var circle = UIView(frame:frame)
                views.append(circle)
                circle.backgroundColor = color
            }
            
            let stack = UIStackView.init(arrangedSubviews: views)
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .equalSpacing
            
            cell.contentView.addSubview(stack)
            //            cell.backgroundColor = self.tableView.backgroundColor
            
            break
            
        case .matrix(let selected, let colors):
            break
            
        case .slidersForHSB(let selected):
            break
            
        case .slidersForRGB(let selected):
            break
            
        case .slidersForHSBA(let selected):
            break
            
        case .slidersForRGBA(let selected):
            break
            
        }
        
        return cell
    }
    
    
    
    
    open func handleTapOnCircle(_ control:UIControl) {
        
        if let button = control as? UIButtonWithCenteredCircle {
            self.selected = UIColor.init(cgColor:button.circle(for: .normal).fillColor ?? UIColor.clear.cgColor)
            for element in self.buttons {
                if let button = element as? UIButtonWithCenteredCircle {
                    let color = UIColor.init(cgColor:button.circle(for: .normal).fillColor ?? UIColor.clear.cgColor)
                    button.isSelected = color == self.selected
                }
            }
            self.update()
            self.reload()
        }
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    
    
    open func reload()
    {
        self.view.backgroundColor = self.selected
        self.buttons = []
        tableView.reloadData()
    }
    
    
    
    override open func viewWillAppear(_ animated: Bool)
    {
        reload()
        
        switch flavor {
        case .list(_, let colors):
            
            for (row,color) in colors.enumerated() {
                
                if color.components_RGBA_UInt8_equals(selected) {
                    
                    let path = IndexPath(row:row, section:0)
                    
                    tableView.scrollToRow(at: path as IndexPath,at:.middle,animated:true)
                    
                    break
                }
            }
            
        case .listOfSolidCircles(let selected, let colors, let diameter, let space):
            break
            
        case .listOfSolidSquares(let selected, let colors, let side, let space):
            break
            
        case .matrix(let selected, let colors):
            break
            
        case .slidersForHSB(let selected):
            break
            
        case .slidersForRGB(let selected):
            break
            
        case .slidersForHSBA(let selected):
            break
            
        case .slidersForRGBA(let selected):
            break
            
        }
        
        
        super.viewWillAppear(animated)
    }
    
    
    
    public var update: (() -> ()) = {}
    
    override open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch flavor {
        case .list(let selected, let colors):
            self.selected = colors[indexPath.row]
        case .listOfSolidCircles(let selected, let colors, let diameter, let space):
            return
        case .listOfSolidSquares(let selected, let colors, let side, let space):
            self.selected = selected
        case .matrix(let selected, let colors):
            self.selected = selected
        case .slidersForHSB(let selected):
            self.selected = selected
        case .slidersForRGB(let selected):
            self.selected = selected
        case .slidersForHSBA(let selected):
            self.selected = selected
        case .slidersForRGBA(let selected):
            self.selected = selected
        }
        
        
        reload()
        
        update()
    }
    
}
