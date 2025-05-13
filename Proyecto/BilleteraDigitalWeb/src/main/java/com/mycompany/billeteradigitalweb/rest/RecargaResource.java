package com.mycompany.billeteradigitalweb.rest;

import com.mycompany.billeteradigitalweb.model.Usuario;
import com.mycompany.billeteradigitalweb.service.RecargaService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.math.BigDecimal;
import java.sql.SQLException;

@Path("/recargas")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class RecargaResource {
    private final RecargaService recargaService = new RecargaService();

    @POST
    public Response realizarRecarga(
            @QueryParam("monto") BigDecimal monto,
            @QueryParam("metodo") int idMetodo,
            @Context HttpServletRequest request) {
        
        // Verificar sesión y obtener usuario
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        // Obtener ID de cuenta desde la sesión
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null || usuario.getCuenta() == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"No se encontró la cuenta del usuario\"}")
                    .build();
        }

        int idCuenta = usuario.getCuenta().getIdCuenta();

        try {
            recargaService.realizarRecarga(monto, idCuenta, idMetodo);
            return Response.ok("{\"mensaje\": \"Recarga realizada con éxito\"}").build();
        } catch (SQLException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
}