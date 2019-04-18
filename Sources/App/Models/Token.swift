import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

final class Token: Codable {
    var id: Int?
    var token: String
    var userID: User.ID
    
    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
}
extension Token: PostgreSQLModel {}
extension Token: Migration {}
extension Token: Content {}
extension Token {
    static func generate(for user: User) throws -> Token {
        let random = try CryptoRandom().generateData(count: 16)
        return try Token(token: random.base64EncodedString(), userID: user.requireID())
    }
}
extension Token {
    var user: Parent<Token, User> {
        return parent(\.userID)
    }
}
extension Token: BearerAuthenticatable {
    static var tokenKey: WritableKeyPath<Token, String> { return \Token.token }
}
extension Token: Authentication.Token {
    typealias UserType = User
    typealias UserIDType = User.ID
    
    static var userIDKey: WritableKeyPath<Token, User.ID> {
        return \Token.userID
    }
}
