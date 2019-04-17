import Vapor
import FluentPostgreSQL

final class Transaction: Codable {
    
    var id: Int?
    var iban: String
    var amount: Int
    var userID: User.ID
    
    init(iban: String, amount: Int, userID: User.ID) {
        self.iban = iban
        self.amount = amount
        self.userID = userID
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
}
