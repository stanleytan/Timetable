//
//  MainMenuViewController.swift
//  Timetable
//
//  Created by Stanley Tan on 7/10/17.
//  Copyright © 2017 Stanley Tan. All rights reserved.
//

import UIKit

class MainMenuSegueFromRight: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        src.view.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { dst.view.transform = CGAffineTransform(translationX: 0, y: 0); src.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width / 2, y: 0) }, completion: { finished in src.present(dst, animated: false, completion: nil) })
    }
}


class MainMenuViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    
    @IBOutlet weak var createTimetableButton: UIButton!
    @IBOutlet weak var viewTimetableButton: UIButton!
}
