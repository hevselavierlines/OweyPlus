//
//  AddDebtController.swift
//  OweyPlus
//
//  Created by Manuel Baumgartner on 23/11/2015.
//  Copyright © 2015 Application Project Center. All rights reserved.
//

import UIKit

class AddDebtController: UIViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var person : Person?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func clickDone(sender: AnyObject) {
        appDelegate.notifyAdd = true
        var amount = Double(tfAmount.text!)
        if amount != nil {
            print(scOwe.selectedSegmentIndex)
            if scOwe.selectedSegmentIndex == 0 {
                amount = -(amount!)
            }
            let newDebt = Debt(_object: tfObject.text!, _amount: amount!)
            person!.addDebt(newDebt)
            appDelegate.persons?.update(person!)
            appDelegate.persons?.save()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func beforeSegue(_person : Person) {
        person = _person
    }
    @IBOutlet weak var tfObject: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var scOwe: UISegmentedControl!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
