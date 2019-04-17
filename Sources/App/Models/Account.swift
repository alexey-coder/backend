
import Vapor
import FluentPostgreSQL

final class Account: Codable {
    
    var id: Int?
    var customName: String
    var userID: User.ID
    
    init(customName: String, userID: User.ID) {
        self.customName = customName
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

    var currency: Children<Account, Currency> {
        return children(\.userID)
    }
    
    var recuuringPayment: Children<Account, ReccuringPayment> {
        return children(\.accountID)
    }
}

