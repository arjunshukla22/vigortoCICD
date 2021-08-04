//
//  Response.swift
//  XRentY
//
//  Created by user on 04/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

final class Empty : Parceable {
    
    var response : [String:AnyObject] = [:]
    init(_ json: [String:AnyObject]) {
        self.response = json
    }
    
    static func parseObject(dictionary: [String : AnyObject]) -> Empty? {
        return Empty(dictionary)
    }
}

class Response<T: Parceable> {
    
    var status: String?
    var DateOfBirth: String?
    var TotalAmount: Int?
    var statusCode: Int?
    var message: String?
    var object: T?
    var Results: T?
    var objects: [T]?
    
    var objectString: [String]?
    
    var rslt: Int?
    
    var resultString: String?

    var totalAmount: Int?

    func parse(json dictionary: [String:AnyObject]) -> (Result<Response<T>, ErrorResult>) {
        
       // print("Response: \(dictionary)")
        // parse json
    
        if let message = dictionary["msg"] as? String {
            self.message = message
        }
        if let DateOfBirth = dictionary["DateOfBirth"] as? String {
            self.DateOfBirth = DateOfBirth
        }
        if let TotalAmount = dictionary["TotalAmount"] as? Int {
            self.TotalAmount = TotalAmount
        }
        
        if let message = dictionary["Message"] as? String {
            self.message = message
        }
        // check response for dictionary
        if let response = dictionary["data"] as? [String:AnyObject]  {
            self.object = T.parseObject(dictionary: response)
        }
        
        // check response for dictionary
        if let response = dictionary["Result"] as? [String:AnyObject]  {
            self.object = T.parseObject(dictionary: response)
        }
       
        // check response for array
        if let response = dictionary["data"] as? [[String:AnyObject]]  {
            self.objects = []
            response.forEach {
                if let obj = T.parseObject(dictionary:$0) {
                    self.objects?.append(obj)
                }
            }
        }
        // check response for array
        if let response = dictionary["Result"] as? [[String:AnyObject]]  {
            self.objects = []
            response.forEach {
                if let obj = T.parseObject(dictionary:$0) {
                    self.objects?.append(obj)
                }
            }
        }
        
        // check response for array
        if let response = dictionary["data"] as? [String]  {
            self.objectString = []
            response.forEach {
                    self.objectString?.append($0)
            }
        }
        // check response for array
        if let response = dictionary["Result"] as? [String]  {
            self.objectString = []
            response.forEach {
                self.objectString?.append($0)
            }
        }

        // check status
        if let status = dictionary["status"] as? String {
            self.status = status
        }
        
        // check rslt
        if let result = dictionary["Result"] as? Int {
            self.rslt = result
        }
        
        // check resultString
        if let result = dictionary["Result"] as? String {
            self.resultString = result
        }
        
        // check status
        if let status = dictionary["Status"] as? Int {
            self.status = status == 1 ? "success" : "fail"
        }
        
        // check total amount for manage account
        if let totalAmount = dictionary["TotalAmount"] as? Int {
            self.totalAmount = totalAmount
        }
        
        // response check
        if  status == "success" {
            return Result.success(self)
        }
        else {
            return Result.failure(ErrorResult.custom(string: message ?? "Please try again later."))
        }
    }
}

