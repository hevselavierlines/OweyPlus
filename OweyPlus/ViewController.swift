//
//  ViewController.swift
//  OweyPlus
//
//  Created by Manuel Baumgartner on 10/11/2015.
//  Copyright © 2015 Application Project Center. All rights reserved.
//

import UIKit
import CoreData
import AddressBook
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var addressBookRef : ABAddressBook?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var persons : PersonsManager?
    var filteredPersons : [Person]?
    var selection = 0
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tvPersons: UITableView!
    
    func promptForAddressBookRequestAccess() {
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    print("Just denied")
                } else {
                    print("Just authorized")
                    self.loadFromContacts()
                }
            }
        }
    }
    
    func mergePerson(contact : Person) {
        var found = false
        for var i = 0; i < persons!.count() && !found; i++ {
            if persons!.get(i).id == contact.id {
                found = true
            }
        }
        if(!found) {
            persons!.add(contact)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dm = appDelegate.persons {
            
            persons = dm
        } else {
            appDelegate.persons = PersonsManager()
            persons = appDelegate.persons
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            //1
            print("Denied")
        case .Authorized:
            //2
            print("Authorized")
        case .NotDetermined:
            promptForAddressBookRequestAccess()
        }
        
        loadFromContacts()
        persons?.persons.sortInPlace({$0.compareTo($1)})
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        let pos = self.tvPersons.frame.origin.y
        tvPersons.reloadData()
        self.tvPersons.frame.origin.y = pos
    }
    
    func loadFromContacts() {
        var ar = getAllContacts()
        for var i = 0; i < ar.count; i++ {
            let elem = ar[i] as ABAddressBookRef
            let nameProv = ABRecordCopyCompositeName(elem)
            if nameProv != nil {
                let name = nameProv.takeRetainedValue() as String
                let recordID = ABRecordGetRecordID(elem)
                mergePerson(Person(_id: Int(recordID), _name: name, _telnr: ""))
            }
        }
        tvPersons.reloadData()
    }
    
    func getAllContacts() -> Array<AnyObject> {
        let allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as Array
        return allContacts
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let search = searchText.lowercaseString
        if(search == "") {
            filteredPersons = nil
        } else {
            filteredPersons = [Person]()
            for var i = 0; i < persons!.persons.count; i++ {
                /*if courses[i].name!.lowercaseString.containsString(str) {
                filteredCourses.append(courses[i])
                }*/
                let person = persons!.persons[i]
                if person.name.lowercaseString.containsString(search) {
                    filteredPersons?.append(person)
                }
            }
        }
        tvPersons.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("personCell")!
        var person : Person?
        if filteredPersons == nil {
            person = persons!.get(indexPath.item)
        } else {
            person = filteredPersons![indexPath.item]
        }
        let lbName = cell.viewWithTag(10) as! UILabel
        let imDebt = cell.viewWithTag(20) as! UIImageView
        let lbDebt = cell.viewWithTag(30) as! UILabel
        let lbOwes = cell.viewWithTag(40) as! UILabel
        
        
        lbName.text = person!.name
        
        lbOwes.text = person!.stringDebts()
        
        var amount = person!.countDebtAmount()
        if amount < -0.01 {
            lbDebt.textColor = UIColor.redColor()
        } else {
            lbDebt.textColor = UIColor.blackColor()
        }
        lbDebt.text = person!.getAmountAsString(amount)
        amount = abs(amount)
        if amount <= 0 {
            imDebt.image = nil
        } else if amount < 10 {
            imDebt.image = UIImage(named: "coins1")
        } else if amount < 25 {
            imDebt.image = UIImage(named: "coins2")
        } else if amount < 50 {
            imDebt.image = UIImage(named: "coins3")
        } else if amount < 100 {
            imDebt.image = UIImage(named: "coins4")
        } else if amount < 200 {
            imDebt.image = UIImage(named: "coins5")
        } else if amount < 400 {
            imDebt.image = UIImage(named: "coins6")
        } else if amount < 500 {
            imDebt.image = UIImage(named: "coins7")
        } else {
            imDebt.image = UIImage(named: "coins8")
        }
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPersons == nil {
            return persons!.count()
        } else {
            return filteredPersons!.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selection = indexPath.item
        performSegueWithIdentifier("showDebts", sender: self)
    }
    
    /**
     * Start the edit-mode and push a segue to the AddDrinkController.
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "showDebts" {
            let debtController = segue.destinationViewController as! DebtController
            if filteredPersons == nil {
                debtController.beforeSegue(persons!.get(selection))
            } else {
                debtController.beforeSegue(filteredPersons![selection])
            }
        }
    }
}

