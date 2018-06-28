//
//  loginModel.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 19/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

typealias CodableError = Error & Codable
typealias DecodableError = Error & Decodable

struct ServiceError:CodableError {
    let error:String
    let status:Int?
    let code:Int?
}
struct LoginResponse:Codable {
    let account: LoginAccount
    let session: LoginSession
}

struct LoginSession: Codable {
     public let id: String
     public let expiration: String
}

struct LoginAccount: Codable {
    public let registered:Bool
    public let key:String
}

