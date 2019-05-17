//
//  TransactionNested.swift
//  App
//
//  Created by user on 09/05/2019.
//

import Vapor
import FluentPostgreSQL

struct AccountWithNestedTransactions: Codable {
    var id: Int?
    var customName: String
    var transactions: [Transaction]
    var creditCards: [CreditCard]
    
    init(id: Int, customName: String, transactions: [Transaction], creditCards: [CreditCard]) {
        self.id = id
        self.customName = customName
        self.transactions = transactions
        self.creditCards = creditCards
    }
}

extension AccountWithNestedTransactions: Content {}
extension AccountWithNestedTransactions: PostgreSQLModel {}
extension AccountWithNestedTransactions: Migration {}
