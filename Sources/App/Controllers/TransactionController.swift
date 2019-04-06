import Vapor

final class TransactionController: RouteCollection {
    
    func boot(router: Router) throws {
        let transactionRoute = router.grouped("api", "transactions")
        transactionRoute.get(use: getAllHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Transaction]> {
        return Transaction.query(on: req).decode(Transaction.self).all()
    }
}
