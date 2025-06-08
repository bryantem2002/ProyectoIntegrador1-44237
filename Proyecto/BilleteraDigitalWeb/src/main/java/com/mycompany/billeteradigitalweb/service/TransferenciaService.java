package com.mycompany.billeteradigitalweb.service;

import com.mycompany.billeteradigitalweb.dao.TransferenciaDAO;
import com.mycompany.billeteradigitalweb.model.Transferencia;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public class TransferenciaService {
    private final TransferenciaDAO transferenciaDAO = new TransferenciaDAO();

    public void realizarTransferencia(String cuentaOrigen, String cuentaDestino, BigDecimal monto, String mensaje) 
            throws SQLException {
        
        // Validaciones básicas
        if (cuentaOrigen == null || cuentaDestino == null || cuentaOrigen.equals(cuentaDestino)) {
            throw new SQLException("Cuentas no válidas");
        }
        
        if (monto == null || monto.compareTo(BigDecimal.ZERO) <= 0) {
            throw new SQLException("Monto debe ser positivo");
        }

        Transferencia transferencia = new Transferencia(cuentaOrigen, cuentaDestino, monto, mensaje);
        transferenciaDAO.realizarTransferencia(transferencia);
    }
    public List<Map<String, Object>> obtenerHistorial(String numeroCuenta) throws SQLException {
    if (numeroCuenta == null || numeroCuenta.trim().isEmpty()) {
        throw new SQLException("Número de cuenta no válido");
    }
    return transferenciaDAO.obtenerHistorialTransferencias(numeroCuenta);
}
    
    
    public int[] obtenerTransferenciasPorMes() throws SQLException {
        return transferenciaDAO.obtenerTransferenciasPorMes();
    } 

   
    public BigDecimal[] obtenerIngresosPorMes(int idUsuario) throws SQLException {
        return transferenciaDAO.obtenerIngresosPorMes(idUsuario);
    }

    public BigDecimal[] obtenerGastosPorMes(int idUsuario) throws SQLException {
        return transferenciaDAO.obtenerGastosPorMes(idUsuario);
    }
     
    
}