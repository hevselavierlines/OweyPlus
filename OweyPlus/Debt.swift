//
//  Debt.swift
//  OweyPlus
//
//  Created by Manuel Baumgartner on 10/11/2015.
//  Copyright © 2015 Application Project Center. All rights reserved.
//

import Foundation

class Debt {
    var object : String
    var amount : Double
    var money : Bool
    init(_amount : Double) {
        object = "Money"
        amount = _amount
        money = true
    }
    
    init(_object : String) {
        object = _object
        amount = 0.0
        money = false
    }
    
    init(_object : String, _amount : Double) {
        object = _object
        amount = _amount
        money = true
    }
    
    init(_dict : NSDictionary) {
        object = _dict["object"] as! String
        amount = _dict["amount"] as! Double
        money = _dict["money"] as! Bool
    }
    
    func getAmount() -> String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.positiveFormat = "#0.00"
        return numberFormatter.stringFromNumber(amount)!
    }
    
    func serialize() -> NSDictionary {
        let dict = ["object":object, "amount":amount, "money":money]
        return dict
    }
    
    func deserialize(_dict: NSDictionary) {
        object = _dict["object"] as! String
        amount = _dict["amount"] as! Double
        money = _dict["money"] as! Bool
    }
    
    func compareTo(_debt: Debt) -> Bool { // 1
        if amount > _debt.amount {
            return true
        } else if amount == _debt.amount {
            return object > _debt.object
        } else {
            return false
        }
    }
}