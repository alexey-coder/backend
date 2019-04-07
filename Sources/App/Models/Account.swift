
import Vapor
import FluentPostgreSQL

final class Account: Codable {
    
    var id: Int?
    var customName: String
    var currency: String
    var userID: User.ID
    
    init(customName: String, currency: String, userID: User.ID) {
        self.customName = customName
        self.currency = currency
        self.userID = userID
    }
}

extension Account: PostgreSQLModel {}
extension Account: Migration {}
extension Account: Content {}
extension Account: Parameter {}
extension Account {
    var user: Parent<Account, User> {
        return parent(\.userID)
    }
}

