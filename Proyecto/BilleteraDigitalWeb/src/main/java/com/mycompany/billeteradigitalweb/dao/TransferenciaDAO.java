package com.mycompany.billeteradigitalweb.dao;

import com.mycompany.billeteradigitalweb.DatabaseConfig.DatabaseConnection;
import com.mycompany.billeteradigitalweb.model.Transferencia;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class TransferenciaDAO {
    
    public void realizarTransferencia(Transferencia transferencia) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getInstance().getConnection();
            conn.setAutoCommit(false); // Iniciar transacción

            // 1. Verificar si las cuentas existen
            if (!existeCuenta(conn, transferencia.getCuentaOrigen()) || 
                !existeCuenta(conn, transferencia.getCuentaDestino())) {
                throw new SQLException("Una de las cuentas no existe");
            }

            // 2. Verificar saldo suficiente en cuenta origen
            BigDecimal saldoOrigen = obtenerSaldo(conn, transferencia.getCuentaOrigen());
            if (saldoOrigen.compareTo(transferencia.getMonto()) < 0) {
                throw new SQLException("Saldo insuficiente");
            }

            // 3. Actualizar saldos (restar de origen, sumar a destino)
            actualizarSaldo(conn, transferencia.getCuentaOrigen(), transferencia.getMonto().negate());
            actualizarSaldo(conn, transferencia.getCuentaDestino(), transferencia.getMonto());

            // 4. Registrar la transferencia
            registrarTransferencia(conn, transferencia);

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

    private boolean existeCuenta(Connection conn, String numeroCuenta) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Cuenta WHERE numero_cuenta = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, numeroCuenta);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    private BigDecimal obtenerSaldo(Connection conn, String numeroCuenta) throws SQLException {
        String sql = "SELECT saldo FROM Cuenta WHERE numero_cuenta = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, numeroCuenta);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("saldo");
                }
                throw new SQLException("Cuenta no encontrada");
            }
        }
    }

    private void actualizarSaldo(Connection conn, String numeroCuenta, BigDecimal monto) throws SQLException {
        String sql = "UPDATE Cuenta SET saldo = saldo + ? WHERE numero_cuenta = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBigDecimal(1, monto);
            stmt.setString(2, numeroCuenta);
            int affected = stmt.executeUpdate();
            if (affected == 0) {
                throw new SQLException("No se pudo actualizar el saldo");
            }
        }
    }

    private void registrarTransferencia(Connection conn, Transferencia transferencia) throws SQLException {
        String sql = "INSERT INTO Transferencia (cuenta_origen, cuenta_destino, monto, mensaje) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, transferencia.getCuentaOrigen());
            stmt.setString(2, transferencia.getCuentaDestino());
            stmt.setBigDecimal(3, transferencia.getMonto());
            stmt.setString(4, transferencia.getMensaje());
            stmt.executeUpdate();
        }
    }

    public List<Map<String, Object>> obtenerHistorialTransferencias(String numeroCuenta) throws SQLException {
        String sql = "SELECT t.id_transferencia, t.fecha, t.monto, t.mensaje, " +
                     "t.cuenta_origen, t.cuenta_destino, " +
                     "CASE WHEN t.cuenta_origen = ? THEN 'Egreso' " +
                     "     WHEN t.cuenta_destino = ? THEN 'Ingreso' END AS tipo_movimiento " +
                     "FROM Transferencia t " +
                     "WHERE t.cuenta_origen = ? OR t.cuenta_destino = ? " +
                     "ORDER BY t.fecha DESC";
        
        List<Map<String, Object>> historial = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, numeroCuenta);
            stmt.setString(2, numeroCuenta);
            stmt.setString(3, numeroCuenta);
            stmt.setString(4, numeroCuenta);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> movimiento = new LinkedHashMap<>();
                    movimiento.put("id", rs.getInt("id_transferencia"));
                    movimiento.put("fecha", rs.getTimestamp("fecha"));
                    movimiento.put("monto", rs.getBigDecimal("monto"));
                    movimiento.put("mensaje", rs.getString("mensaje"));
                    movimiento.put("cuenta_origen", rs.getString("cuenta_origen"));
                    movimiento.put("cuenta_destino", rs.getString("cuenta_destino"));
                    movimiento.put("tipo", rs.getString("tipo_movimiento"));
                    
                    historial.add(movimiento);
                }
            }
        }
        return historial;
    }
}