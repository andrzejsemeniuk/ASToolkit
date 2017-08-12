//
//  GenericControllerOfList
//  ASToolkit
//
//  Created by Andrzej Semeniuk on 3/25/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

// TODO: CONTROLLER: ADD ABILITY TO ADD SECTIONS WITH OPTIONAL HEADER/FOOTER
// TODO: ADD ABILITY TO SPECIFY IF INDEX-PATH IS EDITABLE

open class GenericControllerOfList : UITableViewController
{
    public struct Section {
        var header                  : String?
        var footer                  : String?
        var items                   : [String]
        
        public init(header:String? = nil,
                    footer:String? = nil,
                    items :[String]) {
            self.header = header
            self.footer = footer
            self.items  = items
        }
    }
    
    
    public var style                               = UITableViewStyle.plain

    public var sections:[Section]                  = []
    
    public var selected:String!                    = nil
    
    public var handlerForCellForRowAtIndexPath     : ((_ controller:GenericControllerOfList,_ indexPath:IndexPath) -> UITableViewCell)! = nil
    
    public var handlerForDidSelectRowAtIndexPath   : ((_ controller:GenericControllerOfList,_ indexPath:IndexPath) -> Void)! = nil
    
    public var handlerForCommitEditingStyle        : ((_ controller:GenericControllerOfList,_ commitEditingStyle:UITableViewCellEditingStyle,_ indexPath:IndexPath) -> Bool)! = nil
    
    public var handlerForIsEditableAtIndexPath     : ((_ controller:GenericControllerOfList,_ indexPath:IndexPath) -> Bool)! = nil

    
    public var colorForHeaderText                  : UIColor? = .lightGray
    
    public var colorForFooterText                  : UIColor? = .lightGray
    

    
    
    
    override open func viewDidLoad()
    {
        tableView                   = UITableView(frame:tableView.frame,style:style)
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        //        tableView.separatorStyle    = .None

        super.viewDidLoad()
    }
    
    override open func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    open func item(at:IndexPath) -> String? {
        return sections[safe:at.section]?.items[safe:at.item]
    }
    
    open var items:[String] {
        get {
            return sections.flatMap { $0.items }
        }
        set (newValue) {
            sections = [
                Section(
                    header : nil,
                    footer : nil,
                    items  : newValue
                )
            ]
        }
    }
    
    override open func numberOfSections              (in: UITableView) -> Int
    {
        return sections.count
    }
    
    override open func tableView                     (_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[safe:section]?.header
    }
    
    override open func tableView                     (_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return sections[safe:section]?.footer
    }
    
    override open func tableView                     (_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            if let color = colorForHeaderText {
                view.textLabel?.textColor = color
            }
        }
        
    }
    
    override open func tableView                     (_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            if let color = colorForFooterText {
                view.textLabel?.textColor = color
            }
        }
        
    }

    override open func tableView                     (_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    {
        if 0 < indexPath.row {
            //            return 1
        }
        return 0
    }
    
    override open func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[safe:section]?.items.count ?? 0
    }
    
    override open func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if handlerForCellForRowAtIndexPath != nil {
            return handlerForCellForRowAtIndexPath(self,indexPath)
        }
        
        let name = sections[indexPath.section].items[indexPath.row]
        
        let cell = UITableViewCell(style:.default,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
            label.text = name
        }
        
        cell.selectionStyle = .default
        
        if selected != nil && selected == name {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    
    
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if handlerForDidSelectRowAtIndexPath != nil {
            handlerForDidSelectRowAtIndexPath(self,indexPath)
        }
    }
    
    
    override open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.handlerForIsEditableAtIndexPath?(self,indexPath) ?? true
    }
    
    override open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if handlerForCommitEditingStyle != nil {
            if handlerForCommitEditingStyle(self,editingStyle,indexPath) {
                switch editingStyle
                {
                case .none:
                    print("None")
                case .delete:
                    sections[indexPath.section].items.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath as IndexPath], with:.left)
                case .insert:
                    print("Add")
                }
                
            }
        }
    }
    
    
    
    
    
    override open func viewWillAppear(_ animated: Bool)
    {
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    
    
    
    
    
    
}
