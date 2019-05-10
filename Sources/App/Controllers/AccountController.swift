import Vapor
import FluentPostgreSQL

final class AccountController: RouteCollection {
    
    func boot(router: Router) throws {
        let accountsRoute = router.grouped("api", "accounts")
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let tokenProtected = accountsRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
//        tokenProtected.get(use: getAllHandler)
//        tokenProtected.get(Account.parameter, "user", use: getUserHandler)
//        tokenProtected.post(use: createHeandler)
//        tokenProtected.delete(Account.parameter, use: deleteHandler)
//        tokenProtected.put(Account.parameter, use: updateHandler)
//        accountsRoute.get(use: getAllHandler)
//        accountsRoute.get(Account.parameter, "user", use: getUserHandler)
        accountsRoute.post(use: createHeandler)
        accountsRoute.delete(Account.parameter, use: deleteHandler)
        accountsRoute.put(Account.parameter, use: updateHandler)
        accountsRoute.get(use: getNestedResponseHeandler)
    }
    
    func createHeandler(_ req: Request) throws -> Future<Account> {
        return try req.content.decode(Account.self).flatMap {
            account in
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
    
    func getNestedResponseHeandler(_ req: Request) throws -> Future<[AccountNested]> {
        return Account.query(on: req).all().flatMap { accounts in
            let accountsResponseFutures = try accounts.map { account in
                try account.transactions.query(on: req).all().map { transactions in
                    return AccountNested(id: account.id!, customName: account.customName, transactions: transactions)
                }
            }
            return accountsResponseFutures.flatten(on: req)
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
