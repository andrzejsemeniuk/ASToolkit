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
        case matrixOfSolidCircles   (selected:UIColor, colors:[[UIColor]], diameter:CGFloat, space:CGFloat)
        case matrixOfSolidSquares   (selected:UIColor, colors:[[UIColor]], side:CGFloat, space:CGFloat)
        case matrix                 (selected:UIColor, colors:[[UIColor]])
        case slidersForRGB          (selected:UIColor)
        case slidersForRGBA         (selected:UIColor)
        case slidersForHSB          (selected:UIColor)
        case slidersForHSBA         (selected:UIColor)
    }
    
    
    
    public var rowHeight    : CGFloat           = 44
    
    //    public var flavor       : Flavor            = .list(selected:.white, colors:GenericControllerOfPickerOfColor.generateListOfDefaultColors()) {
    
    public var flavor       : Flavor            = .matrixOfSolidCircles(selected  : .white,
                                                                        colors    : UIColor.generateMatrixOfColors(columns:5),
                                                                        diameter  : 36,
                                                                        space     : 8)
        {
        didSet {
            
            switch flavor {
            case .list(let selected, let colors):
                self.selected = selected
            case .matrixOfSolidCircles(let selected, let colors, let diameter, let space):
                self.selected = selected
            case .matrixOfSolidSquares(let selected, let colors, let side, let space):
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
    
    
    
    
//    typealias RowGenerator = (UITableViewCell)->()
//    
//    private var rows : [RowGenerator] = []
//
//    public var margin : CGFloat = 8 {
//        didSet {
//            self.tableView.scrollIndicatorInsets = UIEdgeInsets(all: margin)
//        }
//    }
//
//    open func clear() {
//        self.rows = []
//    }
//
//    open func addFlavor() {
//        
//    }
    
    
    override open func numberOfSections      (in: UITableView) -> Int
    {
        return 1
    }
    
    override open func tableView             (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch flavor {
        case .list                  (_, let colors)             : return colors.count
        case .matrixOfSolidCircles    (_, let colors, _, _)       : return colors.count
        case .matrixOfSolidSquares    (_, let colors, _, _)       : return colors.count
        case .matrix                (_, let colors)             : return colors.count
        case .slidersForHSB                                     : return 3
        case .slidersForRGB                                     : return 3
        case .slidersForHSBA                                    : return 4
        case .slidersForRGBA                                    : return 4
        }
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
            
        case .matrixOfSolidCircles(let selected, let colors, let diameter, let space):
            
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
            
        case .matrixOfSolidSquares(let selected, let colors, let side, let space):
            
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
            
        case .matrixOfSolidCircles(let selected, let colors, let diameter, let space):
            break
            
        case .matrixOfSolidSquares(let selected, let colors, let side, let space):
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
        case .matrixOfSolidCircles(let selected, let colors, let diameter, let space):
            return
        case .matrixOfSolidSquares(let selected, let colors, let side, let space):
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
