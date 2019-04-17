//
//  Currency.swift
//  App
//
//  Created by user on 17/04/2019.
//

import Vapor
import FluentPostgreSQL

final class Currency: Codable {
    var id: Int?
    var name: String
    var image: String
    var userID: User.ID
    
    init(id: Int, name: String, image: String, userID: User.ID) {
        self.id = id
        self.name = name
        self.image = image
        self.userID = userID
    }
}
extension Currency: PostgreSQLModel {}
extension Currency: Content {}
extension Currency: Parameter {}
extension Currency: Migration {}
extension Currency {
    var account: Parent<Currency, Account> {
        return parent(\.userID)
    }
}
