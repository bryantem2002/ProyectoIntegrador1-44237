package com.mycompany.billeteradigitalweb.dao;

import com.mycompany.billeteradigitalweb.DatabaseConfig.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HistorialDAO {
    
    public List<Map<String, Object>> obtenerHistorialCombinado(int idUsuario) throws SQLException {
        String sql = "SELECT " +
                     "t.id_transferencia AS id_movimiento, " +
                     "t.fecha, " +
                     "t.monto, " +
                     "t.mensaje, " +
                     "t.cuenta_origen, " +
                     "t.cuenta_destino, " +
                     "CASE " +
                     "   WHEN t.cuenta_origen = c.numero_cuenta THEN 'Egreso' " +
                     "   WHEN t.cuenta_destino = c.numero_cuenta THEN 'Ingreso' " +
                     "END AS tipo_movimiento, " +
                     "'Transferencia' AS origen " +
                     "FROM Transferencia t " +
                     "JOIN Cuenta c ON c.numero_cuenta = t.cuenta_origen OR c.numero_cuenta = t.cuenta_destino " +
                     "WHERE c.id_usuario = ? " +
                     "UNION ALL " +
                     "SELECT " +
                     "r.id_recarga AS id_movimiento, " +
                     "r.fecha, " +
                     "r.monto, " +
                     "CONCAT('Recarga vía ', m.metodo) AS mensaje, " +
                     "NULL AS cuenta_origen, " +
                     "c.numero_cuenta AS cuenta_destino, " +
                     "'Recarga' AS tipo_movimiento, " +
                     "'Recarga' AS origen " +
                     "FROM Recarga r " +
                     "JOIN Cuenta c ON r.id_cuenta = c.id_cuenta " +
                     "JOIN Metodo_Pago m ON r.id_metodo = m.id_metodo " +
                     "WHERE c.id_usuario = ? " +
                     "ORDER BY fecha DESC";

        List<Map<String, Object>> historial = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idUsuario);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> movimiento = new HashMap<>();
                    movimiento.put("id", rs.getInt("id_movimiento"));
                    movimiento.put("fecha", rs.getTimestamp("fecha"));
                    movimiento.put("monto", rs.getBigDecimal("monto"));
                    movimiento.put("mensaje", rs.getString("mensaje"));
                    movimiento.put("cuenta_origen", rs.getString("cuenta_origen"));
                    movimiento.put("cuenta_destino", rs.getString("cuenta_destino"));
                    movimiento.put("tipo", rs.getString("tipo_movimiento"));
                    movimiento.put("origen", rs.getString("origen"));
                    
                    historial.add(movimiento);
                }
            }
        }
        return historial;
    }
}