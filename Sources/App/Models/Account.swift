
import Vapor
import FluentPostgreSQL

final class Account: Codable {
    
    var id: Int?
    var customName: String
    var userID: User.ID
    var currencyID: Currency.ID
    
    init(customName: String, userID: User.ID, currencyID: Currency.ID) {
        self.customName = customName
        self.userID = userID
        self.currencyID = currencyID
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

    var currency: Parent<Account, Currency> {
        return parent(\.currencyID)
    }
    
    var recuuringPayment: Children<Account, ReccuringPayment> {
        return children(\.accountID)
    }
    
    var creditCards: Children<Account, CreditCard> {
        return children(\.accountID)
    }
    
    var transactions: Children<Account, Transaction> {
        return children(\.accountID)
    }
}

