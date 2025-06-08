package com.mycompany.billeteradigitalweb.service;

import com.mycompany.billeteradigitalweb.dao.UsuarioDAO;
import com.mycompany.billeteradigitalweb.model.Cuenta;
import com.mycompany.billeteradigitalweb.model.Usuario;
import java.math.BigDecimal;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt; 

public class UsuarioService {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    public void registerUser(Usuario usuario) throws SQLException {
        if (usuarioDAO.existsByDni(usuario.getDni())) {
            throw new SQLException("El DNI ya está registrado");
        }
        if (usuarioDAO.existsByCorreo(usuario.getCorreo())) {
            throw new SQLException("El correo ya está registrado");
        }
        if (usuario.getContraseña().length() != 6) {
            throw new SQLException("La contraseña debe tener exactamente 6 caracteres");
        }
        if (!usuario.getDni().matches("\\d{8}")) {
            throw new SQLException("El DNI debe tener 8 dígitos");
        }
        
        // Hashear la contraseña antes de registrarla
        String hashedPassword = BCrypt.hashpw(usuario.getContraseña(), BCrypt.gensalt());
        usuario.setContraseña(hashedPassword);
        
        usuarioDAO.registerUser(usuario); // Esto ahora también crea la cuenta
    }

    public boolean existsByDni(String dni) throws SQLException {
        return usuarioDAO.existsByDni(dni);
    }

    public boolean existsByCorreo(String correo) throws SQLException {
        return usuarioDAO.existsByCorreo(correo);
    }

    public Usuario loginUser(String correo, String contraseña) throws SQLException {
        Usuario usuario = usuarioDAO.loginUser(correo, contraseña);
        if (usuario == null) {
            throw new SQLException("Correo o contraseña incorrectos");
        }
        return usuario;
    }

    public Cuenta getCuentaByUsuarioId(int idUsuario) throws SQLException {
        return usuarioDAO.getCuentaByUsuarioId(idUsuario);
    }

    public Usuario getUsuarioById(int idUsuario) throws SQLException {
        return usuarioDAO.getUsuarioById(idUsuario);
    }

    public Usuario getUsuarioByNumeroCuenta(String numeroCuenta) throws SQLException {
        if (numeroCuenta == null || numeroCuenta.trim().isEmpty()) {
            throw new SQLException("Número de cuenta no válido");
        }
        return usuarioDAO.getUsuarioByNumeroCuenta(numeroCuenta);
    }
    
    
    
     public void actualizarUsuario(Usuario usuario) throws SQLException {
        // Validaciones básicas (puedes ampliar según necesidades)

        if (usuario.getDni() == null || !usuario.getDni().matches("\\d{8}")) {
            throw new SQLException("El DNI debe tener 8 dígitos");
        }

        if (usuario.getCorreo() == null || usuario.getCorreo().trim().isEmpty()) {
            throw new SQLException("El correo es obligatorio");
        }

        if (usuario.getContraseña() != null && !usuario.getContraseña().trim().isEmpty()) {
            // Validar longitud de contraseña si se actualiza
            if (usuario.getContraseña().length() != 6) {
                throw new SQLException("La contraseña debe tener exactamente 6 caracteres");
            }
            // Hashear la contraseña nueva
            String hashedPassword = BCrypt.hashpw(usuario.getContraseña(), BCrypt.gensalt());
            usuario.setContraseña(hashedPassword);
        } else {
            // Si no se actualiza la contraseña, obtener la actual de la BD para no sobreescribir con null
            Usuario usuarioExistente = usuarioDAO.getUsuarioById(usuario.getIdUsuario());
            if (usuarioExistente != null) {
                usuario.setContraseña(usuarioExistente.getContraseña());
            } else {
                throw new SQLException("Usuario no encontrado");
            }
        }

        // Llamar al DAO para actualizar los datos
        usuarioDAO.actualizarUsuario(usuario);
    }
     
    public BigDecimal obtenerSaldo(int idUsuario) throws SQLException {
    return usuarioDAO.getSaldoByUsuarioId(idUsuario);
}
}
    
   
    
    
    
    
   