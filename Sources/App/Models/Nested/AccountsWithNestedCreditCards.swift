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
    var balance: Double
    var accountNumber: String
    
    init(id: Int, customName: String, creditCards: [CreditCard], balance: Double, accountNumber: String) {
        self.id = id
        self.customName = customName
        self.creditCards = creditCards
        self.balance = balance
        self.accountNumber = accountNumber
    }
}

extension AccountsWithNestedCreditCards: Content {}
extension AccountsWithNestedCreditCards: PostgreSQLModel {}
extension AccountsWithNestedCreditCards: Migration {}
