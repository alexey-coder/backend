//
//  TransactionNested.swift
//  App
//
//  Created by user on 09/05/2019.
//

import Vapor
import FluentPostgreSQL

struct AccountWithNested: Codable {
    var id: Int?
    var customName: String
    var transactions: [Transaction]
    var creditCards: [CreditCard]
    var currency: [Currency]
    var balance: Double
    var accountNumber: String
    
    init(id: Int, customName: String, transactions: [Transaction], creditCards: [CreditCard], balance: Double, accountNumber: String, currency: [Currency]) {
        self.id = id
        self.customName = customName
        self.transactions = transactions
        self.creditCards = creditCards
        self.balance = balance
        self.accountNumber = accountNumber
        self.currency = currency
    }
}

extension AccountWithNested: Content {}
extension AccountWithNested: PostgreSQLModel {}
extension AccountWithNested: Migration {}
