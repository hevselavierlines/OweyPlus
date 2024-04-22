//
//  DebtController.swift
//  OweyPlus
//
//  Created by Manuel Baumgartner on 20/11/2015.
//  Copyright © 2015 Application Project Center. All rights reserved.
//

import UIKit

class DebtController: UIViewController, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var persons : PersonsManager?
    var person : Person?

    @IBAction func addDebtEvent(sender: AnyObject) {
        performSegueWithIdentifier("modalDebt", sender: self)
    }
    @IBOutlet weak var tvDebts: UITableView!
    @IBOutlet weak var lbComplete: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        persons = appDelegate.persons
        self.navigationItem.title = "Debts: " + person!.name
        let amount = person!.countDebtAmount()
        lbComplete.text = person!.getAmountAsString(amount)
        if amount < 0 {
            lbComplete.textColor = UIColor.redColor()
        } else {
            lbComplete.textColor = UIColor.blackColor()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if appDelegate.notifyAdd {
            appDelegate.notifyAdd = false
            /*let insertPos = person!.debts.count - 1
            tvDebts.insertRowsAtIndexPaths([NSIndexPath(forRow: insertPos, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)*/
            tvDebts.reloadData()
        }
        let amount = person!.countDebtAmount()
        lbComplete.text = person!.getAmountAsString(amount)
        if amount < 0 {
            lbComplete.textColor = UIColor.redColor()
        } else {
            lbComplete.textColor = UIColor.blackColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beforeSegue(_person : Person) {
        person = _person
        person?.debts.sortInPlace({$0.compareTo($1)})
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person!.debts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("debtCell", forIndexPath: indexPath)
        
        let debt = person!.debts[indexPath.item]
        let lbAmount = cell.viewWithTag(10) as! UILabel
        let lbDescri = cell.viewWithTag(20) as! UILabel
        
        lbAmount.text = debt.getAmount() + " €"
        lbDescri.text = debt.object
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        person!.removeDebt(indexPath.item)
        tvDebts.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        lbComplete.text = person?.countDebtAmountString()
        persons!.save()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "modalDebt" {
            let addDebtController = segue.destinationViewController as! AddDebtController
            addDebtController.beforeSegue(person!)
        }
    }
    
    

}
