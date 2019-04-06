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
}
