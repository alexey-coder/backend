import Vapor
import FluentPostgreSQL

final class ReccuringPayment: Codable {
    
    var id: Int?
    var customName: String
    var paymentDay: String
    var beneficiaryName: String
    var beneficiaryBank: String
    var beneficiaryBic: String
    var iban: String
    var amount: Int
    var reasonForPayment: String
    var userID: User.ID
    var periodicity: String
    var accountID: Account.ID
    
    init(customName: String,
        paymentDay: String,
        beneficiaryName: String,
        beneficiaryBank: String,
        beneficiaryBic: String,
        iban: String,
        amount: Int,
        reasonForPayment: String,
        userID: User.ID,
        periodicity: String,
        accountID: Account.ID)
    {
        self.customName = customName
        self.paymentDay = paymentDay
        self.beneficiaryName = beneficiaryName
        self.beneficiaryBank = beneficiaryBank
        self.beneficiaryBic = beneficiaryBic
        self.iban = iban
        self.amount = amount
        self.reasonForPayment = reasonForPayment
        self.userID = userID
        self.periodicity = periodicity
        self.accountID = accountID
    }
}

extension ReccuringPayment: PostgreSQLModel {}
extension ReccuringPayment: Migration {}
extension ReccuringPayment: Content {}
extension ReccuringPayment: Parameter {}
extension ReccuringPayment {
    var user: Parent<ReccuringPayment, User> {
        return parent(\.userID)
    }
    
    var periodicy: Children<ReccuringPayment, Periodicity> {
        return children(\Periodicity.id)
    }
    
    var userFoundsFrom: Parent<ReccuringPayment, Account> {
        return parent(\.accountID)
    }
}
