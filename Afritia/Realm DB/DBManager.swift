//
//  DBManager.swift
//  RealmDatabase
//
//  Created by Webkul on 22/03/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class DBManager {
    
    public var database: Realm?
    static let sharedInstance = DBManager()
    
    private init() {
        do{
            database = try Realm()
        }catch let error as NSError {
            print("ss", error)
        }
    }
    
    func deleteAllFromDatabase()  {
        do{
            let realm =  try database?.write {
                database?.deleteAll()
            }
        }catch let error as NSError {
            print("ss", error)
        }
    }
}
