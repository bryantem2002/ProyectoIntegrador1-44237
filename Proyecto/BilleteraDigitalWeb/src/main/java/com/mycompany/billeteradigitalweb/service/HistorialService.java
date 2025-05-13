package com.mycompany.billeteradigitalweb.service;

import com.mycompany.billeteradigitalweb.dao.HistorialDAO;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class HistorialService {
    private final HistorialDAO historialDAO = new HistorialDAO();

    public List<Map<String, Object>> obtenerHistorialCombinado(int idUsuario) throws SQLException {
        if (idUsuario <= 0) {
            throw new SQLException("ID de usuario no válido");
        }
        return historialDAO.obtenerHistorialCombinado(idUsuario);
    }
}