package com.mycompany.billeteradigitalweb.service;

import com.mycompany.billeteradigitalweb.dao.RecargaDAO;
import com.mycompany.billeteradigitalweb.model.Recarga;
import java.sql.SQLException;
import java.math.BigDecimal;

public class RecargaService {
    private final RecargaDAO recargaDAO = new RecargaDAO();

    public void realizarRecarga(BigDecimal monto, int idCuenta, int idMetodo) throws SQLException {
        // Validaciones básicas
        if (monto == null || monto.compareTo(BigDecimal.ZERO) <= 0) {
            throw new SQLException("El monto debe ser positivo");
        }
        
        if (idCuenta <= 0) {
            throw new SQLException("ID de cuenta no válido");
        }
        
        if (idMetodo <= 0) {
            throw new SQLException("Método de pago no válido");
        }

        Recarga recarga = new Recarga(monto, idCuenta, idMetodo);
        recargaDAO.realizarRecarga(recarga);
    }
}