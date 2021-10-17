//
//  User.swift
//  Travel
//
//  Created by Marvin Marcio on 15/10/21.
//

import Foundation
import UIKit

struct UserList: Codable
{
    let results: [User]
}

struct User: Codable
{
    let name: String
    
}



struct Picture: Codable
{
    let pictureName: String
    let pictureUrl: String
}
