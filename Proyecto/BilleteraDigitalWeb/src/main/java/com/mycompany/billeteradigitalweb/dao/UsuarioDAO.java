package com.mycompany.billeteradigitalweb.dao;

import com.mycompany.billeteradigitalweb.DatabaseConfig.DatabaseConnection;
import com.mycompany.billeteradigitalweb.model.Usuario;
import com.mycompany.billeteradigitalweb.model.Cuenta;
import java.math.BigDecimal;
import java.sql.*;
import java.util.Random;
import org.mindrot.jbcrypt.BCrypt;

public class UsuarioDAO {

    public void registerUser(Usuario usuario) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getInstance().getConnection();
            conn.setAutoCommit(false); // Iniciar transacción

            // Registrar usuario
            String sqlUsuario = "INSERT INTO Usuario (nombre, apellido, correo, contraseña, dni, telefono, fecha_nacimiento) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, usuario.getNombre());
                stmt.setString(2, usuario.getApellido());
                stmt.setString(3, usuario.getCorreo());
                stmt.setString(4, usuario.getContraseña()); // Almacena el hash
                stmt.setString(5, usuario.getDni());
                stmt.setString(6, usuario.getTelefono());
                stmt.setDate(7, usuario.getFechaNacimiento());
                stmt.executeUpdate();

                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        usuario.setIdUsuario(rs.getInt(1));
                    }
                }
            }

            // Crear cuenta para el usuario
            createCuenta(conn, usuario.getIdUsuario());

            conn.commit(); // Confirmar transacción
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Revertir transacción en caso de error
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
    }

    private String generateNumeroCuenta(Connection conn) throws SQLException {
        Random random = new Random();
        String numeroCuenta;
        boolean exists;

        do {
            StringBuilder sb = new StringBuilder(14);
            for (int i = 0; i < 14; i++) {
                sb.append(random.nextInt(10));
            }
            numeroCuenta = sb.toString();

            String sql = "SELECT COUNT(*) FROM Cuenta WHERE numero_cuenta = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, numeroCuenta);
                try (ResultSet rs = stmt.executeQuery()) {
                    rs.next();
                    exists = rs.getInt(1) > 0;
                }
            }
        } while (exists);

        return numeroCuenta;
    }

    private void createCuenta(Connection conn, int idUsuario) throws SQLException {
        String sql = "INSERT INTO Cuenta (numero_cuenta, saldo, id_usuario, id_estado) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, generateNumeroCuenta(conn));
            stmt.setBigDecimal(2, new java.math.BigDecimal("0.00"));
            stmt.setInt(3, idUsuario);
            stmt.setInt(4, 1); // id_estado = 1 para "Activa"
            stmt.executeUpdate();
        }
    }

    public boolean existsByDni(String dni) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Usuario WHERE dni = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dni);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public boolean existsByCorreo(String correo) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Usuario WHERE correo = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, correo);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public Usuario loginUser(String correo, String contraseña) throws SQLException {
        String sqlUsuario = "SELECT * FROM Usuario WHERE correo = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sqlUsuario)) {
            stmt.setString(1, correo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("contraseña");
                    // Verificar la contraseña con BCrypt
                    if (BCrypt.checkpw(contraseña, hashedPassword)) {
                        Usuario usuario = new Usuario();
                        usuario.setIdUsuario(rs.getInt("id_usuario"));
                        usuario.setNombre(rs.getString("nombre"));
                        usuario.setApellido(rs.getString("apellido"));
                        usuario.setCorreo(rs.getString("correo"));
                        usuario.setContraseña(hashedPassword); // Almacenar el hash
                        usuario.setDni(rs.getString("dni"));
                        usuario.setTelefono(rs.getString("telefono"));
                        usuario.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                        usuario.setFechaCreacion(rs.getDate("fecha_creacion"));

                        // Consultar la cuenta asociada
                        String sqlCuenta = "SELECT * FROM Cuenta WHERE id_usuario = ?";
                        try (PreparedStatement stmtCuenta = conn.prepareStatement(sqlCuenta)) {
                            stmtCuenta.setInt(1, usuario.getIdUsuario());
                            try (ResultSet rsCuenta = stmtCuenta.executeQuery()) {
                                if (rsCuenta.next()) {
                                    Cuenta cuenta = new Cuenta();
                                    cuenta.setIdCuenta(rsCuenta.getInt("id_cuenta"));
                                    cuenta.setNumeroCuenta(rsCuenta.getString("numero_cuenta"));
                                    cuenta.setSaldo(rsCuenta.getBigDecimal("saldo"));
                                    cuenta.setIdUsuario(rsCuenta.getInt("id_usuario"));
                                    cuenta.setIdEstado(rsCuenta.getInt("id_estado"));
                                    cuenta.setFechaCreacion(rsCuenta.getTimestamp("fecha_creacion"));
                                    usuario.setCuenta(cuenta);
                                }
                            }
                        }

                        return usuario;
                    }
                }
                return null;
            }
        }
    }

    public Cuenta getCuentaByUsuarioId(int idUsuario) throws SQLException {
        String sql = "SELECT * FROM Cuenta WHERE id_usuario = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Cuenta cuenta = new Cuenta();
                    cuenta.setIdCuenta(rs.getInt("id_cuenta"));
                    cuenta.setNumeroCuenta(rs.getString("numero_cuenta"));
                    cuenta.setSaldo(rs.getBigDecimal("saldo"));
                    cuenta.setIdUsuario(rs.getInt("id_usuario"));
                    cuenta.setIdEstado(rs.getInt("id_estado"));
                    cuenta.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                    return cuenta;
                }
                throw new SQLException("Cuenta no encontrada");
            }
        }
    }

    public Usuario getUsuarioById(int idUsuario) throws SQLException {
        String sql = "SELECT * FROM Usuario WHERE id_usuario = ?";
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("id_usuario"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setApellido(rs.getString("apellido"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setDni(rs.getString("dni"));
                    usuario.setTelefono(rs.getString("telefono"));
                    usuario.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    usuario.setFechaCreacion(rs.getDate("fecha_creacion"));
                    return usuario;
                }
                throw new SQLException("Usuario no encontrado");
            }
        }
    }

    public Usuario getUsuarioByNumeroCuenta(String numeroCuenta) throws SQLException {
        String sql = "SELECT c.numero_cuenta, u.nombre, u.apellido, u.correo " +
                     "FROM Cuenta c JOIN Usuario u ON c.id_usuario = u.id_usuario " +
                     "WHERE c.numero_cuenta = ?";
        
        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, numeroCuenta);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setApellido(rs.getString("apellido"));
                    usuario.setCorreo(rs.getString("correo"));
                    
                    Cuenta cuenta = new Cuenta();
                    cuenta.setNumeroCuenta(rs.getString("numero_cuenta"));
                    usuario.setCuenta(cuenta);
                    
                    return usuario;
                }
                throw new SQLException("Cuenta no encontrada");
            }
        }
    }
    
    public Usuario obtenerUsuarioPorId(Integer idUsuario) throws SQLException {
    String sqlUsuario = "SELECT * FROM Usuario WHERE id_usuario = ?";
    try (Connection conn = DatabaseConnection.getInstance().getConnection();
         PreparedStatement stmt = conn.prepareStatement(sqlUsuario)) {
         
        stmt.setInt(1, idUsuario);
        
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setContraseña(rs.getString("contraseña")); // hash almacenado
                usuario.setDni(rs.getString("dni"));
                usuario.setTelefono(rs.getString("telefono")); // asegúrate que este campo exista
                usuario.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                usuario.setFechaCreacion(rs.getDate("fecha_creacion"));
                
                // Opcional: cargar Cuenta asociada si aplica
                String sqlCuenta = "SELECT * FROM Cuenta WHERE id_usuario = ?";
                try (PreparedStatement stmtCuenta = conn.prepareStatement(sqlCuenta)) {
                    stmtCuenta.setInt(1, idUsuario);
                    try (ResultSet rsCuenta = stmtCuenta.executeQuery()) {
                        if (rsCuenta.next()) {
                            Cuenta cuenta = new Cuenta();
                            cuenta.setIdCuenta(rsCuenta.getInt("id_cuenta"));
                            cuenta.setNumeroCuenta(rsCuenta.getString("numero_cuenta"));
                            cuenta.setSaldo(rsCuenta.getBigDecimal("saldo"));
                            cuenta.setIdUsuario(rsCuenta.getInt("id_usuario"));
                            cuenta.setIdEstado(rsCuenta.getInt("id_estado"));
                            cuenta.setFechaCreacion(rsCuenta.getTimestamp("fecha_creacion"));
                            usuario.setCuenta(cuenta);
                        }
                    }
                }
                
                return usuario;
            }
        }
    }
    return null; // usuario no encontrado
}
    
  
    public void actualizarUsuario(Usuario usuario) throws SQLException {
        String sql = "UPDATE usuario SET nombre = ?, apellido = ?, correo = ?, contraseña = ?, dni = ?, telefono = ?, fecha_nacimiento = ? WHERE id_usuario = ?";

        try (Connection conn = DatabaseConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getApellido());
            stmt.setString(3, usuario.getCorreo());
            stmt.setString(4, usuario.getContraseña());
            stmt.setString(5, usuario.getDni());
            stmt.setString(6, usuario.getTelefono());
            stmt.setDate(7, usuario.getFechaNacimiento());
            stmt.setInt(8, usuario.getIdUsuario());

            stmt.executeUpdate();
        }
    }
    
    
    
    public BigDecimal getSaldoByUsuarioId(int idUsuario) throws SQLException {
    String sql = "SELECT saldo FROM Cuenta WHERE id_usuario = ?";
    try (Connection conn = DatabaseConnection.getInstance().getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, idUsuario);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("saldo");
            }
            throw new SQLException("Cuenta no encontrada para el usuario " + idUsuario);
        }
    }
}
    
   
    
    
}
    