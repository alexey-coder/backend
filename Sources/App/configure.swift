import FluentPostgreSQL
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    try services.register(AuthenticationProvider())
    try services.register(FluentPostgreSQLProvider())
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    let config = PostgreSQLDatabaseConfig(
        hostname: "localhost",
        port: 5432,
        username: "alexey",
        database: "backend",
        password: nil,
        transport: .cleartext)
    
    let postgres = PostgreSQLDatabase(config: config)
    var databases = DatabasesConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Account.self, database: .psql)
    migrations.add(model: CreditCard.self, database: .psql)
    migrations.add(model: ReccuringPayment.self, database: .psql)
    migrations.add(model: Transaction.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)
    migrations.add(model: Currency.self, database: .psql)
    migrations.add(model: Periodicity.self, database: .psql)
    migrations.add(migration: PopulatePeriodicity.self, database: .psql)
    migrations.add(migration: PopulateCurrency.self, database: .psql)
    services.register(migrations)
}
