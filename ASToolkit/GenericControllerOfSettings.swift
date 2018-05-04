//
//  GenericControllerOfSettings.swift
//  ASToolkit
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
    
    
    
    
    
    var actions                             : [IndexPath : Action]                  = [:]
    var updates                             : [Update]                              = []
    
    var registeredUISwitches                : [UISwitch : FunctionUpdateOnUISwitch] = [:]
    var registeredUISliders                 : [UISlider : FunctionUpdateOnUISlider] = [:]
    var registeredUITextFields:[UITextField : FunctionUpdateOnUITextField]          = [:]
    
    var registeredIds                       : [String   : IndexPath]                = [:]
    
    
    
    
    open weak var manager                   : GenericManagerOfSettings?
    
    
    public struct Section {
        public var header                   : String?
        public var footer                   : String?
        public var cells                    : [FunctionOnCell]
        
        public init(header:String? = nil,
                    footer:String? = nil,
                    cells :[FunctionOnCell]? = nil) {
            self.header = header
            self.footer = footer
            self.cells  = cells ?? []
        }
    }
    
    open var sections                       : [Section]                             = []
    
    open func row(at:IndexPath) -> FunctionOnCell? {
        return sections[safe:at.section]?.cells[safe:at.item]
    }
    
    open var elementCornerRadius            : CGFloat                               = 4
    open var elementCornerSide              : CGFloat                               = 24
    open var elementBackgroundColor         : UIColor                               = UIColor(white:1,alpha:0.3)
    
    open var colorForHeaderText             : UIColor?
    open var colorForFooterText             : UIColor?
    
    open var fontForHeaderText              : UIFont?
    open var fontForFooterText              : UIFont?
    open var fontForLabelText               : UIFont?
    open var fontForFieldText               : UIFont?

    
    static open var lastOffsetY             : [String:CGPoint]                      = [:]
    
    
    
    
    
    // MARK: - PRIVATE METHODS
    
    // MARK: - OPEN METHODS
    
    open func createSections() -> [Section]
    {
        return [Section]()
    }
    
    
    
    // MARK: - UIViewController
    
    
    open func reload()
    {
        tableView.reloadData()
    }
    
    override open func viewDidLoad()
    {
        tableView = UITableView(frame:tableView.frame, style:.grouped)
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool)
    {
        registeredIds.removeAll()
        registeredUISliders.removeAll()
        registeredUISwitches.removeAll()
        
        updates.removeAll()
        
        actions.removeAll()
        
        sections = createSections()
        
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
        
        registeredIds.removeAll()
        registeredUISliders.removeAll()
        registeredUISwitches.removeAll()
        
        for update in updates {
            update()
        }
        
        updates.removeAll()
        
        sections.removeAll()
        
        actions.removeAll()
        
        manager?.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    
    
    
    
    // MARK: - UITableView
    
    override open func numberOfSections              (in: UITableView) -> Int
    {
        return sections.count
    }
    
    override open func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section].cells.count
    }
    
    override open func tableView                     (_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[safe:section]?.header
    }
    
    override open func tableView                     (_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return sections[safe:section]?.footer
    }
    
    override open func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style:.value1, reuseIdentifier:nil)
        
        cell.selectionStyle = .none
        
        if let HSBA = cell.backgroundColor?.HSBA {
            if 1 <= HSBA.alpha {
                cell.backgroundColor = cell.backgroundColor!.withAlphaComponent(0.50)
            }
        }
        else {
            cell.backgroundColor = UIColor(white:1,alpha:0.7)
        }
        
        sections[indexPath.section].cells[indexPath.row](cell,indexPath)
        
        return cell
    }
    
    
    
    
    
    
    override open func tableView                     (_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            if let color = colorForHeaderText {
                view.textLabel?.textColor = color
            }
            view.textLabel?.font          = fontForHeaderText ?? view.textLabel?.font
        }
        
    }
    
    
    override open func tableView                     (_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            if let color = colorForFooterText {
                view.textLabel?.textColor = color
            }
            view.textLabel?.font          = fontForFooterText ?? view.textLabel?.font
        }
        
    }
    
    
    
    
    
    // MARK: - Ids
    
    open func register                          (indexPath:IndexPath, id:String?) {
        if let id = id {
            self.registeredIds[id] = indexPath
        }
    }
    
    open func cell                              (withId id:String) -> UITableViewCell? {
        if let indexPath = self.registeredIds[id] {
            return self.tableView.cellForRow(at: indexPath)
        }
        return nil
    }
    
    
    
    
    // MARK: - Actions
    
    open func addAction                         (indexPath:IndexPath, action:@escaping Action) {
        actions[indexPath] = action
    }
    
    open func registerCellSelection             (indexPath:IndexPath, action:@escaping Action) {
        addAction(indexPath: indexPath,action:action)
    }
    
    override open func tableView                (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let action = actions[indexPath] {
            action()
        }
    }
    
    
    
    
    
    // MARK: - Updates
    
    open func addUpdate                         (update:@escaping Update) {
        updates.append(update)
    }
    
    
    
    
    
    
    
    // MARK: - CREATE CELL - TAP
    
    open func createCellForTap                      (id:String? = nil, title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                setup?(cell,indexPath)
                if let action = action {
                    self?.addAction(indexPath: indexPath, action: action)
                }
            }
        }
        
    }
    
    
    open func createCellForTapOnQuestion            (id:String? = nil, title:String, message:String, ok:String = "Ok", cancel:String = "Cancel", setup:((UITableViewCell,IndexPath)->())? = nil, action:Action? = nil) -> FunctionOnCell {
        
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                setup?(cell,indexPath)
                self?.addAction(indexPath: indexPath) {
                    self?.createAlertForQuestion(title: title.trimmed(), message: message.trimmed(), ok:ok, cancel:cancel) {
                        action?()
                    }
                }
            }
        }
        
    }
    
    open func createCellForTapOnInput               (id:String? = nil, title:String, message:String, ok:String = "Ok", cancel:String = "Cancel", setup:((UITableViewCell,IndexPath)->())? = nil, value:@escaping ()->String, action:@escaping (String)->()) -> FunctionOnCell {
        
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                setup?(cell,indexPath)
                self?.addAction(indexPath: indexPath) {
                    self?.createAlertForInput(title: title.trimmed(), message: message.trimmed(), value:value(), ok:ok, cancel:cancel) { result in
                        action(result)
                    }
                }
            }
        }
        
    }
    
    open func createCellForTapOnChoice              (id:String? = nil, title:String, message:String, choices:@escaping ()->([String]), cancel:String = "Cancel", setup:((UITableViewCell,IndexPath)->())? = nil, action:@escaping (String)->()) -> FunctionOnCell {
        
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                setup?(cell,indexPath)
                self?.addAction(indexPath: indexPath) {
                    self?.createAlertForChoice(title: title.trimmed(), message: message.trimmed(), choices:choices(), cancel:cancel) { result in
                        action(result)
                    }
                }
            }
        }
        
    }
    
    open func createCellForTapOnRevolvingChoices    (value:@escaping ()->String, id:String? = nil, title:String, choices:[String], setup:((UITableViewCell,IndexPath)->())? = nil, action:((String)->())? = nil) -> FunctionOnCell {
        
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                let accessory       = UILabel()
                cell.accessoryView  = accessory
                accessory.text      = value()
                accessory.font      = self?.fontForLabelText ?? label.font
                accessory.sizeToFit()
                setup?(cell,indexPath)
                self?.addAction(indexPath: indexPath) {
                    accessory.text = choices.next(after:accessory.text!) ?? value()
                    accessory.sizeToFit()
                    action?(accessory.text!)
                }
            }
        }
        
    }
    
    open func createCellForTapOnRevolvingChoices    (_ setting:GenericSetting<String>, id:String? = nil, title:String, choices:[String], setup:((UITableViewCell,IndexPath)->())? = nil, action:((String)->())? = nil) -> FunctionOnCell {
        return createCellForTapOnRevolvingChoices(value     : { [weak setting] in
            return setting?.value ?? ""
        },
                                                  id        : id,
                                                  title     : title,
                                                  choices   : choices,
                                                  setup     : setup,
                                                  action    : { [weak setting] string in
                                                    setting?.value = string
                                                    action?(string)
        })
    }
    
    
    
    
    
    
    
    
    // MARK: - CREATE CELL - UISwitch
    
    open func registerUISwitch                  (id:String? = nil, indexPath:IndexPath, on:Bool, animated:Bool = true, update:@escaping FunctionUpdateOnUISwitch) -> UISwitch {
        let view = UISwitch()
        view.setOn(on, animated:animated)
        registeredUISwitches[view] = update
        register(indexPath:indexPath, id:id)
        view.addTarget(self, action:#selector(GenericControllerOfSettings.handleUISwitch(control:)),for:.valueChanged)
        return view
    }
    
    @objc open func handleUISwitch                    (control:UISwitch?) {
        if let myswitch = control, let update = registeredUISwitches[myswitch] {
            update(myswitch)
        }
    }
    
    open func createCellForUISwitch             (_ setting  : GenericSetting<Bool>,
                                                 id         : String? = nil,
                                                 title      : String,
                                                 exclusive  : [Weak<GenericSetting<Bool>>]? = nil,
                                                 setup      : ((UITableViewCell,IndexPath)->())? = nil,
                                                 action     : ((Bool)->())? = nil ) -> FunctionOnCell {
        
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                setup?(cell,indexPath)
                cell.accessoryView  = self?.registerUISwitch(id:id, indexPath:indexPath, on: setting.value, update: { [weak setting] (myswitch:UISwitch) in
                    guard let `setting` = setting else { return }
                    setting.value = myswitch.isOn
                    if setting.value {
                        exclusive?.filter { $0.value != nil && $0.value! !== setting }.map { $0.value! }.forEach { $0.value = false }
                    }
                    action?(setting.value)
                })
            }
        }
        
    }
    
    
    
    
    // MARK: - CREATE CELL - UISlider
    
    open func registerUISlider                  (id:String? = nil, indexPath:IndexPath, value:Float, minimum:Float = 0, maximum:Float = 1, continuous:Bool = false, animated:Bool = true, update:@escaping FunctionUpdateOnUISlider) -> UISlider {
        let view = UISlider()
        view.minimumValue   = minimum
        view.maximumValue   = maximum
        view.isContinuous   = continuous
        view.value          = value
        register(indexPath:indexPath, id:id)
        registeredUISliders[view] = update
        view.addTarget(self, action:#selector(GenericControllerOfSettings.handleUISlider(control:)),for:.valueChanged)
        return view
    }
    
    @objc open func handleUISlider                    (control:UISlider?) {
        if let myslider = control, let update = registeredUISliders[myslider] {
            update(myslider)
        }
    }
    
    open func createCellForUISlider             (_ setting:GenericSetting<Float>, id:String? = nil, title:String, minimum:Float = 0, maximum:Float = 1, continuous:Bool = false, setup:((UITableViewCell,IndexPath,UISlider)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            guard let `self` = self else { return }
            if let label = cell.textLabel {
                label.text          = title
                label.font          = self.fontForLabelText ?? label.font
                cell.accessoryType  = .none
                cell.selectionStyle = .default
                let view = self.registerUISlider(id:id, indexPath:indexPath, value: setting.value, minimum:minimum, maximum:maximum, continuous:continuous, update: { (myslider:UISlider) in
                    setting.value = myslider.value
                    action?()
                })
                cell.accessoryView  = view
                setup?(cell,indexPath,view)
            }
        }
    }
    
    open func createCellForUISlider             (_ setting:GenericSetting<CGFloat>, id:String? = nil, title:String, minimum:Float = 0, maximum:Float = 1, continuous:Bool = false, setup:((UITableViewCell,IndexPath,UISlider)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            guard let `self` = self else { return }
            if let label = cell.textLabel {
                label.text          = title
                label.font          = self.fontForLabelText ?? label.font
                cell.accessoryType  = .none
                cell.selectionStyle = .default
                let view = self.registerUISlider(id:id, indexPath:indexPath, value: Float(setting.value), minimum:minimum, maximum:maximum, continuous:continuous, update: { (myslider:UISlider) in
                    setting.value = CGFloat(myslider.value)
                    action?()
                })
                cell.accessoryView  = view
                setup?(cell,indexPath,view)
            }
        }
    }
    
    
    
    
    
    // MARK: - CREATE CELL - UITextField
    
    open func registerUITextField               (id:String? = nil, indexPath:IndexPath, count:Int, value:String, animated:Bool = true) -> UITextField {
        let view = UITextField()
        view.isEnabled = false
        view.layer.cornerRadius = self.elementCornerRadius
        view.text = value
        view.font = self.fontForFieldText ?? view.font
        view.textAlignment = .right
        view.textColor = .gray
        view.frame.size = (String.init(repeating:"m", count:count) as NSString).size(withAttributes: [
            NSAttributedStringKey.font : view.font ?? UIFont.defaultFont
            ])
        register(indexPath:indexPath, id:id)
        return view
    }
    
    open func createCellForUITextFieldAsString  (_ setting:GenericSetting<String>, id:String? = nil, title:String, count:Int = 8, message:String = "Enter text", setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel, let field = self?.registerUITextField(id:id, indexPath:indexPath, count:count, value: setting.value) {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                cell.accessoryView  = field
                setup?(cell,indexPath,field)
                self?.register(indexPath: indexPath, id: id)
                self?.addAction(indexPath: indexPath) { [weak self] in
                    self?.createAlertForUITextField(field, title:title, message:message) { text in
                        setting.value   = text
                        action?()
                        field.text      = setting.value
                    }
                }
                
            }
        }
    }
    
    open func createCellForUITextFieldAsDouble  (_ setting:GenericSetting<Double>, id:String? = nil, title:String, count:Int = 8, message:String = "Enter a number", minimum:Double? = nil, maximum:Double? = nil, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel, let field = self?.registerUITextField(id:id, indexPath:indexPath, count:count, value: String(setting.value)) {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                cell.accessoryView  = field
                setup?(cell,indexPath,field)
                self?.register(indexPath: indexPath, id: id)
                self?.addAction(indexPath: indexPath) {
                    self?.createAlertForUITextField(field, title:title, message:message) { [weak field] text in
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
    
    open func createCellForUITextFieldAsCGFloat (_ setting:GenericSetting<CGFloat>, id:String? = nil, title:String, count:Int = 8, message:String = "Enter a number", minimum:CGFloat? = nil, maximum:CGFloat? = nil, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel, let field = self?.registerUITextField(id:id, indexPath:indexPath, count:count, value: String(describing: setting.value)) {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                cell.accessoryView  = field
                setup?(cell,indexPath,field)
                self?.register(indexPath: indexPath, id: id)
                self?.addAction(indexPath: indexPath) {
                    self?.createAlertForUITextField(field, title:title, message:message) { [weak field] text in
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
    
    open func createCellForUITextFieldAsFloat   (_ setting:GenericSetting<Float>, id:String? = nil, title:String, count:Int = 8, message:String = "Enter a number", minimum:Float? = nil, maximum:Float? = nil, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel, let field = self?.registerUITextField(id:id, indexPath:indexPath, count:count, value: String(describing: setting.value)) {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                cell.accessoryView  = field
                setup?(cell,indexPath,field)
                self?.register(indexPath: indexPath, id: id)
                self?.addAction(indexPath: indexPath) {
                    self?.createAlertForUITextField(field, title:title, message:message) { [weak field] text in
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
    
    open func createCellForUITextFieldAsInt     (_ setting:GenericSetting<Int>, id:String? = nil, title:String, count:Int = 8, message:String = "Enter an integer value", minimum:Int? = nil, maximum:Int? = nil, setup:((UITableViewCell,IndexPath,UITextField)->())? = nil, action:Action? = nil ) -> FunctionOnCell {
        return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
            if let label = cell.textLabel, let field = self?.registerUITextField(id:id, indexPath:indexPath, count:count, value: String(describing: setting.value)) {
                cell.selectionStyle = .default
                label.text          = title
                label.font          = self?.fontForLabelText ?? label.font
                cell.accessoryView  = field
                setup?(cell,indexPath,field)
                self?.register(indexPath: indexPath, id: id)
                self?.addAction(indexPath: indexPath) {
                    self?.createAlertForUITextField(field, title:title, message:message) { [weak field] text in
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
    
    open func createCellForUIFontName           (_ font0:String, id:String? = nil, name:String = "Font", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:((String)->())? = nil) -> FunctionOnCell
    {
        return
            { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
                if let label = cell.textLabel {
                    
                    label.text          = name
                    label.font          = self?.fontForLabelText ?? label.font
                    if let detail = cell.detailTextLabel {
                        detail.text = font0
                    }
                    cell.selectionStyle = .default
                    cell.accessoryType  = .disclosureIndicator
                    
                    setup?(cell,indexPath)
                    
                    self?.register(indexPath: indexPath, id: id)
                    self?.addAction(indexPath: indexPath) {
                        
                        let fonts       = GenericControllerOfPickerOfFont()
                        fonts.title     = title + " Font"
                        fonts.selected  = font0
                        fonts.update    = {
                            action?(fonts.selected)
                        }
                        
                        self?.navigationController?.pushViewController(fonts, animated:true)
                    }
                }
        }
    }
    
    open func createCellForUIFontName           (_ font0:GenericSetting<String>, id:String? = nil, name:String = "Font", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:(()->())? = nil) -> FunctionOnCell {
        return createCellForUIFontName(font0.value, id:id, name:name, title:title, setup:setup, action: { name in
            font0.value = name
            action?()
        })
    }
    
    open func createCellForUIFont               (_ font0:GenericSetting<UIFont>, id:String? = nil, name:String = "Font", title:String, setup:((UITableViewCell,IndexPath)->())? = nil, action:(()->())? = nil) -> FunctionOnCell {
        return createCellForUIFontName(font0.value.fontName, id:id, name:name, title:title, setup:setup, action: { name in
            if let font = UIFont(name:name, size:font0.value.pointSize) {
                font0.value = font
            }
            action?()
        })
    }
    
    
    
    
    
    
    
    // MARK: - CREATE CELL - UIColor
    
    open func createCellForUIColor              (_ color0       : UIColor,
                                                 id             : String? = nil,
                                                 title          : String,
                                                 setup          : ((UITableViewCell,IndexPath)->())? = nil,
                                                 setupForPicker : ((GenericControllerOfPickerOfColor)->())? = nil,
                                                 action         : ((UIColor)->())? = nil) -> FunctionOnCell
    {
        return
            { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
                guard let `self` = self else { return }
                
                if let label = cell.textLabel {
                    
                    label.text          = title
                    label.font          = self.fontForLabelText

                    if let detail = cell.detailTextLabel {
                        detail.text     = "  "
                        
                        let view = UIView()
                        
                        view.frame              = CGRect(x:-16,y:-2,width:self.elementCornerSide,height:self.elementCornerSide)
                        view.layer.cornerRadius = self.elementCornerRadius
                        view.backgroundColor    = color0
                        
                        detail.addSubview(view)
                    }
                    cell.selectionStyle = .default
                    cell.accessoryType  = .disclosureIndicator
                    
                    self.register(indexPath: indexPath, id: id)
                    setup?(cell,indexPath)
                    self.addAction(indexPath: indexPath) { [weak self] in
                        
                        guard let `self` = self else { return }
                        
                        let picker                                      = GenericControllerOfPickerOfColor()
                        picker.tableView.backgroundColor                = color0
                        picker.tableView.showsVerticalScrollIndicator   = false
                        picker.title                                    = title.trimmed()
                        picker.selected                                 = color0
                        
                        setupForPicker?(picker)
                        
                        picker.update = { [weak picker] in
                            if let picker = picker {
                                action?(picker.selected)
                            }
                        }
                        
                        self.navigationController?.pushViewController(picker, animated:true)
                    }
                }
        }
    }
    
    open func createCellForUIColor              (_ setting      : GenericSetting<UIColor>,
                                                 id             : String? = nil,
                                                 title          : String,
                                                 setup          : ((UITableViewCell,IndexPath)->())? = nil,
                                                 setupForPicker : ((GenericControllerOfPickerOfColor)->())? = nil,
                                                 action         : (()->())? = nil) -> FunctionOnCell
    {
        return createCellForUIColor(setting.value, id:id, title:title, setup:setup, setupForPicker:setupForPicker, action:{ color in
            setting.value = color
            action?()
        })
    }
    
    
    
    

    open func createCellForUIColorWithGenericPickerOfColor
        (_ color0       : UIColor,
         id             : String? = nil,
         title          : String,
         setup          : ((UITableViewCell,IndexPath)->())? = nil,
         setupForPicker : ((GenericPickerOfColor)->())? = nil,
         action         : ((UIColor)->())? = nil) -> FunctionOnCell
    {
        return
            { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
                guard let `self` = self else { return }
                
                if let label = cell.textLabel {
                    
                    label.text          = title
                    label.font          = self.fontForLabelText
                    
                    if let detail = cell.detailTextLabel {
                        detail.text     = "  "
                        
                        let view = UIView()
                        
                        view.frame              = CGRect(x:-16,y:-2,width:self.elementCornerSide,height:self.elementCornerSide)
                        view.layer.cornerRadius = self.elementCornerRadius
                        view.backgroundColor    = color0
                        
                        detail.addSubview(view)
                    }
                    cell.selectionStyle = .default
                    cell.accessoryType  = .disclosureIndicator
                    
                    self.register(indexPath: indexPath, id: id)
                    setup?(cell,indexPath)
                    self.addAction(indexPath: indexPath) { [weak self] in
                        
                        guard let `self` = self else { return }
                        
                        let picker                                  = GenericPickerOfColor()
                        
                        let vc                                      = UIViewController()
                        
                        let scroll                                  = UIScrollView()
                        
                        scroll.contentInset.top                     = 0
                        scroll.contentInset.bottom                  = 0
                        scroll.showsVerticalScrollIndicator         = false
                        scroll.showsHorizontalScrollIndicator       = false
                        
                        scroll.addSubview(picker)

                        scroll.backgroundColor                      = .white
                        
                        picker.backgroundColor                      = .white
                        
                        vc.view                                     = scroll
                        vc.title                                    = title.trimmed()
                        
                        let viewColor                               = UIView(frame:CGRect(side:20))
                        viewColor.backgroundColor                   = color0
                        viewColor.layer.cornerRadius                = 10
                        vc.navigationItem.rightBarButtonItem        = UIBarButtonItem(customView: viewColor)


                        picker.clear(withLastColorArray: [color0], lastColorIndex: 0)
                        
                        setupForPicker?(picker)
                        
                        picker.constrainTopLeftCornerToSuperview()
                        picker.constrainWidthToSuperview()
                        picker.set(color: color0, dragging: false, animated: false)
                        
                        // IMPORTANT: DO NET SET handlerForColor
//                        picker.handlerForColor = { [weak picker] color,dragging,animated in
//                            if picker != nil, !dragging, !animated {
//                                action?(color)
//                            }
//                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        // hack: but it works -- need to set scroll content size, but can only do that once picker is laid out
                        DispatchQueue.main.async {
                            scroll.contentSize = picker.bounds.size
                        }
                    }
                }
        }
    }
    
    open func createCellForUIColorWithGenericPickerOfColor
        (_ setting      : GenericSetting<UIColor>,
         id             : String? = nil,
         title          : String,
         setup          : ((UITableViewCell,IndexPath)->())? = nil,
         setupForPicker : ((GenericPickerOfColor)->())? = nil,
         action         : (()->())? = nil) -> FunctionOnCell
    {
        return createCellForUIColorWithGenericPickerOfColor(setting.value, id:id, title:title, setup:setup, setupForPicker:setupForPicker, action:{ color in
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





