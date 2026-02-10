package config; 

import java.sql.Connection; // Importa la interfaz para manejar conexiones
import java.sql.DriverManager; // Importa la clase que gestiona los drivers de BD
import java.sql.SQLException; // Importa el manejo de errores específicos de SQL

public class conexion {
    private final String db = "proyecto_geovan"; 
    private final String url = "jdbc:mysql://localhost:3306/" + db;
    private final String user = "root";
    private final String pass = "#Aprendiz2024"; 
    
    // Objeto que almacenará el estado de la conexión abierta
    private Connection con; 
    
    public Connection getConnection() {
        try {
            // Carga el driver, es el que permite que se comunique la conexión con la db
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Se ingresan los parametros para abrir la base de datos
            con = DriverManager.getConnection(url, user, pass);
            
            System.out.println("Geovan esta conectado de manera correcta.");
            
        } catch (ClassNotFoundException | SQLException e) {
            // Si algo falla atrapa el error y lo muestra
            System.err.println("No se pudo realizar la conexion: " + e.getMessage());
        }
        
        // Retorna la conexión activa o nula
        return con;
    }
}