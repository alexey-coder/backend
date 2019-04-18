////
////  PrePopulate.swift
////  App
////
////  Created by user on 17/04/2019.
////
//
//import Vapor
//import FluentPostgreSQL
//
//final class PrePopulate: Migration {
//    typealias Database = PostgreSQLDatabase
////
////    static let currencies = [
////        Currency(id: 1, name: "sss", image: "dsd", userID: 1),
////        Currency(id: 2, name: "ds", image: "dsd", userID: 2),
////        Currency(id: 3, name: "sds", image: "dsd", userID: 3),
////        Currency(id: 4, name: "ddf", image: "dsd", userID: 1)
////    ]
////    
//    static func getUserID(on connection: PostgreSQLConnection, heatName: String) -> Future<User.ID> {
//        do {
//            // First look up the heat by its name
//            return try User.query(on: connection)
//                .filter(\User.name == heatName)
//                .first()
//                .map(to: User.ID.self) { heat in
//                    guard let heat = heat else {
//                        throw FluentError(
//                            identifier: "PopulateTechniques_noSuchHeat",
//                            reason: "No heat named \(heatName) exists!",
//                            source: .capture()
//                        )
//                    }
//                    
//                    // Once we have found the heat, return it's id
//                    return heat.id!
//            }
//        }
//        catch {
//            return connection.eventLoop.newFailedFuture(error: error)
//        }
//    }
//    
//    static func addTechniques(on connection: PostgreSQLConnection, toHeatWithName heatName: String, heatTechniques: [(name: String, desc: String)]) -> Future<Void> {
//        // Look up the heat's ID
//        return getHeatID(on: connection, heatName: heatName)
//            .flatMap(to: Void.self) { heatID in
//                // Add each technique to the heat
//                let futures = heatTechniques.map { touple -> EventLoopFuture<Void> in
//                    // Insert the Technique
//                    let name = touple.0
//                    let desc = touple.1
//                    return Technique(name: name, description: desc, heatID: heatID)
//                        .create(on: connection)
//                        .map(to: Void.self) { _ in return }
//                }
//                return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
//        }
//    }
//    
//    static func deleteTechniques(on connection: PostgreSQLConnection, forHeatWithName heatName: String, heatTechniques: [(name: String, desc: String)]) -> Future<Void> {
//        // Look up the heat's ID
//        return getHeatID(on: connection, heatName: heatName)
//            .flatMap(to: Void.self) { heatID in
//                // Delete each technique from the heat
//                let futures = try heatTechniques.map { touple -> EventLoopFuture<Void> in
//                    // DELETE the technique if it exists
//                    let name = touple.0
//                    return try Technique.query(on: connection)
//                        .filter(\.heatID == heatID)
//                        .filter(\.name == name)
//                        .delete()
//                }
//                return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
//        }
//    }
//    
//    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
//        // Insert all heats from techniques
//        let futures = techniques.map { heatName, techniqueTouples in
//            return addTechniques(on: connection, toHeatWithName: heatName, heatTechniques: techniqueTouples)
//        }
//        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
//    }
//    
//    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
//        let futures = techniques.map { heatName, techniqueTouples in
//            return deleteTechniques(on: connection, forHeatWithName: heatName, heatTechniques: techniqueTouples)
//        }
//        return Future<Void>.andAll(futures, eventLoop: connection.eventLoop)
//    }
//}
