import Vapor
import FluentPostgreSQL

final class AccountController: RouteCollection {
    
    func boot(router: Router) throws {
        let accountsRoute = router.grouped("api", "accounts")
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let tokenProtected = accountsRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)

        tokenProtected.post(use: createHeandler)
        tokenProtected.delete(Account.parameter, use: deleteHandler)
        tokenProtected.put(Account.parameter, use: updateHandler)
        tokenProtected.get(Account.parameter, "transactions", use: getTransactionsByAccountId)
    }
    
    func createHeandler(_ req: Request) throws -> Future<Account> {
        return try req.content.decode(Account.self).flatMap {
            account in
            account.balance = 0.0
            var accNumber = ""
            for _ in 0...22 {
               accNumber += String(Int.random(in: 0...9))
            }
            account.accountNumber = accNumber
            return account.save(on: req)
        }
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Account]> {
        return Account.query(on: req).decode(Account.self).all()
    }
    
    func getUserHandler(_ req: Request) throws -> Future<User.Public> {
        return try req.parameters.next(Account.self).flatMap(to: User.Public.self) { account in
            return account.user.get(on: req).toPublic()
        }
    }
    
    func getTransactionsByAccountId(_ req: Request) throws -> Future<[Transaction]> {
        return try req.parameters.next(Account.self).flatMap(to: [Transaction].self) { trans in
            return try trans.transactions.query(on: req).all()
        }
    }
    
    func updateHandler(_ req: Request) throws -> Future<Account> {
        return try flatMap(to: Account.self, req.parameters.next(Account.self), req.content.decode(Account.self)) { (account, updatedAccount) in
            account.customName = updatedAccount.customName
            return account.save(on: req)
        }
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Account.self).flatMap { (user) in
            return user.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
}
