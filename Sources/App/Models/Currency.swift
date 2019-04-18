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
//    var accountID: Account.ID
    
    init( name: String, image: String
//        , accountID: Account.ID
        ) {
        self.name = name
        self.image = image
//        self.accountID = accountID
    }
}
extension Currency: PostgreSQLModel {}
extension Currency: Content {}
extension Currency: Parameter {}
extension Currency: Migration {}
//extension Currency {
//    var account: Parent<Currency, Account> {
//        return parent(\.accountID)
//    }
//}
