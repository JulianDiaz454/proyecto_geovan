package config;

import java.sql.Connection;
import java.sql.ResultSet; // Para recibir los datos
import java.sql.Statement; // Para enviar la consulta

public class prueba {
    public static void main(String[] args) {
        conexion con = new conexion(); // Creamos una instancia de la clase
        Connection c = con.getConnection(); // Asignamos en c la conexión que retorna el metodo
        
        // El bloque try-with-resources asegura que todo se cierre al terminar
        try (Statement st = c.createStatement()) {
            
            // En sql asignamos la consulta
            String sql = "SELECT * FROM T_Clientes"; 
            
            // En rs asignamos el resultado de la consulta
            ResultSet rs = st.executeQuery(sql);
            
            System.out.println("--- DATOS DE LA BASE DE DATOS ---");
            
            // Con el bucle while se recorren las inserciones de la tabla
            while (rs.next()) { // La función next() salta a la siguiente fila, si lo hace da true
                // Puedes usar rs.getString("nombre_columna") o rs.getInt(posicion)
                System.out.println("ID: " + rs.getInt("Clientes_id") + " | Nombre: " + rs.getString("Clientes_nombre_completo") + " | Correo : " + rs.getString("Clientes_email"));
            }
            
        } catch (Exception e) {
            System.err.println("Error al leer datos: " + e.getMessage());
        }
    }
}