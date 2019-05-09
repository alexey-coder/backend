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
        Currency(name: "us", image: "/Flags/usd.png", symbol: "$"),
        Currency(name: "eu", image: "/Flags/eur.png", symbol: "€"),
        Currency(name: "gbp", image: "/Flags/gbp.png", symbol: "£"),
        Currency(name: "shf", image: "/Flags/shf.png", symbol: "₣")
    ]
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        
        let futures = currencyNames.map { currency in
            return Currency(name: currency.name, image: currency.image, symbol: currency.symbol).create(on: connection).map(to: Void.self) { _ in return }
        }
        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
    
    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        
        let futures = currencyNames.map { currency in
            return Currency.query(on: connection).filter(\Currency.name == currency.name).delete()
        }
        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
}
