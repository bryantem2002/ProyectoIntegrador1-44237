package com.mycompany.billeteradigitalweb.config;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class CorsFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpServletRequest httpRequest = (HttpServletRequest) request;

        // Permitir solicitudes desde cualquier origen
        httpResponse.setHeader("Access-Control-Allow-Origin", "*");
        // Permitir todos los métodos HTTP
        httpResponse.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        // Permitir todos los encabezados
        httpResponse.setHeader("Access-Control-Allow-Headers", "*");
        // Permitir credenciales (para sesiones)
        httpResponse.setHeader("Access-Control-Allow-Credentials", "true");
        // Tiempo de caché para solicitudes preflight
        httpResponse.setHeader("Access-Control-Max-Age", "3600");

        // Manejar solicitudes preflight (OPTIONS)
        if ("OPTIONS".equalsIgnoreCase(httpRequest.getMethod())) {
            httpResponse.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        // Continuar con la cadena de filtros
        chain.doFilter(request, response);
    }

    @Override
    public void init(jakarta.servlet.FilterConfig filterConfig) throws ServletException {
        // No se necesita inicialización
    }

    @Override
    public void destroy() {
        // No se necesita limpieza
    }
}