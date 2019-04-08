import Vapor
import Validation
import FluentPostgreSQL
import Authentication

final class User: Codable {
    
    var id: Int?
    var email: String
    var password: String?
    var isNewUser: Bool?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    final class Public: Codable {
        var id: Int?
        var email: String
        var password: String
        var isNewUser: Bool
        
        init(id: Int?, email: String, password: String, isNewUser: Bool) {
            self.id = id
            self.email = email
            self.password = password
            self.isNewUser = isNewUser
        }
    }
}

extension User {
    func toPublic() -> User.Public {
        return User.Public(id: id, email: email, password: password!, isNewUser: isNewUser!)
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
        return map(to: User.Public.self) { user in
            return user.toPublic()
        }
    }
}

extension User: PostgreSQLModel {}
extension User: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.email)
        }
    }
}
extension User: Validatable {
    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        try validations.add(\.email, .email)
        return validations
    }
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}
extension User: Content {}
extension User.Public: Content {}
extension User: Parameter {}
