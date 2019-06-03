//
//  ReccuringPaymentWithAccount.swift
//  App
//
//  Created by user on 03/06/2019.
//

import Foundation
import Vapor
import FluentPostgreSQL

struct ReccuringPaymentWithAccount: Codable {
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
    var account: [Account]
    
    init(id: Int,
         customName: String,
         paymentDay: String,
         beneficiaryName: String,
         beneficiaryBank: String,
         beneficiaryBic: String,
         iban: String,
         amount: Int,
         reasonForPayment: String,
         userID: User.ID,
         periodicity: String,
         accountID: Account.ID,
         account: [Account])
    {
        self.id = id
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
        self.account = account
    }
}

extension ReccuringPaymentWithAccount: Content {}
extension ReccuringPaymentWithAccount: PostgreSQLModel {}
extension ReccuringPaymentWithAccount: Migration {}
