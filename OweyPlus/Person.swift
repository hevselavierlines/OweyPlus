//
//  Person.swift
//  OweyPlus
//
//  Created by Manuel Baumgartner on 10/11/2015.
//  Copyright © 2015 Application Project Center. All rights reserved.
//

import Foundation

class Person {
    var id : Int
    var name : String
    var telnr : String
    var debts = [Debt]()

    
    init(_id : Int, _name : String, _telnr : String) {
        name = _name
        telnr = _telnr
        id = _id
    }
    
    func addDebt(_debt : Debt) {
        debts.append(_debt)
    }
    
    func removeDebt(_id : Int) {
        debts.removeAtIndex(_id)
    }
    
    func listAll() -> [Debt] {
        return debts
    }
    
    func countDebtAmount() -> Double {
        var total = 0.0
        for var i = 0; i < debts.count; i++ {
            total += debts[i].amount
        }
        return total
    }
    
    func getAmountAsString(_amount : Double) -> String {
        let format = NSNumberFormatter()
        format.positiveFormat = "#0.00"
        return format.stringFromNumber(_amount)! + " €"
    }
    
    func countDebtAmountString() -> String {
        return getAmountAsString(countDebtAmount())
    }
    
    func stringDebts() -> String {
        var mostPrice = 0
        for var i = 1; i < debts.count; i++ {
            if debts[i].amount > debts[mostPrice].amount {
                mostPrice = i
            }
        }
        if debts.count > 0 {
            return debts[mostPrice].object
        } else {
            return ""
        }
    }

    func serialize() -> NSDictionary {
        var serialDebts = [NSDictionary](count: debts.count, repeatedValue: NSDictionary())
        for var i = 0; i < debts.count; i++ {
            serialDebts[i] = debts[i].serialize()
        }
        let dict = ["id":id, "name":name, "telnr":telnr, "debts":serialDebts]
        return dict
    }
    
    init(_dict : NSDictionary) {
        id = _dict["id"] as! Int
        name = _dict["name"] as! String
        telnr = _dict["telnr"] as! String
        debts.removeAll()
        
        let serialDebts = _dict["debts"] as! NSArray
        for var i = 0; i < serialDebts.count; i++ {
            let elem = serialDebts[i] as! NSDictionary
            let debt = Debt(_dict: elem)
            debts.append(debt)
        }
    }
    
    func compareTo(_person : Person) -> Bool {
        let selfAmount = abs(countDebtAmount())
        let foreignAmount = abs(_person.countDebtAmount())
        if (selfAmount < foreignAmount) {
            return false
        } else if(selfAmount == foreignAmount) {
            return self.name < _person.name
        } else {
            return true
        }
    }
    
}
