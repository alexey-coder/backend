import Vapor
import FluentSQLite

final class ReccuringPayment: Codable {
    
    var id: Int?
    var customName: String
    var periodicity: String
    var paymentDay: String
    var beneficiaryName: String
    var beneficiaryBank: String
    var beneficiaryBic: String
    var iban: String
    var amount: Int
//    var userFoundsFrom: Account
    var reasonForPayment: String
    
    init(customName: String,
         periodicity: String,
        paymentDay: String,
        beneficiaryName: String,
        beneficiaryBank: String,
        beneficiaryBic: String,
        iban: String,
        amount: Int,
        reasonForPayment: String)
    {
        self.customName = customName
        self.periodicity = periodicity
        self.paymentDay = paymentDay
        self.beneficiaryName = beneficiaryName
        self.beneficiaryBank = beneficiaryBank
        self.beneficiaryBic = beneficiaryBic
        self.iban = iban
        self.amount = amount
        self.reasonForPayment = reasonForPayment
    }
}

extension ReccuringPayment: SQLiteModel {}
extension ReccuringPayment: Migration {}
extension ReccuringPayment: Content {}
extension ReccuringPayment: Parameter {}
