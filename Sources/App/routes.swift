import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let usersController = UsersController()
    try router.register(collection: usersController)
    
    let accountController = AccountController()
    try router.register(collection: accountController)
    
    let creditCardController = CreditCardController()
    try router.register(collection: creditCardController)
    
    let reccuringPaymentController = ReccuringPaymentController()
    try router.register(collection: reccuringPaymentController)
    
    let transactionController = TransactionController()
    try router.register(collection: transactionController)
    
    let currencyController = CurrencyController()
    try router.register(collection: currencyController)
    
    let periodicityController = PeriodicityController()
    try router.register(collection: periodicityController)
    

//    router.get("periodicity") { req -> [Periodicity] in
//        let resp = [Periodicity(id: 1, periodicity: "daily"),
//                    Periodicity(id: 2, periodicity: "two")]
//        
//        return resp
//    }
    
//    router.get("currency") { req -> [Currency] in
//        let resp = [Currency(id: 1, name: "us", current: false, image: "dsdds"),
//                    Currency(id: 2, name: "eu", current: false, image: "dfdf")]
//
//        return resp
//    }
}
