//
//  Populate.swift
//  App
//
//  Created by Alexey Smirnov on 18/04/2019.
//

import Vapor
import FluentPostgreSQL

final class PopulatePeriodicity: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static let periodicityNames = [
        "daily",
        "weekly",
        "monthly"
    ]
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        
        let futures = periodicityNames.map { periodicity in
            return Periodicity(periodicity: periodicity).create(on: connection).map(to: Void.self) { _ in return }
        }
        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
    
    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        
        let futures = periodicityNames.map { periodicity in
            return Periodicity.query(on: connection).filter(\Periodicity.periodicity == periodicity).delete()
        }
        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
    }
}
