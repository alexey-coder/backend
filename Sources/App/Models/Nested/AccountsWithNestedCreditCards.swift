//
//  AccountsWithNestedCreditCards.swift
//  App
//
//  Created by user on 11/05/2019.
//

import Vapor
import FluentPostgreSQL

struct AccountsWithNestedCreditCards: Codable {
    var id: Int?
    var customName: String
    var creditCards: [CreditCard]
    
    init(id: Int, customName: String, creditCards: [CreditCard]) {
        self.id = id
        self.customName = customName
        self.creditCards = creditCards
    }
}

extension AccountsWithNestedCreditCards: Content {}
extension AccountsWithNestedCreditCards: PostgreSQLModel {}
extension AccountsWithNestedCreditCards: Migration {}
