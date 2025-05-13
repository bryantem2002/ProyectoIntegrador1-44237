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

            // Guardar usuario en sesión (con todos sus datos)
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            // Devolver solo mensaje de éxito
            return Response.ok("{\"message\": \"Sesión iniciada correctamente\"}").build();
        } catch (Exception e) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/cuenta")
    public Response getCuentaUsuario(@Context HttpServletRequest request) {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        // Obtener usuario de la sesión
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
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        // Obtener usuario de la sesión
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

        try {
            // Obtener datos actualizados de la base de datos
            Usuario usuario = usuarioService.getUsuarioById(usuarioSesion.getIdUsuario());

            // No devolver la contraseña
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
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        try {
            Usuario usuario = usuarioService.getUsuarioByNumeroCuenta(numeroCuenta);

            // Crear un objeto con solo los datos necesarios
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
}
