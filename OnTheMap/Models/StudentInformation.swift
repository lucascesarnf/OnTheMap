//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 22/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

struct PostStudentResponse:Codable {
    let createdAt:String
    let objectId:String
}

struct StudentsInformations:Codable {
    let results:[StudentInformation]
}

struct StudentInformation:Codable {
    public let createdAt:String?
    public let firstName:String?
    public let lastName:String?
    public let latitude:Float?
    public let longitude:Float?
    public let mapString:String?
    public let mediaURL:String?
    public let objectId:String?
    public let uniqueKey:String?
    public let updatedAt:String?
    public let locationID:String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Float ?? 0.0
        self.longitude = dictionary["longitude"] as? Float ?? 0.0
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.objectId = dictionary["objectId"] as? String ?? ""
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.locationID = dictionary["objectId"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
    }
}
