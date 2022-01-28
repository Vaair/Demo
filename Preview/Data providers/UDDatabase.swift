//
//  UDDatabase.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 14.07.2021.
//

import Foundation
import CoreLocation

class UDDatabase {
    static var presentationWasViewed: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "presentationWasViewed")
        }
        get {
            return UserDefaults.standard.bool(forKey: "presentationWasViewed")
        }
    }
    
    static var cloudIsSyn: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "cloudIsSyn")
        }
        get {
            return UserDefaults.standard.bool(forKey: "cloudIsSyn")
        }
    }
    
    static var icon: Data? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "icon")
        }
        get {
            return UserDefaults.standard.object(forKey: "icon") as? Data
        }
    }
    
    static var profileIsNotEmpty: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "profileIsEmpty")
        }
        get {
            return UserDefaults.standard.bool(forKey: "profileIsEmpty")
        }
    }
    
    static var latitute: CLLocationDegrees {
        set {
            let numb = NSNumber(value: newValue)
            UserDefaults.standard.setValue(numb, forKey: "latitute")
        }
        get {
            return (UserDefaults.standard.object(forKey: "latitute") as? CLLocationDegrees) ?? 0.0
        }
    }
    
    static var longitude: CLLocationDegrees {
        set {
            let numb = NSNumber(value: newValue)
            UserDefaults.standard.setValue(numb, forKey: "longitude")
        }
        get {
            return (UserDefaults.standard.object(forKey: "longitude") as? CLLocationDegrees) ?? 0.0
        }
    }
    
    static var recordID: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "recordID")
        }
        get {
            return UserDefaults.standard.string(forKey: "recordID") ?? ""
        }
    }
    
    static var name: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "name")
        }
        get {
            return UserDefaults.standard.string(forKey: "name") ?? "Name"
        }
    }
    
    static var secondName: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "secondName")
        }
        get {
            return UserDefaults.standard.string(forKey: "secondName") ?? "Second Name"
        }
    }
    
    static var place: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "place")
        }
        get {
            return UserDefaults.standard.string(forKey: "place") ?? "Place"
        }
    }
    
    static var date: Date {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "date")
        }
        get {
            return (UserDefaults.standard.object(forKey: "date") as? Date) ?? Date()
        }
    }
    
    static var time: Date {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "time")
        }
        get {
            return (UserDefaults.standard.object(forKey: "time") as? Date) ?? Date()
        }
    }
    
    static var expiryDate: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "expiryDate")
        }
        get {
            return UserDefaults.standard.double(forKey: "expiryDate")
        }
    }
    
    static var statusSubscription: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "statusSubscription")
        }
        get {
            return UserDefaults.standard.bool(forKey: "statusSubscription")
        }
    }
    
    static var sex: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "sex")
        }
        get {
            return UserDefaults.standard.string(forKey: "sex") ?? ""
        }
    }
    
}
