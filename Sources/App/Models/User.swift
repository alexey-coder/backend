import Vapor
import FluentPostgreSQL

final class User: Codable {
    
    var id: Int?
    var name: String
    var username: String
    var password: String
    
    init(name: String, username: String, password: String) {
        self.name = name
        self.username = username
        self.password = password
    }
    
    final class Public: Codable {
        var id: Int?
        var name: String
        var username: String
        
        init(id: Int?, name: String, username: String) {
            self.id = id
            self.name = name
            self.username = username
        }
    }
}

extension User {
    func toPublic() -> User.Public {
        return User.Public(id: id, name: name, username: username)
    }
    
    var transactions: Children<User, Transaction> {
        return children(\.userID)
    }
    
    var creditCards: Children<User, CreditCard> {
        return children(\.userID)
    }
    
    var reccuringPayments: Children<User, ReccuringPayment> {
        return children(\.userID)
    }
    
    var accounts: Children<User, Account> {
        return children(\.userID)
    }
}

extension Future where T: User {
    func toPublic() -> Future<User.Public> {
        return map(to: User.Public.self) { (user) in
            return user.toPublic()
        }
    }
}

extension User: PostgreSQLModel {}
extension User: Migration {}
extension User: Content {}
extension User.Public: Content {}
extension User: Parameter {}
