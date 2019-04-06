import Vapor

final class CreditCardController: RouteCollection {
    
    
    func boot(router: Router) throws {
        let creditcardsRoute = router.grouped("api", "creditcards")
        creditcardsRoute.get(use: getAllHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[CreditCard]> {
        return CreditCard.query(on: req).decode(CreditCard.self).all()
    }
    
}
