import Vapor
import Crypto
import Validation
import Authentication
import FluentPostgreSQL

final class UsersController: RouteCollection {
  
    func boot(router: Router) throws {

        let usersRoute = router.grouped("api", "users")
        usersRoute.post("register", use: register)
        usersRoute.post("login", use: login)
        
        let guardAuthMiddleware = User.guardAuthMiddleware() 
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let tokenProtected = usersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        tokenProtected.get(use: getAllHandler)
        tokenProtected.get(User.parameter, use: getOneHandler)
        tokenProtected.delete(User.parameter, use: deleteHandler)
//        tokenProtected.get(User.parameter, "transactions", use: getTransactionsHandler)
//        tokenProtected.get(User.parameter, "creditcards", use: getCreditCardsHandler)
//        tokenProtected.get(User.parameter, "reccuring", use: getCreditReccuringPaymentsHandler)
//        tokenProtected.get(User.parameter, "accounts", use: getAccountsHeandler)
                usersRoute.get(User.parameter, "transactions", use: getTransactionsHandler)
                usersRoute.get(User.parameter, "creditcards", use: getCreditCardsHandler)
                usersRoute.get(User.parameter, "reccuring", use: getCreditReccuringPaymentsHandler)
                usersRoute.get(User.parameter, "accounts", use: getAccountsHeandler)
            usersRoute.get(User.parameter, "accountTransactions", use: getAccountsWithTransactions)
        usersRoute.get(User.parameter, "accountCreditcards", use: getAccountsWithCreditCards)
        usersRoute.get(User.parameter, "creditcardsAccount", use: getCreditCardsWithAccounts)

        tokenProtected.get("logout", use: logout)
        
         usersRoute.post(User.parameter, "avatar", use: uploadUser) //protect it
    }
    
    func register(_ req: Request) throws -> Future<User.Public> {
        return try req.content.decode(User.self).flatMap { user in
            try user.validate()
            let tempPass = "111"
            let newUser = User(email: user.email, password: tempPass, surname: user.surname, dayOfBirth: user.dayOfBirth, cityOfBirth: user.cityOfBirth, countryOfBirth: user.countryOfBirth, postalCode: user.postalCode, postAddress: user.postAddress, postCity: user.postCity, postCountry: user.postCountry, phone: user.phone)
         
            return newUser.save(on: req).map { storedUser in
                return User.Public(id: try storedUser.requireID(), email: storedUser.email, password: storedUser.password!)
            }
        }
    }
    
    func login(_ req: Request) throws -> Future<Token> {
        return try req.content.decode(User.Public.self).flatMap { user in
            return User.query(on: req).filter(\.email == user.email).first().flatMap { fetchedUser in
                guard let existingUser = fetchedUser else { throw Abort(HTTPStatus.notFound) }
                
                if user.password == existingUser.password! {
                    return try Token
                        .query(on: req)
                        .filter(\Token.userID, .equal, existingUser.requireID())
                        .delete()
                        .flatMap { _ in
                            let tokenString = try CryptoRandom().generateData(count: 32).base64EncodedString()
                            let token = try Token(token: tokenString, userID: existingUser.requireID())
                            return token.save(on: req)
                    }
                } else {
                    throw Abort(HTTPStatus.unauthorized)
                }
            }
        }
    }
    
    func logout(_ req: Request) throws -> Future<HTTPResponse> {
        let user = try req.requireAuthenticated(User.self)
        return try Token
            .query(on: req)
            .filter(\Token.userID, .equal, user.requireID())
            .delete()
            .transform(to: HTTPResponse(status: .ok))
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).decode(User.self).all()
    }
    
    func getOneHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
//    func updatePasswordHandler(_ req: Request) throws -> Future<User.Public> {
//        return try flatMap(to: User.Public.self, req.parameters.next(User.self), req.content.decode(User.self)) { (user, updatedUser) in
//            let hasher = try req.make(BCryptDigest.self)
//            let passwordHashed = try hasher.hash(updatedUser.password!)
//            user.password = passwordHashed
//            return user.save(on: req).map { storedUser in
//                return User.Public(id: try storedUser.requireID(), email: storedUser.email)
//            }
//        }
//    }
    
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
//
//    func getTransactionsByAccountHandler(_ req: Request) throws -> Future<[Transaction]> {
//        return try req.parameters.next(User.self).flatMap(to: [Transaction].self) { (user) in
//            return try user.transactions.query(on: req.parameters.next(Account.self).flatMap(to: [Transaction].self) { account in
//                return try account.transactions.query(on: req).all()
//            })
//        }
//    }
    
    func getCreditCardsHandler(_ req: Request) throws -> Future<[CreditCard]> {
        return try req.parameters.next(User.self).flatMap(to: [CreditCard].self) { user in
            return try user.creditCards.query(on: req).all()
        }
    }
    
    
    func getAccountsWithTransactions(_ req: Request) throws -> Future<[AccountWithNestedTransactions]> {
        return try req.parameters.next(User.self).flatMap(to: [AccountWithNestedTransactions].self) { users in
            return try users.accounts.query(on: req).all().flatMap(to: [AccountWithNestedTransactions].self) { accounts in
                let accountsResponseFutures = try accounts.map { account in
                    try account.transactions.query(on: req).all().map { transactions in
                        return AccountWithNestedTransactions(id: account.id!, customName: account.customName, transactions: transactions)
                        
                    }
                }
                return accountsResponseFutures.flatten(on: req)
            }
        }
    }
    
    func getAccountsWithCreditCards(_ req: Request) throws -> Future<[AccountsWithNestedCreditCards]> {
        return try req.parameters.next(User.self).flatMap(to: [AccountsWithNestedCreditCards].self) { users in
            return try users.accounts.query(on: req).all().flatMap(to: [AccountsWithNestedCreditCards].self) { accounts in
                let accountsResponseFutures = try accounts.map { account in
                    try account.creditCards.query(on: req).all().map { creditCards in
                        return AccountsWithNestedCreditCards(id: account.id!, customName: account.customName, creditCards: creditCards)
                    }
                }
                return accountsResponseFutures.flatten(on: req)
            }
        }
    }
    
    func getCreditCardsWithAccounts(_ req: Request) throws -> Future<[CreditCardsWithNestedAccounts]> {
        return try req.parameters.next(User.self).flatMap(to: [CreditCardsWithNestedAccounts].self) { users in
            return try users.creditCards.query(on: req).all().flatMap(to: [CreditCardsWithNestedAccounts].self) { credits in
                let creditsResponseFutures = try credits.map { credits in
                    try credits.account.query(on: req).all().map { acc in
                        return CreditCardsWithNestedAccounts(id: credits.id!, postalCode: credits.postalCode, address: credits.address, city: credits.city, country: credits.country, userID: credits.userID, accounts: acc)
                    }
                }
                return creditsResponseFutures.flatten(on: req)
            }
        }
    }
    
    func getCreditReccuringPaymentsHandler(_ req: Request) throws -> Future<[ReccuringPayment]> {
        return try req.parameters.next(User.self).flatMap(to: [ReccuringPayment].self) { user in
            return try user.reccuringPayments.query(on: req).all()
        }
    }
    
    func getAccountsHeandler(_ req: Request) throws -> Future<[Account]> {
        return try req.parameters.next(User.self).flatMap(to: [Account].self) { user in
            return try user.accounts.query(on: req).all()
        }
    }
    
    func uploadUser(_ req: Request) throws -> Future<HTTPStatus> {
        let directory = DirectoryConfig.detect()
        let workPath = directory.workDir
        let name = UUID().uuidString + ".jpg"
        let imageFolder = "Public/Avatars"
        let saveURL = URL(fileURLWithPath: workPath).appendingPathComponent(imageFolder, isDirectory: true).appendingPathComponent(name, isDirectory: false)
        
        return try req.content.decode(FileContent.self).map { payload in
            do {
                try payload.file.data.write(to: saveURL)
                print("payload: \(payload)")
                return .ok
            } catch {
                print("error: \(error)")
                throw Abort(.internalServerError, reason: "Unable to write multipart form data to file. Underlying error \(error)")
            }
        }
    }
}

struct FileContent: Content { //remove me
    var file: File
}
