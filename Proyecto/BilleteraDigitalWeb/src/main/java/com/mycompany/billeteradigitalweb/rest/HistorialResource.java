package com.mycompany.billeteradigitalweb.rest;

import com.mycompany.billeteradigitalweb.model.Usuario;
import com.mycompany.billeteradigitalweb.service.HistorialService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Path("/historial")
@Produces(MediaType.APPLICATION_JSON)
public class HistorialResource {
    private final HistorialService historialService = new HistorialService();

    @GET
    @Path("/combinado")
    public Response obtenerHistorialCombinado(@Context HttpServletRequest request) {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        // Obtener ID de usuario desde la sesión
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"Usuario no encontrado en sesión\"}")
                    .build();
        }

        try {
            List<Map<String, Object>> historial = historialService.obtenerHistorialCombinado(usuario.getIdUsuario());
            return Response.ok(historial).build();
        } catch (SQLException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
}