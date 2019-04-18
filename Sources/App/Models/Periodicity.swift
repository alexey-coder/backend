//
//  Periodicity.swift
//  App
//
//  Created by user on 17/04/2019.
//

import Vapor
import FluentPostgreSQL

final class Periodicity: Codable {
    var id: Int?
    var periodicity: String
//    var reccuringID: ReccuringPayment.ID
    
    init( periodicity: String
//        , reccuringID: ReccuringPayment.ID
        ) {
        self.periodicity = periodicity
//        self.reccuringID = reccuringID
    }
}

extension Periodicity: PostgreSQLModel {}
extension Periodicity: Content {}
extension Periodicity: Parameter {}
extension Periodicity: Migration {}
//extension Periodicity {
//    var reccuringPayment: Parent<Periodicity, ReccuringPayment> {
//        return parent(\.reccuringID)
//    }
//}
