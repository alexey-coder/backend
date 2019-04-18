//
//  PeriodicityController.swift
//  App
//
//  Created by Alexey Smirnov on 18/04/2019.
//

import Vapor
import Authentication

final class PeriodicityController: RouteCollection {
    func boot(router: Router) throws {
        
        let periodicityRoute = router.grouped("api", "periodicity")
        
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let tokenProtected = periodicityRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenProtected.get(use: getAllHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Periodicity]> {
        return Periodicity.query(on: req).decode(Periodicity.self).all()
    }
}
