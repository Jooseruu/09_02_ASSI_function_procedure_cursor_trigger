package com.example;

import com.zaxxer.hikari.HikariDataSource;

import java.sql.*;

public class Application {
    private static HikariDataSource dataSource;

    public static void main(String[] args) throws SQLException {
        try {
            initDatabaseConnectionPool();
            addCustomer("Jane Smith", "555-5678");
        } finally {
            closeDatabaseConnectionPool();
        }
    }

    private static void addCustomer(String name, String phone) throws SQLException {
        System.out.println("Adding customer... ");
        try (Connection connection = dataSource.getConnection()) {
            try (PreparedStatement statement = connection.prepareStatement("""
                    INSERT INTO customers (name, phone)
                    VALUES (?, ?)
                    """)) {
                statement.setString(1, name);
                statement.setString(2, phone);
                int rowsInserted = statement.executeUpdate();
                System.out.println("Rows inserted: " + rowsInserted);
            }
        }
    }


    private static void initDatabaseConnectionPool() {
        dataSource = new HikariDataSource();
        dataSource.setJdbcUrl("jdbc:postgresql://localhost:5432/Kebab_2.0");
        dataSource.setUsername("postgres");
        dataSource.setPassword("alex2004");
    }

    private static void closeDatabaseConnectionPool(){
        dataSource.close();
    }
}
