import Vapor

final class AccountController: RouteCollection {
    
    
    func boot(router: Router) throws {
        let accountsRoute = router.grouped("api", "accounts")
        accountsRoute.get(use: getAllHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Account]> {
        return Account.query(on: req).decode(Account.self).all()
    }
}
