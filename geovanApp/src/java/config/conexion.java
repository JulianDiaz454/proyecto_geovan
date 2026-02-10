package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class conexion {
    private final String db = "proyecto_geovan"; 
    private final String url = "jdbc:mysql://localhost:3306/" + db;
    private final String user = "root";
    private final String pass = "#Aprendiz2024";
    
    private Connection con;
    
    public Connection getConnection() {
        try {
            // Cargar el driver que acabamos de agregar a Libraries
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Intentar establecer la conexión
            con = DriverManager.getConnection(url, user, pass);
            System.out.println("Geovan esta conectado de manera correcta.");
            
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("No se pudo realizar la conexion: " + e.getMessage());
        }
        return con;
    }
}