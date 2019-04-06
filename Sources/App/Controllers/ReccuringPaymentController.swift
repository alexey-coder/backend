import Vapor

final class ReccuringPaymentController: RouteCollection {
    
    func boot(router: Router) throws {
        let reccuringRoute = router.grouped("api", "reccuring")
        reccuringRoute.get(use: getAllHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[ReccuringPayment]> {
        return ReccuringPayment.query(on: req).decode(ReccuringPayment.self).all()
    }
    
}
