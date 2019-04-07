import Vapor
import FluentPostgreSQL

final class CreditCard: Codable {
    
    var id: Int?
    var postalCode: String
    var address: String
    var city: String
    var country: String
    var userID: User.ID
    
    init(postalCode: String, address: String, city: String, country: String, userID: User.ID ) {
        self.postalCode = postalCode
        self.address = address
        self.city = city
        self.country = country
        self.userID = userID
    }
}

extension CreditCard: PostgreSQLModel {}
extension CreditCard: Migration {}
extension CreditCard: Content {}
extension CreditCard: Parameter {}
extension CreditCard {
    var user: Parent<CreditCard, User> {
        return parent(\.userID)
    }
}
