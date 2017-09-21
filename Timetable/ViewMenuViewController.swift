//
//  ViewMenuViewController.swift
//  Timetable
//
//  Created by Stanley Tan on 8/5/17.
//  Copyright © 2017 Stanley Tan. All rights reserved.
//

import UIKit

class ViewMenuUIScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}

class ViewMenuViewController: UIViewController {


    @IBOutlet weak var button1200AM: UIButton!
    @IBOutlet weak var button1230AM: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let rightButtonItem = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(rightButtonAction(sender:)))
        rightButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)], for: UIControlState.normal)
        
        navigationItem.rightBarButtonItem = rightButtonItem
        let backButton = UIBarButtonItem(title: "View", style: .plain, target: nil, action: #selector(backButtonAction(sender:)))
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)], for: UIControlState.normal)
        navigationItem.backBarButtonItem = backButton
        
        // set navTitle to input
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight),  NSForegroundColorAttributeName: UIColor(red:0.12, green:0.78, blue:0.39, alpha:1.0)]
        self.navigationItem.title = "Timetable Name"
        
        button1200AM.layer.cornerRadius = 10
        button1200AM.clipsToBounds = true
        button1230AM.layer.cornerRadius = 10
        button1230AM.clipsToBounds = true
    }
    
    func backButtonAction(sender: UIBarButtonItem) {
        if let navigator = navigationController {
            navigator.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rightButtonAction(sender: UIBarButtonItem) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditMenuViewController") as? EditMenuViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
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
