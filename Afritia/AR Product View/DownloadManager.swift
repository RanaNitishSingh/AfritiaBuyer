//
//  DownloadManager.swift
//  downloading
//
//  Created by bhavuk.chawla on 11/09/18.
//  Copyright © 2018 bhavuk.chawla. All rights reserved.
//

import Foundation
import UIKit
//import SwiftyJSON
import Alamofire

protocol tes {
    func pass(str: String)
}

class DownloadManager: NSObject {
    var delegate: tes?
    override private init() {
        super.init()
    }
    
    static var shared = DownloadManager()


    var id = ""
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func download(string: String) {
      
        
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent("\(DownloadManager.shared.randomString(length: 5)).obj")
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//        
//        AF.download(URLRequest(url: URL(string: string)!), to: destination).response { response in
//            if response.error == nil, let filePath = response.destinationURL?.path {
//                print(filePath)
//                let myUrl = "file://" + filePath
//                print(myUrl)
////                UserDefaults.standard.set(myUrl, forKey: "obj")
////                UserDefaults.standard.synchronize()
//                self.delegate?.pass(str: myUrl)
//            }
//        }
    }
    
    
    
}
