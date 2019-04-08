import Vapor
import Crypto
import Validation

final class UsersController: RouteCollection {
  
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")
        usersRoute.get(use: getAllHandler)
        usersRoute.get(User.parameter, use: getOneHandler)
        usersRoute.post(use: createHandler)
        usersRoute.put(User.parameter, use: updateHandler)
        usersRoute.delete(User.parameter, use: deleteHandler)
        
        usersRoute.get(User.parameter, "transactions", use: getTransactionsHandler)
        usersRoute.get(User.parameter, "creditcards", use: getCreditCardsHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).decode(User.self).all()
    }
    
    func getOneHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    func createHandler(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            user.tempPassword = try CryptoRandom().generateData(count: 4).base32EncodedString().lowercased()
            user.isNewUser = true
            try user.validate()
            return user.save(on: req)
        }
    }
    
    func updateHandler(_ req: Request) throws -> Future<User> {
        return try flatMap(to: User.self, req.parameters.next(User.self), req.content.decode(User.self)) { (user, updatedUser) in
            user.email = updatedUser.email
//            user.username = updatedUser.username
//            user.password = try BCrypt.hash(updatedUser.password)
            return user.save(on: req)
        }
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { (user) in
            return user.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
    
    func getTransactionsHandler(_ req: Request) throws -> Future<[Transaction]> {
        return try req.parameters.next(User.self).flatMap(to: [Transaction].self) { (user) in
            return try user.transactions.query(on: req).all()
        }
    }
    
    func getCreditCardsHandler(_ req: Request) throws -> Future<[CreditCard]> {
        return try req.parameters.next(User.self).flatMap(to: [CreditCard].self) { (user) in
            return try user.creditCards.query(on: req).all()
        }
    }
}
