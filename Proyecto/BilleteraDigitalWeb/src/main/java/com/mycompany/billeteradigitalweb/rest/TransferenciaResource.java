package com.mycompany.billeteradigitalweb.rest;

import com.mycompany.billeteradigitalweb.model.Transferencia;
import com.mycompany.billeteradigitalweb.service.TransferenciaService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Path("/transferencias")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TransferenciaResource {
    private final TransferenciaService transferenciaService = new TransferenciaService();

    @POST
    public Response realizarTransferencia(
            @QueryParam("origen") String cuentaOrigen,
            @QueryParam("destino") String cuentaDestino,
            @QueryParam("monto") BigDecimal monto,
            @QueryParam("mensaje") String mensaje,
            @Context HttpServletRequest request) {
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

        try {
            transferenciaService.realizarTransferencia(cuentaOrigen, cuentaDestino, monto, mensaje);
            return Response.ok("{\"mensaje\": \"Transferencia realizada con éxito\"}").build();
        } catch (SQLException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
    @GET
@Path("/historial")
public Response obtenerHistorial(
        @QueryParam("cuenta") String numeroCuenta,
        @Context HttpServletRequest request) {
    
    // Verificar sesión
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("usuario") == null) {
        return Response.status(Response.Status.UNAUTHORIZED)
                .entity("{\"error\": \"No autorizado\"}")
                .build();
    }
    
    try {
        List<Map<String, Object>> historial = transferenciaService.obtenerHistorial(numeroCuenta);
        return Response.ok(historial).build();
    } catch (SQLException e) {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity("{\"error\": \"" + e.getMessage() + "\"}")
                .build();
    }
}
}