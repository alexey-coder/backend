import Vapor
import FluentSQLite

final class Transaction: Codable {
    
    var id: Int?
    var iban: String
    var amount: Int
    
    init(iban: String, amount: Int) {
        self.iban = iban
        self.amount = amount
    }
}

extension Transaction: SQLiteModel {}
extension Transaction: Migration {}
extension Transaction: Content {}
extension Transaction: Parameter {}
