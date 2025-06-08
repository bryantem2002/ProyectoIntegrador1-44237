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
import java.util.*;

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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            return Response.status(Response.Status.UNAUTHORIZED)
                    .entity("{\"error\": \"No autorizado\"}")
                    .build();
        }

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

    // Endpoint para gráfico: Recargas por Mes
    @GET
    @Path("/por-mes")
    public Response recargasPorMes() {
        try {
            int[] cantidades = recargaService.obtenerRecargasPorMes();
            String[] meses = {"Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"};
            Map<String, Object> result = new HashMap<>();
            result.put("meses", meses);
            result.put("cantidades", cantidades);
            return Response.ok(result).build();
        } catch (Exception e) {
            return Response.serverError().entity("{\"error\": \"" + e.getMessage() + "\"}").build();
        }
    }

    @GET
@Path("/por-tipo")
public Response recargasPorTipo() {
    try {
        Map<String, Integer> datos = recargaService.obtenerRecargasPorTipo();

        if (datos == null || datos.isEmpty()) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "No hay datos disponibles para mostrar");
            return Response.status(Response.Status.NO_CONTENT).entity(error).build();
        }

        List<String> tipos = new ArrayList<>(datos.keySet());
        List<Integer> cantidades = new ArrayList<>();

        for (String tipo : tipos) {
            cantidades.add(datos.get(tipo));
        }

        Map<String, Object> result = new HashMap<>();
        result.put("tipos", tipos);
        result.put("cantidades", cantidades);

        return Response.ok(result).build();

    } catch (Exception e) {
        Map<String, String> error = new HashMap<>();
        error.put("error", e.getMessage());
        return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
    }
}
}