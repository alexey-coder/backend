import Vapor
import FluentPostgreSQL

final class Transaction: Codable {
    
    var id: Int?
    var iban: String
    var amount: Int
    var userID: User.ID
    var accountID: Account.ID

    init(iban: String, amount: Int, userID: User.ID, accountID: Account.ID) {
        self.iban = iban
        self.amount = amount
        self.userID = userID
        self.accountID = accountID
    }
}
extension Transaction: PostgreSQLModel {}
extension Transaction: Migration {}
extension Transaction: Content {}
extension Transaction: Parameter {}
extension Transaction {
    var user: Parent<Transaction, User> {
        return parent(\.userID)
    }
    
    var account: Parent<Transaction, Account> {
        return parent(\.accountID)
    }
}
