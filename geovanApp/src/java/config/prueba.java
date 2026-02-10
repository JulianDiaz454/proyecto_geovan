package config;

import java.sql.Connection;

public class prueba {
    public static void main(String[] args) {
        conexion con = new conexion();
        Connection c = con.getConnection();
        
        if (c != null) {
            System.out.println("Conexion exitosa.");
        } else {
            System.err.println("Error: No se pudo realizar la conexion.");
        }
    }
}