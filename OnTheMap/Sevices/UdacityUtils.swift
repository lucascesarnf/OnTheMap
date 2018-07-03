//
//  UdacityUtils.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 19/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

enum ServiceMethods:String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
}

class UdacityUtils {
    
    private struct Static
    {
         static var instance: UdacityUtils?
    }
    
    class var shared: UdacityUtils
    {
        if Static.instance == nil
        {
            Static.instance = UdacityUtils()
        }
        
        return Static.instance!
    }
    
    private var students:[StudentInformation] = []
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    private let baseURL = "https://www.udacity.com/"
    private let apiSession = "api/session"
    private let filter = "?limit=100&order=-updatedAt"
    private let accountAuthSingup = "account/auth#!/signup"
    private let parse = "https://parse.udacity.com/parse/classes/StudentLocation"
    
    private var client: LoginResponse? = nil
    
    lazy var sessionURL:URL = {
        return URL(string: baseURL + apiSession)!
    }()
    
    lazy var accountAuthSingupURL:URL = {
        return URL(string: baseURL + accountAuthSingup)!
    }()
    
    lazy var parseURL:URL = {
        return URL(string:parse + filter)!
    }()
    
    func setStudents(students: [StudentInformation]) {
        self.students = students
    }
    
    func getStudents() -> [StudentInformation] {
        return self.students
    }
    
    func dispose()
    {
        UdacityUtils.Static.instance = nil
    }
    
    func setClient(client:LoginResponse) {
        self.client = client
    }
    func getClient() -> LoginResponse? {
        return client
    }
    
    
    
    
}
