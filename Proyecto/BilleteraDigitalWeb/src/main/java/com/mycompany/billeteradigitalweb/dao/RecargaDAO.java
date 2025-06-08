package com.mycompany.billeteradigitalweb.dao;

import com.mycompany.billeteradigitalweb.DatabaseConfig.DatabaseConnection;
import com.mycompany.billeteradigitalweb.model.Recarga;
import java.sql.*;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class RecargaDAO {
    
    public void realizarRecarga(Recarga recarga) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getInstance().getConnection();
            conn.setAutoCommit(false); // Iniciar transacción

            // 1. Verificar que el método de pago exista
            if (!metodoPagoExiste(conn, recarga.getIdMetodo())) {
                throw new SQLException("Método de pago no válido");
            }

            // 2. Verificar que la cuenta exista
            if (!cuentaExiste(conn, recarga.getIdCuenta())) {
                throw new SQLException("Cuenta no encontrada");
            }

            // 3. Registrar la recarga
            registrarRecarga(conn, recarga);

            // 4. Actualizar saldo de la cuenta
            actualizarSaldo(conn, recarga.getIdCuenta(), recarga.getMonto());

            conn.commit(); // Confirmar transacción
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback(); // Revertir en caso de error
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    private boolean metodoPagoExiste(Connection conn, int idMetodo) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Metodo_Pago WHERE id_metodo = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idMetodo);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    private boolean cuentaExiste(Connection conn, int idCuenta) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Cuenta WHERE id_cuenta = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCuenta);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    private void registrarRecarga(Connection conn, Recarga recarga) throws SQLException {
        String sql = "INSERT INTO Recarga (monto, id_cuenta, id_metodo) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setBigDecimal(1, recarga.getMonto());
            stmt.setInt(2, recarga.getIdCuenta());
            stmt.setInt(3, recarga.getIdMetodo());
            stmt.executeUpdate();
        }
    }

    private void actualizarSaldo(Connection conn, int idCuenta, BigDecimal monto) throws SQLException {
        String sql = "UPDATE Cuenta SET saldo = saldo + ? WHERE id_cuenta = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBigDecimal(1, monto);
            stmt.setInt(2, idCuenta);
            int affected = stmt.executeUpdate();
            if (affected == 0) {
                throw new SQLException("No se pudo actualizar el saldo");
            }
        }
    }
    
    // Recargas por mes
public int[] obtenerRecargasPorMes() throws SQLException {
    int[] recargasPorMes = new int[12]; // 12 meses
    String sql = "SELECT MONTH(fecha) AS mes, COUNT(*) AS cantidad FROM Recarga GROUP BY mes";
    try (Connection conn = DatabaseConnection.getInstance().getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
            int mes = rs.getInt("mes");
            int cantidad = rs.getInt("cantidad");
            recargasPorMes[mes - 1] = cantidad; // mes 1 = enero
        }
    }
    return recargasPorMes;
}

// Recargas por tipo (Izipay, Yape, etc.)
public Map<String, Integer> obtenerRecargasPorTipo() throws SQLException {
    Map<String, Integer> recargasPorTipo = new LinkedHashMap<>(); // Mantener orden

    String sql = "SELECT mp.metodo, COUNT(r.id_recarga) AS cantidad " +
                 "FROM Recarga r " +
                 "JOIN metodo_pago mp ON r.id_metodo = mp.id_metodo " +
                 "GROUP BY mp.metodo " +
                 "ORDER BY mp.metodo";

    try (Connection conn = DatabaseConnection.getInstance().getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            String metodo = rs.getString("metodo"); // nombre del método (Izipay, Yape)
            int cantidad = rs.getInt("cantidad");
            recargasPorTipo.put(metodo, cantidad);
        }
    }
    return recargasPorTipo;
}
       
}