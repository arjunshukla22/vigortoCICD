//
//  URLRequest.swift
//  XRentY
//
//  Created by user on 25/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case POST
    case GET
    case PUT
}

final class RequestBuilder {
    
    static let timeoutInterval : TimeInterval = .infinity
    
    //MARK:- url request builder method
    class func buildRequest(api: APIConstants, method: HTTPMethod = .GET, parameters: [String:Any]?) -> URLRequest? {
        
        guard let requestUrl = URL(string: api.url) else {
            debugPrint("-wrong url format-") 
            return nil
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.timeoutInterval = RequestBuilder.timeoutInterval
        
        if method == .POST || method == .PUT {
            guard parameters != nil else { return nil }
            self.addPostRequest(parameters ?? [:], request: &request)
        } else {
            self.addGetRequest(request: &request, parameters: parameters ?? [:])
        }
        
        self.printRequest(request, parameters: parameters)
        
        return request
    }
    
    //MARK:- post request method to add data
    class func addPostRequest(_ parameters: [String:Any], request: inout URLRequest) {
        if request.url?.lastPathComponent == APIConstants.register.rawValue || request.url?.lastPathComponent == APIConstants.updateDoctorProfile.rawValue || request.url?.lastPathComponent == APIConstants.bookAppointment.rawValue ||
            
            request.url?.lastPathComponent == APIConstants.rateproviders.rawValue ||
            request.url?.lastPathComponent == APIConstants.addPost.rawValue || request.url?.lastPathComponent == APIConstants.AddBlogPostComment.rawValue || request.url?.lastPathComponent == APIConstants.AddPostLikeStatus.rawValue || request.url?.lastPathComponent == APIConstants.AddFriend.rawValue || request.url?.lastPathComponent == APIConstants.AcceptRequest.rawValue || request.url?.lastPathComponent == APIConstants.DoctorRegister.rawValue{
            request.allHTTPHeaderFields = ["cache-control":"no-cache", "Content-Type": "application/json"]
            let json = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = json
        } else{
            let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.allHTTPHeaderFields = ["cache-control":"no-cache"]
            
            var dict = [String: Any]()
            for (key, value) in parameters{
                if key != "image"{
                    dict[key] = value
                }
            }
            var imageDataKey = Data()
            if let imageData = parameters["image"] as? Data  {
                imageDataKey = imageData
            }
            if request.url?.lastPathComponent == APIConstants.findDoctor.rawValue || request.url?.lastPathComponent == APIConstants.verifyMembershipCard.rawValue {
                request.httpBody = createFindDoctor(parameters: parameters, boundary: boundary) as Data
            }else {
                 request.httpBody =  createBodyWithParameters( parameters: dict as? [String : String], filePathKey: "", imageDataKey: imageDataKey, boundary: boundary) as Data
            }
//            request.httpBody = request.url?.lastPathComponent != APIConstants.findDoctor.rawValue ? createBodyWithParameters( parameters: dict as? [String : String], filePathKey: "", imageDataKey: imageDataKey, boundary: boundary) as Data : createFindDoctor(parameters: parameters, boundary: boundary) as Data
        }
    }
    
    //MARK:- get request method
    class func addGetRequest(request: inout URLRequest, parameters: [String:Any]) {
        
        if !parameters.isEmpty {
            var getUrl = "\(request.url!.absoluteString)?"
            for (key,value) in parameters {
                getUrl.append("\(key)=\(value)&")
            }
            request.url = URL(string: getUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        
        if let accessToken = Authentication.token {
            request.allHTTPHeaderFields = ["Token":"\(accessToken)",
                "content-type":"application/json",
                "cache-control":"no-cache"]
        }
    }
    
    class func printRequest(_ request: URLRequest, parameters: [String:Any]?) {
        print("******************************")
        print("url: \(request.url?.absoluteString ?? "invalid url")")
//        print("method:\(request.httpMethod ?? "GET")")
//        print("headers: \(request.allHTTPHeaderFields ?? [:])")
        if request.httpMethod  != "GET" {
            print("request: \(parameters ?? [:])")
        }
        print("******************************")
    }
    
    class func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData {
                let body = NSMutableData()
            
            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }
            
            let filename = "user-profile.jpg"
            let mimetype = "image/jpg"
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)--\r\n")
            
            return body
        }
        
         class func createFindDoctor(parameters: [String: Any]?, boundary: String) -> NSData {
                    let body = NSMutableData()
            
                    if parameters != nil {
                        for (key, value) in parameters! {
                            body.appendString(string: "--\(boundary)\r\n")
                            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                            body.appendString(string: "\(value)\r\n")
                        }
                    }
            
                    body.appendString(string: "--\(boundary)--\r\n")
                    return body
    }

  
}
