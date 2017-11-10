//
//  UITextField_Extension.swift
//  FastLive
//
//  Created by Amrit Singh on 9/22/17.
//  Copyright © 2017 iphoneSolution. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func loadDropdownData(data: [String]) {
        self.inputView = MyPickerView(pickerData: data, dropdownField: self)
    }
    
    func loadDropdownData(data: [String], onSelect selectionHandler : @escaping (_ selectedText: String) -> Void) {
        self.inputView = MyPickerView(pickerData: data, dropdownField: self, onSelect: selectionHandler)
    }
}

class MyPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    var pickerData : [String]!
    var pickerTextField : UITextField!
    var selectionHandlerr : ((_ selectedText: String) -> Void)?
    
    init(pickerData: [String], dropdownField: UITextField) {
        super.init(frame: .zero)
        
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.main.async(execute: {
            if pickerData.count > 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        })
        
        if self.pickerTextField.text != nil && self.selectionHandlerr != nil
        {
            selectionHandlerr!(self.pickerTextField.text!)
        }
    }
    
    convenience init(pickerData: [String], dropdownField: UITextField, onSelect selectionHandler : @escaping (_ selectedText: String) -> Void)
    {
        self.init(pickerData: pickerData, dropdownField: dropdownField)
        self.selectionHandlerr = selectionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return pickerData[row].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let component = pickerData[row]
        selectionHandlerr!(component)
    }
    
//    // Sets number of columns in picker view
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//    return 1
//    }
    
//    // Sets the number of rows in the picker view
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//    return pickerData.count
//    }
}
