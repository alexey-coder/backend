//
//  TransactionNested.swift
//  App
//
//  Created by user on 09/05/2019.
//

import Vapor
import FluentPostgreSQL

final class AccountNested: Codable {
    var id: Int?
    var customName: String
    var transactions: [Transaction]
    
    init(customName: String, transactions: [Transaction]) {
        self.customName = customName
        self.transactions = transactions
    }
}

extension AccountNested: PostgreSQLModel {}
extension AccountNested: Migration {}
extension AccountNested: Content {}
extension AccountNested: Parameter {}
