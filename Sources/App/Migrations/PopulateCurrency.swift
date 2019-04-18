//
//  PopulateCurrency.swift
//  App
//
//  Created by Alexey Smirnov on 18/04/2019.
//

import Vapor
import FluentPostgreSQL

final class PopulateCurrency: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static let currencyNames = [
        "us",
        "eu",
        "gbp",
        "shf"
    ]
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        
        let futures = currencyNames.map { currency in
            return Currency(name: currency, image: "ds").create(on: connection).map(to: Void.self) { _ in return }
        }
        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
    
    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        
        let futures = currencyNames.map { currency in
            return Currency.query(on: connection).filter(\Currency.name == currency).delete()
        }
        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
}
