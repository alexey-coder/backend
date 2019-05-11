//
//  CreditCardsWithNestedAccounts.swift
//  App
//
//  Created by user on 11/05/2019.
//

import Vapor
import FluentPostgreSQL

struct CreditCardsWithNestedAccounts: Codable {
    var id: Int?
    var postalCode: String
    var address: String
    var city: String
    var country: String
    var userID: User.ID
    var accounts: [Account]
    
    init(id: Int, postalCode: String, address: String, city: String, country: String, userID: User.ID, accounts: [Account]) {
        self.id = id
        self.postalCode = postalCode
        self.address = address
        self.city = city
        self.country = country
        self.userID = userID
        self.accounts = accounts
    }
}

extension CreditCardsWithNestedAccounts: Content {}
extension CreditCardsWithNestedAccounts: PostgreSQLModel {}
extension CreditCardsWithNestedAccounts: Migration {}
