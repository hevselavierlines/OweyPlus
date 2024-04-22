//
//  PersonsManager.swift
//  OweyPlus
//
//  Created by Manuel Baumgartner on 20/11/2015.
//  Copyright © 2015 Application Project Center. All rights reserved.
//

import Foundation

class PersonsManager {
    var persons = [Person]()
    init() {
        load()
    }
    
    init(withoutLoad : Bool) {
        
    }
    /**
     * Gets the document-directory of the app.
     */
    func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    func save() {
        let fileManager = NSFileManager.defaultManager()
        let filePath = "\(documentsDirectory())/persons.af"
        
        fileManager.createFileAtPath(filePath, contents: serialize(), attributes: nil)
    }
    /**
     * Loads the last drinks-file from the storage and imports it.
     * If the file is not available nothing will be loaded.
     */
    func load() {
        let fileManager = NSFileManager.defaultManager()
        let filePath = "\(documentsDirectory())/persons.af"
        if fileManager.fileExistsAtPath(filePath) {
            let data = NSData(contentsOfFile: filePath)
            deserialize(data!)
        } else {
            //No file found, a new one has to be created.
            print("creating new file")
        }
    }
    
    
    func deserialize(_data : NSData) {
        persons.removeAll(keepCapacity: true)
        let obj = (try! NSJSONSerialization.JSONObjectWithData(_data, options: NSJSONReadingOptions())) as! NSArray
        
        for var i = 0; i < obj.count; i++ {
            let dict = obj[i] as! NSDictionary
            
            persons.append(Person(_dict: dict))
        }
    }
    func serialize() -> NSData {
        var serials = [NSDictionary](count: persons.count, repeatedValue: NSDictionary())
        for var i = 0; i < persons.count; i++ {
            serials[i] = persons[i].serialize()
        }
        let data = try? NSJSONSerialization.dataWithJSONObject(serials, options: NSJSONWritingOptions())
        return data!
    }
    
    func count() -> Int {
        return persons.count
    }
    
    func get(i : Int) -> Person {
        return persons[i]
    }
    
    func add(_person : Person) {
        persons.append(_person)
    }
    
    func update(_person : Person) {
        var id = -1
        for var i = 0; i < persons.count && id == -1; i++ {
            if(_person.id == persons[i].id) {
                id = i
            }
        }
        persons[id].name = _person.name
        persons[id].telnr = _person.telnr
        persons[id].debts = _person.debts
    }
}


