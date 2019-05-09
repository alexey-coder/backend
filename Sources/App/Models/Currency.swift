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
    var symbol: String
    
    init( name: String, image: String, symbol: String) {
        self.name = name
        self.image = image
        self.symbol = symbol
    }
}
extension Currency: PostgreSQLModel {}
extension Currency: Content {}
extension Currency: Parameter {}
extension Currency: Migration {}
