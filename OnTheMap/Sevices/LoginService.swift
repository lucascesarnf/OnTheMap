//
//  LoginService.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 19/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit

class LoginService: GenericService {
    
    func requestSession(username:String, password:String, completion: @escaping (ResultType<LoginResponse>) -> Void) {
        let parameters = ["udacity":["username":username,"password":password]]
        requestData(type: LoginResponse.self, url: UdacityUtils.shared.sessionURL, method: .post, parameters: parameters){ completionHandler in
                completion(completionHandler)
         
        }
    }
    
    func getLocation(completion: @escaping (ResultType<StudentsInformations>) -> Void) {
        requestData(type: StudentsInformations.self, url: UdacityUtils.shared.parseURL, method: .get, parameters: nil,hasHTTPHeader:false, isParseRequest: true) { (completionHandler) in
            completion(completionHandler)
        }
    }
}
