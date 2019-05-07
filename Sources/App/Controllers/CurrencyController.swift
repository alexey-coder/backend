//
//  CurrencyController.swift
//  App
//
//  Created by user on 17/04/2019.
//

import Vapor
import Authentication
import FluentPostgreSQL

final class CurrencyController: RouteCollection {
    
    func boot(router: Router) throws {
        let currencyRoute = router.grouped("api", "currency")
        
//        let guardAuthMiddleware = User.guardAuthMiddleware()
//        let tokenAuthMiddleware = User.tokenAuthMiddleware()
//        let tokenProtected = currencyRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
//        tokenProtected.get(use: getAllHandler)
        currencyRoute.get(use: getAllHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Currency]> {
        return Currency.query(on: req).decode(Currency.self).all()
    }
}
