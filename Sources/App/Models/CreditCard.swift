import Vapor
import FluentPostgreSQL

final class CreditCard: Codable {
    
    var id: Int?
    var postalCode: String
    var address: String
    var city: String
    var country: String
    var userID: User.ID
    var accountID: Account.ID
    var cardNumber: String?
    
    init(id: Int, postalCode: String, address: String, city: String, country: String, userID: User.ID, accountID: Account.ID) {
        self.id = id
        self.postalCode = postalCode
        self.address = address
        self.city = city
        self.country = country
        self.userID = userID
        self.accountID = accountID
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
    
    var account: Parent<CreditCard, Account> {
        return parent(\.accountID)
    }
}
