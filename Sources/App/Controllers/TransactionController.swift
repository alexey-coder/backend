import Vapor

final class TransactionController: RouteCollection {
    
    func boot(router: Router) throws {
        let transactionRoute = router.grouped("api", "transactions")
        transactionRoute.get(use: getAllHandler)
        transactionRoute.get(Transaction.parameter, "user", use: getUserHandler)
        transactionRoute.post(use: createHandler)
    }
    
    func createHandler(_ req: Request) throws -> Future<Transaction> {
        return try req.content.decode(Transaction.self).flatMap { (transaction) in
            return transaction.save(on: req)
        }
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Transaction]> {
        return Transaction.query(on: req).decode(Transaction.self).all()
    }
    
    func getUserHandler(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters.next(Transaction.self).flatMap(to: User.Public.self) { (transaction) in
            return transaction.user.get(on: req).toPublic()
        }
    }
    
    func updateHandler(_ req: Request) throws -> Future<Transaction> {
        return try flatMap(to: Transaction.self, req.parameters.next(Transaction.self), req.content.decode(Transaction.self)) { (transaction, updatedTransaction) in
            transaction.iban = updatedTransaction.iban
            transaction.amount = updatedTransaction.amount
            transaction.userID = updatedTransaction.userID
            return transaction.save(on: req)
        }
    }
}
