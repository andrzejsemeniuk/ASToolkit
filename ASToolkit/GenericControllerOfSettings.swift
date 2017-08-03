//
//  GenericControllerOfSettings.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/25/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

open class GenericControllerOfSettings : UITableViewController
{
    
    
    public typealias FunctionOnCell                         = (_ cell:UITableViewCell, _ indexPath:IndexPath) -> ()
    public typealias Update                                 = Action
    public typealias Action                                 = () -> ()
    public typealias FunctionUpdateOnUISwitch               = (UISwitch) -> ()
    public typealias FunctionUpdateOnUISlider               = (UISlider) -> ()
    public typealias FunctionUpdateOnUITextField            = (UITextField) -> ()
    
    
    
    
    struct Row {
        let function                : FunctionOnCell
    }
    
    struct Group {
        let title                   : String?
        let footer                  : String?
        let rows                    : [Row]
    }


    
    
    var actions                             : [IndexPath : Action]                  = [:]
    var updates                             : [Update]                              = []
    
    var registeredUISwitches                : [UISwitch : FunctionUpdateOnUISwitch] = [:]
    var registeredUISliders                 : [UISlider : FunctionUpdateOnUISlider] = [:]
    var registeredUITextFields:[UITextField : FunctionUpdateOnUITextField]          = [:]

    
    

    open weak var manager                   : GenericManagerOfSettings?
    
    
    open var rows                           : [[Any]]                               = []
    open var elementCornerRadius            : CGFloat                               = 4
    open var elementBackgroundColor         : UIColor                               = UIColor(white:1,alpha:0.3)
    open var colorForHeaderText             : UIColor?
    open var colorForFooterText             : UIColor?
    

    static open var lastOffsetY             : [String:CGPoint]                      = [:]
    
    
    
    
    
    // MARK: - PRIVATE METHODS
    
    // MARK: - OPEN METHODS
    
    open func createRows() -> [[Any]]
    {
        return [[Any]]()
    }
    

    
    // MARK: - UIViewController
    
    
    open func reload()
    {
        tableView.reloadData()
    }
    
    
    override open func viewWillAppear(_ animated: Bool)
    {
        registeredUISliders.removeAll()
        registeredUISwitches.removeAll()
        
        updates.removeAll()
        
        actions.removeAll()
        
        rows = createRows()
        
        reload()
        
        if let title = super.title {
            if let point = GenericControllerOfSettings.lastOffsetY[title] {
                tableView.setContentOffset(point,animated:true)
            }
        }
        
        super.viewWillAppear(animated)
        
    }
    
    
    override open func viewWillDisappear(_ animated: Bool)
    {
        if let title = super.title {
            GenericControllerOfSettings.lastOffsetY[title] = tableView.contentOffset
        }
        
        registeredUISliders.removeAll()
        registeredUISwitches.removeAll()
        
        for update in updates {
            update()
        }
        
        updates.removeAll()
        
        rows.removeAll()
        
        actions.removeAll()
        
        manager?.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    

    
    
    // MARK: - UITableView
    
    override open func numberOfSections              (in: UITableView) -> Int
    {
        return rows.count
    }
    
    override open func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section < rows.count ? rows[section].count-2 : 0
    }
    
    override open func tableView                     (_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if 0 < rows.count {
            if let text = rows[section].first as? String {
                return 0 < text.length ? text : nil
            }
        }
        return nil
    }
    
    override open func tableView                     (_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        if 0 < rows.count {
            if let text = rows[section].last as? String {
                return 0 < text.length ? text : nil
            }
        }
        return nil
    }
    
    override open func tableView                     (_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    {
        if 0 < indexPath.row {
            //            return 1
        }
        return 0
    }
    
    override open func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style:.value1,reuseIdentifier:nil)
        
        cell.selectionStyle = .none
        
        if let HSBA = cell.backgroundColor?.HSBA {
            if 1 <= HSBA.alpha {
                cell.backgroundColor = cell.backgroundColor!.withAlphaComponent(0.50)
            }
        }
        else {
            cell.backgroundColor = UIColor(white:1,alpha:0.7)
        }
        
        if 0 < rows.count {
            if let f = rows[indexPath.section][indexPath.row+1] as? FunctionOnCell {
                f(cell,indexPath)
            }
        }
        
        return cell
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
    

    
    
    
    
    // MARK: - Actions
    
    open func addAction(indexPath:IndexPath, action:@escaping Action) {
        actions[indexPath] = action
    }
    
    open func registerCellSelection(indexPath:IndexPath, action:@escaping Action) {
        addAction(indexPath: indexPath,action:action)
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let action = actions[indexPath] {
            action()
        }
    }
    
    
    
    
    
    // MARK: - Updates 
    
    open func addUpdate(update:@escaping Update) {
        updates.append(update)
    }
    
    
    
    
    
    
    // MARK: - CREATE CELL - TAP
    
    open func createCellForTap                      (title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                setup?(cell,indexPath)
                if let action = action {
                    self.addAction(indexPath: indexPath, action: action)
                }
            }
        }
        
    }
    

    open func createCellForTapOnQuestion            (title:String, message:String, ok:String = "Ok", cancel:String = "Cancel", setup:((UITableViewCell,IndexPath)->())? = nil, action:Action? = nil) -> FunctionOnCell {
        
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                setup?(cell,indexPath)
                self.addAction(indexPath: indexPath) { [weak self] in
                    self?.createAlertForQuestion(title: title, message: message, ok:ok, cancel:cancel) {
                        action?()
                    }
                }
            }
        }
        
    }
    

    
    open func createAlertForQuestion            (title:String, message:String, ok:String = "Ok", cancel:String = "Cancel", handler:@escaping Action) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction.init(title: ok, style: UIAlertActionStyle.default) { action in
            handler()
            alert.dismiss(animated: true) {
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction.init(title: cancel, style: UIAlertActionStyle.cancel) { action in
            alert.dismiss(animated: true) {
            }
        }
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    

    
    
    
    
    
    // MARK: - CREATE CELL - UISwitch
    
    open func registerUISwitch                  (on:Bool, animated:Bool = true, update:@escaping FunctionUpdateOnUISwitch) -> UISwitch {
        let view = UISwitch()
        view.setOn(on, animated:animated)
        registeredUISwitches[view] = update
        view.addTarget(self, action:#selector(GenericControllerOfSettings.handleUISwitch(control:)),for:.valueChanged)
        return view
    }
    
    open func handleUISwitch                    (control:UISwitch?) {
        if let myswitch = control, let update = registeredUISwitches[myswitch] {
            update(myswitch)
        }
    }
    
    open func createCellForUISwitch             (_ setting:GenericSetting<Bool>, title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:((Bool)->())? = nil ) -> FunctionOnCell {
        
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                setup?(cell,indexPath)
                cell.accessoryView  = self.registerUISwitch(on: setting.value, update: { (myswitch:UISwitch) in
                    setting.value = myswitch.isOn
                    action?(setting.value)
                })
            }
        }
        
    }
    
    
    
    
    // MARK: - CREATE CELL - UISlider
    
    open func registerUISlider                  (value:Float, minimum:Float = 0, maximum:Float = 1, continuous:Bool = false, animated:Bool = true, update:@escaping FunctionUpdateOnUISlider) -> UISlider {
        let view = UISlider()
        view.minimumValue   = minimum
        view.maximumValue   = maximum
        view.isContinuous   = continuous
        view.value          = value
        registeredUISliders[view] = update
        view.addTarget(self, action:#selector(GenericControllerOfSettings.handleUISlider(control:)),for:.valueChanged)
        return view
    }
    
    open func handleUISlider                    (control:UISlider?) {
        if let myslider = control, let update = registeredUISliders[myslider] {
            update(myslider)
        }
    }
    
    open func createCellForUISlider             (_ setting:GenericSetting<Float>, title:String, minimum:Float = 0, maximum:Float = 1, continuous:Bool = false, setup:((UITableViewCell,IndexPath,UISlider)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                label.text          = title
                cell.accessoryType  = .none
                cell.selectionStyle = .default
                let view = self.registerUISlider(value: setting.value, minimum:minimum, maximum:maximum, continuous:continuous, update: { (myslider:UISlider) in
                    setting.value = myslider.value
                    action?()
                })
                cell.accessoryView  = view
                setup?(cell,indexPath,view)
            }
        }
    }

    open func createCellForUISlider             (_ setting:GenericSetting<CGFloat>, title:String, minimum:Float = 0, maximum:Float = 1, continuous:Bool = false, setup:((UITableViewCell,IndexPath,UISlider)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                label.text          = title
                cell.accessoryType  = .none
                cell.selectionStyle = .default
                let view = self.registerUISlider(value: Float(setting.value), minimum:minimum, maximum:maximum, continuous:continuous, update: { (myslider:UISlider) in
                    setting.value = CGFloat(myslider.value)
                    action?()
                })
                cell.accessoryView  = view
                setup?(cell,indexPath,view)
            }
        }
    }

    
    
    
    
    // MARK: - CREATE CELL - UITextField
    
    open func registerUITextField               (count:Int, value:String, animated:Bool = true) -> UITextField {
        let view = UITextField()
        view.isEnabled = false
//        view.delegate = self
//        view.borderStyle = .line
//        view.layer.borderColor = UIColor.init(white:0,alpha:0.02).cgColor
//        view.layer.borderWidth = 1
//        view.backgroundColor = UIColor.init(white:1,alpha:0.2)
        view.layer.cornerRadius = self.elementCornerRadius
        view.text = value
        view.textAlignment = .right
        view.textColor = .gray
        view.frame.size = (String.init(repeating:"m", count:count) as NSString).size(attributes: [
            NSFontAttributeName : view.font ?? UIFont.defaultFont
            ])
        return view
    }
    
    open func createAlertForUITextField         (_ field:UITextField, title:String, message:String, setter:@escaping (String)->()) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { textfield in
            textfield.text = field.text
        }
        let ok = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default) { action in
            setter(alert.textFields?[safe:0]?.text ?? "")
            alert.dismiss(animated: true) {
            }
        }
        alert.addAction(ok)
        let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel) { action in
            alert.dismiss(animated: true) {
            }
        }
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    open func createCellForUITextFieldAsString  (_ setting:GenericSetting<String>, count:Int = 8, title:String, message:String = "Enter text", setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: setting.value)
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) { [weak self] in
                    self?.createAlertForUITextField(field, title:title, message:message) { text in
                        setting.value = text
                        action?()
                        field.text = setting.value
                    }
                }
                
            }
        }
    }

    open func createCellForUITextFieldAsDouble  (_ setting:GenericSetting<Double>, count:Int = 8, title:String, message:String = "Enter a number", minimum:Double? = nil, maximum:Double? = nil, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: String(setting.value))
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) {
                    self.createAlertForUITextField(field, title:title, message:message) { [weak field] text in
                        if var number = Double(text) {
                            if let minimum = minimum {
                                number = max(minimum,number)
                            }
                            if let maximum = maximum {
                                number = min(maximum,number)
                            }
                            setting.value = number
                            action?()
                            field?.text = String(setting.value)
                        }
                    }
                }

            }
        }
    }
    
    open func createCellForUITextFieldAsCGFloat (_ setting:GenericSetting<CGFloat>, count:Int = 8, title:String, message:String = "Enter a number", minimum:CGFloat? = nil, maximum:CGFloat? = nil, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: String(describing: setting.value))
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) {
                    self.createAlertForUITextField(field, title:title, message:message) { [weak field] text in
                        if var number = CGFloat(text) {
                            if let minimum = minimum {
                                number = max(minimum,number)
                            }
                            if let maximum = maximum {
                                number = min(maximum,number)
                            }
                            setting.value = number
                            action?()
                            field?.text = String(describing: setting.value)
                        }
                    }
                }
                
            }
        }
    }
    
    open func createCellForUITextFieldAsFloat   (_ setting:GenericSetting<Float>, count:Int = 8, title:String, message:String = "Enter a number", minimum:Float? = nil, maximum:Float? = nil, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: String(describing: setting.value))
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) {
                    self.createAlertForUITextField(field, title:title, message:message) { [weak field] text in
                        if var number = Float(text) {
                            if let minimum = minimum {
                                number = max(minimum,number)
                            }
                            if let maximum = maximum {
                                number = min(maximum,number)
                            }
                            setting.value = number
                            action?()
                            field?.text = String(describing: setting.value)
                        }
                    }
                }
                
            }
        }
    }
    
    open func createCellForUITextFieldAsInt     (_ setting:GenericSetting<Int>, count:Int = 8, title:String, message:String = "Enter an integer value", minimum:Int? = nil, maximum:Int? = nil, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                let field = self.registerUITextField(count:count, value: String(describing: setting.value))
                cell.accessoryView = field
                setup?(cell,indexPath,field)
                
                self.addAction(indexPath: indexPath) {
                    self.createAlertForUITextField(field, title:title, message:message) { [weak field] text in
                        if var number = Int(text) {
                            if let minimum = minimum {
                                number = max(minimum,number)
                            }
                            if let maximum = maximum {
                                number = min(maximum,number)
                            }
                            setting.value = number
                            action?()
                            field?.text = String(describing: setting.value)
                        }
                    }
                }
                
            }
        }
    }
    







    
    
    
    // MARK: - CREATE CELL - UIFont
    
    open func createCellForUIFontName           (_ font0:String, name:String = "Font", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:((String)->())? = nil) -> FunctionOnCell
    {
        return
            { (cell:UITableViewCell, indexPath:IndexPath) in
                if let label = cell.textLabel {
                    
                    label.text          = name
                    if let detail = cell.detailTextLabel {
                        detail.text = font0
                    }
                    cell.selectionStyle = .default
                    cell.accessoryType  = .disclosureIndicator
                    
                    setup?(cell,indexPath)
                    
                    self.addAction(indexPath: indexPath) { [weak self] in
                        
                        let fonts       = GenericControllerOfPickerOfFont()
                        fonts.title     = title+" Font"
                        fonts.selected  = font0
                        fonts.update    = {
                            action?(fonts.selected)
                        }
                        
                        self?.navigationController?.pushViewController(fonts, animated:true)
                    }
                }
        }
    }

    open func createCellForUIFontName           (_ font0:GenericSetting<String>, name:String = "Font", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:(()->())? = nil) -> FunctionOnCell {
        return createCellForUIFontName(font0.value, name:name, title:title, setup:setup, action: { name in
            font0.value = name
            action?()
        })
    }

    open func createCellForUIFont               (_ font0:GenericSetting<UIFont>, name:String = "Font", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:(()->())? = nil) -> FunctionOnCell {
        return createCellForUIFontName(font0.value.fontName, name:name, title:title, setup:setup, action: { name in
            if let font = UIFont(name:name, size:font0.value.pointSize) {
                font0.value = font
            }
            action?()
        })
    }
    
    
    
    
    
    
    
    // MARK: - CREATE CELL - UIColor
    
    open func createCellForUIColor              (_ color0:UIColor, title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:((UIColor)->())? = nil) -> FunctionOnCell
    {
        return
            { (cell:UITableViewCell, indexPath:IndexPath) in
                if let label = cell.textLabel {
                    
                    label.text          = title
                    if let detail = cell.detailTextLabel {
                        detail.text     = "  "
                        
                        let view = UIView()
                        
                        view.frame              = CGRect(x:-16,y:-2,width:24,height:24)
                        view.layer.cornerRadius = self.elementCornerRadius
                        view.backgroundColor    = color0
                        
                        detail.addSubview(view)
                    }
                    cell.selectionStyle = .default
                    cell.accessoryType  = .disclosureIndicator
                    
                    setup?(cell,indexPath)
                    
                    self.addAction(indexPath: indexPath) { [weak self] in
                        
                        let colors      = GenericControllerOfPickerOfColor()
                        colors.title    = title
                        colors.selected = color0
                        colors.update   = {
                            action?(colors.selected)
                        }
                        
                        self?.navigationController?.pushViewController(colors, animated:true)
                    }
                }
        }
    }
    
    open func createCellForUIColor              (_ setting:GenericSetting<UIColor>, title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:(()->())? = nil) -> FunctionOnCell {
        return createCellForUIColor(setting.value, title:title, setup:setup, action:{ color in
            setting.value = color
            action?()
        })
    }

    
    
    
    
    
    
    
    
    
    
}




extension GenericControllerOfSettings : UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        self.registeredUITextFields[textField]?(textField)
    }
    
}




