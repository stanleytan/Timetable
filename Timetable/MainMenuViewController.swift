//
//  MainMenuViewController.swift
//  Timetable
//
//  Created by Stanley Tan on 7/10/17.
//  Copyright © 2017 Stanley Tan. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var timetableIDTextField: TextField!
    @IBOutlet weak var timetablePasswordTextField: TextField!
    @IBOutlet weak var invalidLabel: UILabel!
    @IBOutlet weak var viewTimetableButton: UIButton!
    @IBOutlet weak var createTimetableButton: UIButton!
    
    @IBAction func createButton(_ sender: UIButton){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateMenuViewController") as? CreateMenuViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        timetableIDTextField.text = ""
        timetablePasswordTextField.text = ""
        timetableIDTextField.resignFirstResponder()
        timetablePasswordTextField.resignFirstResponder()
    }
    
    @IBAction func viewButton(_ sender: UIButton){
        if(timetableIDTextField.text! == "m" && timetablePasswordTextField.text == "n") {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewMenuViewController") as? ViewMenuViewController {
                if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
                }
            }
            timetableIDTextField.text = ""
            timetablePasswordTextField.text = ""
            timetableIDTextField.resignFirstResponder()
            timetablePasswordTextField.resignFirstResponder()
        } else {
            invalidLabel.alpha = 1
            // After the animation completes, fade out the view
            UIView.animate(withDuration: 1, delay: 4, options: .curveLinear, animations: { self.invalidLabel.alpha = 0 }, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        timetableIDTextField.delegate = self
        timetableIDTextField.tag = 0
        timetableIDTextField.attributedPlaceholder = NSAttributedString(string: "Timetable ID", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.4)])
        timetableIDTextField.autocorrectionType = .no
        
        timetablePasswordTextField.delegate = self
        timetablePasswordTextField.tag = 1
        timetablePasswordTextField.attributedPlaceholder = NSAttributedString(string: "Timetable Password", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.4)])
        timetablePasswordTextField.autocorrectionType = .no
        
        viewTimetableButton.layer.cornerRadius = 10
        viewTimetableButton.clipsToBounds = true
        createTimetableButton.layer.cornerRadius = 10
        createTimetableButton.clipsToBounds = true

        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(backButtonAction(sender:)))
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)], for: UIControlState.normal)
        navigationItem.backBarButtonItem = backButton
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight), NSForegroundColorAttributeName: UIColor(red:0.12, green:0.78, blue:0.39, alpha:1.0)]
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.12, green:0.78, blue:0.39, alpha:1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func backButtonAction(sender: UIBarButtonItem) {
        if let navigator = navigationController {
            navigator.popViewController(animated: true)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so move to continue
            viewTimetableButton.sendActions(for: UIControlEvents.touchUpInside)
        }
        // Do not add a line break
        return false
    }
    
}
