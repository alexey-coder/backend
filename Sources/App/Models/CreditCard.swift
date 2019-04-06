import Vapor
import FluentSQLite

final class CreditCard: Codable {
    
    var id: Int?
    var postalCode: String
    var address: String
    var city: String
    var country: String
    
    init(postalCode: String, address: String, city: String, country: String ) {
        self.postalCode = postalCode
        self.address = address
        self.city = city
        self.country = country
    }
}

extension CreditCard: SQLiteModel {}
extension CreditCard: Migration {}
extension CreditCard: Content {}
extension CreditCard: Parameter {}
