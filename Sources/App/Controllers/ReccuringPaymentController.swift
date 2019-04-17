import Vapor
import Authentication

final class ReccuringPaymentController: RouteCollection {
    
    func boot(router: Router) throws {
        let reccuringRoute = router.grouped("api", "reccuring")
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let tokenProtected = reccuringRoute.grouped(tokenAuthMiddleware)
        
        tokenProtected.get(use: getAllHandler)
        tokenProtected.post(use: createHendler)
        tokenProtected.get(ReccuringPayment.parameter, "user", use: getAllHandler)
    }
    
    func createHendler(_ req: Request) throws -> Future<ReccuringPayment> {
        return try req.content.decode(ReccuringPayment.self).flatMap {
            payment in
            return payment.save(on: req)
        }
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[ReccuringPayment]> {
        return ReccuringPayment.query(on: req).decode(ReccuringPayment.self).all()
    }
    
    func getUserHeandler(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters.next(ReccuringPayment.self).flatMap(to: User.Public.self) { payment in
            return payment.user.get(on: req).toPublic()
        }
    }
}
