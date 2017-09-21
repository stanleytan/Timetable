//
//  CreateMenuViewController.swift
//  Timetable
//
//  Created by Stanley Tan on 7/7/17.
//  Copyright © 2017 Stanley Tan. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) || action == #selector(select(_:)) || action == #selector(selectAll(_:)) || action == #selector(delete(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}


extension UIProgressView {
    
    func animate(progress: Float) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.setProgress(progress, animated: true)
        }, completion: nil)
    }
}

class CreateMenuViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var scheduleNameTextField: UITextField!
    @IBOutlet weak var scheduleCommencementTextField: UITextField!
    @IBOutlet weak var scheduleIDTextField: UITextField!
    @IBOutlet weak var schedulePasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createScheduleButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var textFieldsCompletion : [Bool] = []
    var scheduleDate : String?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scheduleNameTextField.delegate = self
        scheduleNameTextField.tag = 0
        scheduleNameTextField.attributedPlaceholder = NSAttributedString(string: "Schedule Name", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.4)])
        scheduleNameTextField.autocorrectionType = .no
        scheduleNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        scheduleCommencementTextField.delegate = self
        scheduleCommencementTextField.tag = 1
        scheduleCommencementTextField.attributedPlaceholder = NSAttributedString(string: "Schedule Commencement", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.4)])
        scheduleCommencementTextField.autocorrectionType = .no
        scheduleCommencementTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        scheduleIDTextField.delegate = self
        scheduleIDTextField.tag = 2
        scheduleIDTextField.attributedPlaceholder = NSAttributedString(string: "Schedule ID", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.4)])
        scheduleIDTextField.autocorrectionType = .no
        scheduleIDTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        schedulePasswordTextField.delegate = self
        schedulePasswordTextField.tag = 3
        schedulePasswordTextField.attributedPlaceholder = NSAttributedString(string: "Schedule Password", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.4)])
        schedulePasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.tag = 4
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.4)])
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        createScheduleButton.alpha = 0
        createScheduleButton.isEnabled = false
        
        timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(selectScheduleName), userInfo: nil, repeats: false)
        
        
        for _ in 1...5 {
            textFieldsCompletion.append(false)
        }
        
        
        // Date picker for schedule commencement
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(CreateMenuViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        scheduleCommencementTextField.inputView = datePicker
        
        // Set today's date as default date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        formatter.timeStyle = DateFormatter.Style.none
        scheduleDate = formatter.string(from: NSDate() as Date)
        
        // Toolbar on the date picker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y : 0, width: self.view.frame.size.width, height: self.view.frame.size.height / 18))
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.tintColor = UIColor.white
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateMenuViewController.todayPressed(sender:)))
        let doneButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateMenuViewController.donePressed(sender:)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([todayButton, flexButton, doneButton], animated: true)
        scheduleCommencementTextField.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectScheduleName() {
        UIView.animate(withDuration: 0.5, animations: {
            self.scheduleNameTextField.becomeFirstResponder()
        })
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 20)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if(textField.hasText) {
            textFieldsCompletion[textField.tag] = true
        } else {
            textFieldsCompletion[textField.tag] = false
        }
        var progressTotal = Float(0)
        for index in 0...textFieldsCompletion.count - 1 {
            if(textFieldsCompletion[index]) {
                progressTotal += 1
            }
        }
        progressBar.animate(progress: progressTotal / Float(textFieldsCompletion.count))
        if(progressBar.progress == 1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.createScheduleButton.alpha = 1.0
            })
            self.createScheduleButton.isEnabled = true
        } else {
            self.createScheduleButton.isEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.createScheduleButton.alpha = 0.0
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so move to continue
            if(createScheduleButton.isEnabled) {
                createScheduleButton.sendActions(for: UIControlEvents.touchUpInside)
            }
        }
        // Do not add a line break
        return false
    }
    
    
    // This function is called when a tap is recognized
    /*func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    */
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        formatter.timeStyle = DateFormatter.Style.none
        scheduleCommencementTextField.text = formatter.string(from: sender.date)
        textFieldsCompletion[1] = true
        scheduleDate = formatter.string(from: sender.date)
        textFieldDidChange(scheduleCommencementTextField)
        /*formatter.dateFormat = "EEEE"
        firstDayLabel.text = formatter.string(from: sender.date)
        */
    }
    
    func donePressed(sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        formatter.timeStyle = DateFormatter.Style.none
        scheduleCommencementTextField.text = scheduleDate
        textFieldsCompletion[1] = true
        textFieldDidChange(scheduleCommencementTextField)
        scheduleCommencementTextField.resignFirstResponder()
        scheduleIDTextField.becomeFirstResponder()
    }
    
    func todayPressed(sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        formatter.timeStyle = DateFormatter.Style.none
        scheduleCommencementTextField.text = formatter.string(from: NSDate() as Date)
        textFieldsCompletion[1] = true
        textFieldDidChange(scheduleCommencementTextField)
        scheduleCommencementTextField.resignFirstResponder()
        scheduleIDTextField.becomeFirstResponder()
        /*formatter.dateFormat = "EEEE"
        firstDayLabel.text = formatter.string(from: NSDate() as Date)
        */
    }
    
    @IBAction func createScheduleButton(_ sender: UIButton){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        let date = dateFormatter.date(from: scheduleCommencementTextField.text!)
        let todayDate = dateFormatter.date(from: dateFormatter.string(from: NSDate() as Date))
        if(date! < todayDate!) { // Ensures the date is in the future or today
            errorLabel.text = "Date cannot be in the past"
        } else if(schedulePasswordTextField.text != confirmPasswordTextField.text) {
            errorLabel.text = "Passwords must match"
        } else {
            // TODO: Send information over to Firebase and check sync if someone else has sent the same request with the same ID
            // If it fails, display error message
            // Change success to fail
            var success = true
            if(!success) {
                errorLabel.text = "Timetable ID is already taken"
            } else {
                // TODO: Fill view menu with data from timetable
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewMenuViewController") as? ViewMenuViewController {
                    if let navigator = navigationController {
                        navigator.popViewController(animated: false)
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
