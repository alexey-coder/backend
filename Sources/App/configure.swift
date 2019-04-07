import FluentPostgreSQL
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
//    try services.register(FluentSQLiteProvider())
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
//    let sqlite = try SQLiteDatabase(storage: .memory)

    // Register the configured SQLite database to the database config.
//    var databases = DatabasesConfig()
//    databases.add(database: sqlite, as: .sqlite)
//    services.register(databases)
    let config = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "user", database: "backend", password: nil, transport: .cleartext)
    let postgres = PostgreSQLDatabase(config: config)
        var databases = DatabasesConfig()
        databases.add(database: postgres, as: .psql)
        services.register(databases)
    
    
    
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Account.self, database: .psql)
    migrations.add(model: CreditCard.self, database: .psql)
    migrations.add(model: ReccuringPayment.self, database: .psql)
    migrations.add(model: Transaction.self, database: .psql)
    services.register(migrations)
}
