
import Vapor
import FluentSQLite

final class Account: Codable {
    
    var id: Int?
    var customName: String
    var currency: String
    
    init(customName: String, currency: String) {
        self.customName = customName
        self.currency = currency
    }
}

extension Account: SQLiteModel {}
extension Account: Migration {}
extension Account: Content {}
extension Account: Parameter {}


