package com.mycompany.billeteradigitalweb.rest;

import com.mycompany.billeteradigitalweb.model.Cuenta;
import com.mycompany.billeteradigitalweb.model.Usuario;
import com.mycompany.billeteradigitalweb.service.UsuarioService;
import jakarta.json.Json;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;

@Path("/usuarios")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UsuarioResource {

    private final UsuarioService usuarioService = new UsuarioService();

    @GET
    @Path("/dni/{dni}")
    public Response checkDni(@PathParam("dni") String dni) {
        try {
            boolean exists = usuarioService.existsByDni(dni);
            return Response.ok("{\"exists\": " + exists + "}").build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/correo/{correo}")
    public Response checkCorreo(@PathParam("correo") String correo) {
        try {
            boolean exists = usuarioService.existsByCorreo(correo);
            return Response.ok("{\"exists\": " + exists + "}").build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @POST
    @Path("/register")
    public Response registerUser(Usuario usuario) {
        try {
            usuarioService.registerUser(usuario);
            return Response.status(Response.Status.CREATED)
                    .entity("{\"message\": \"Usuario registrado exitosamente\"}")
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @POST
    @Path("/login")
    public Response loginUser(@QueryParam("correo") String correo,
            @QueryParam("contraseña") String contraseña,
            @Context HttpServletRequest request) {
        try {
            Usuario usuario = usuarioService.loginUser(correo, contraseña);

            if (usuario != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("usuario", usuario);
                if (usuario.getCuenta() != null) {
                    session.setAttribute("numeroCuenta", usuario.getCuenta().getNumeroCuenta());
                }
                return Response.ok("{\"message\": \"Sesión iniciada correctamente\"}").build();
            } else {
                return Response.status(Response.Status.UNAUTHORIZED)
                        .entity("{\"error\": \"Correo o contraseña incorrectos\"}")
                        .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Error al iniciar sesión: " + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/cuenta")
    public Response getCuentaUsuario(@Context HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        try {
            Cuenta cuenta = usuarioService.getCuentaByUsuarioId(usuario.getIdUsuario());
            return Response.ok(cuenta).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @POST
    @Path("/logout")
    public Response logoutUser(@Context HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return Response.ok("{\"message\": \"Sesión cerrada\"}").build();
    }

    @GET
    @Path("/datos")
    public Response getDatosUsuario(@Context HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

        try {
            Usuario usuario = usuarioService.getUsuarioById(usuarioSesion.getIdUsuario());
            usuario.setContraseña(null);
            return Response.ok(usuario).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/cuenta/{numeroCuenta}")
    public Response getInfoCuenta(@PathParam("numeroCuenta") String numeroCuenta,
            @Context HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        try {
            Usuario usuario = usuarioService.getUsuarioByNumeroCuenta(numeroCuenta);
            JsonObjectBuilder builder = Json.createObjectBuilder();
            builder.add("numero_cuenta", usuario.getCuenta().getNumeroCuenta());
            builder.add("nombre", usuario.getNombre());
            builder.add("apellido", usuario.getApellido());
            builder.add("correo", usuario.getCorreo());
            return Response.ok(builder.build()).build();
        } catch (Exception e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
    
    @POST
    @Path("/actualizar")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response actualizarUsuario(
            @FormParam("idUsuario") int idUsuario,
            @FormParam("nombre") String nombre,
            @FormParam("apellido") String apellido,
            @FormParam("dni") String dni,
            @FormParam("telefono") String telefono,
            @FormParam("fechaNacimiento") String fechaNacimientoStr,
            @FormParam("correo") String correo,
            @FormParam("password") String password,
            @Context HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        try {
            Usuario usuario = new Usuario();
            usuario.setIdUsuario(idUsuario);
            usuario.setNombre(nombre);
            usuario.setApellido(apellido);
            usuario.setDni(dni);
            usuario.setTelefono(telefono);
            usuario.setCorreo(correo);

            if (fechaNacimientoStr != null && !fechaNacimientoStr.isEmpty()) {
                Date fechaNacimiento = Date.valueOf(fechaNacimientoStr);
                usuario.setFechaNacimiento(fechaNacimiento);
            }

            if (password != null && !password.trim().isEmpty()) {
                usuario.setContraseña(password);
            }

            usuarioService.actualizarUsuario(usuario);
            session.setAttribute("usuario", usuario);

            return Response.ok("{\"mensaje\": \"Usuario actualizado correctamente\"}").build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Formato de fecha inválido\"}")
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Error al actualizar usuario: " + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/{id}/saldo")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getSaldo(@PathParam("id") int idUsuario) {
        try {
            BigDecimal saldo = usuarioService.obtenerSaldo(idUsuario);
            return Response.ok(new SaldoResponse(saldo, "PEN")).build();
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Error retrieving balance: " + e.getMessage() + "\"}")
                    .build();
        }
    }

    public static class SaldoResponse {
        private BigDecimal saldo;
        private String moneda;

        public SaldoResponse(BigDecimal saldo, String moneda) {
            this.saldo = saldo;
            this.moneda = moneda;
        }

        public BigDecimal getSaldo() { return saldo; }
        public String getMoneda() { return moneda; }
    }
}