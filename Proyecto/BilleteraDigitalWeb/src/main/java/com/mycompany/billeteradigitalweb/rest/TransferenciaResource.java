package com.mycompany.billeteradigitalweb.rest;

import com.mycompany.billeteradigitalweb.model.Transferencia;
import com.mycompany.billeteradigitalweb.model.Usuario;
import com.mycompany.billeteradigitalweb.service.TransferenciaService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;




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

@GET
    @Path("/por-mes")
    public Response transferenciasPorMes() {
        try {
            int[] cantidades = transferenciaService.obtenerTransferenciasPorMes();
            String[] meses = {"Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"};
            Map<String, Object> result = new HashMap<>();
            result.put("meses", meses);
            result.put("cantidades", cantidades);
            return Response.ok(result).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
   @GET
    @Path("/ingresos")
    public Response obtenerIngresosPorMes(@Context HttpServletRequest request) {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity(Map.of("error", "No autorizado"))
                    .build();
        }

        // Obtener usuario de la sesión
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        int idUsuario = usuario.getIdUsuario();

        try {
            BigDecimal[] ingresos = transferenciaService.obtenerIngresosPorMes(idUsuario);
            Map<String, BigDecimal> resultado = new HashMap<>();
            for (int i = 0; i < 12; i++) {
                resultado.put("mes" + (i + 1), ingresos[i] != null ? ingresos[i] : BigDecimal.ZERO);
            }
            return Response.ok(resultado).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(Map.of("error", "Error al obtener ingresos: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/gastos")
    public Response obtenerGastosPorMes(@Context HttpServletRequest request) {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity(Map.of("error", "No autorizado"))
                    .build();
        }

        // Obtener usuario de la sesión
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        int idUsuario = usuario.getIdUsuario();

        try {
            BigDecimal[] gastos = transferenciaService.obtenerGastosPorMes(idUsuario);
            Map<String, BigDecimal> resultado = new HashMap<>();
            for (int i = 0; i < 12; i++) {
                resultado.put("mes" + (i + 1), gastos[i] != null ? gastos[i] : BigDecimal.ZERO);
            }
            return Response.ok(resultado).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(Map.of("error", "Error al obtener gastos: " + e.getMessage()))
                    .build();
        }
    }
}
