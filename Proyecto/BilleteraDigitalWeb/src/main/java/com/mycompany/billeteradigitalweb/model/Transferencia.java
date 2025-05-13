package com.mycompany.billeteradigitalweb.model;

import java.math.BigDecimal;

public class Transferencia {
    private String cuentaOrigen;
    private String cuentaDestino;
    private BigDecimal monto;
    private String mensaje;

    // Constructores
    public Transferencia() {}

    public Transferencia(String cuentaOrigen, String cuentaDestino, BigDecimal monto, String mensaje) {
        this.cuentaOrigen = cuentaOrigen;
        this.cuentaDestino = cuentaDestino;
        this.monto = monto;
        this.mensaje = mensaje;
    }

    // Getters y Setters
    public String getCuentaOrigen() { return cuentaOrigen; }
    public void setCuentaOrigen(String cuentaOrigen) { this.cuentaOrigen = cuentaOrigen; }

    public String getCuentaDestino() { return cuentaDestino; }
    public void setCuentaDestino(String cuentaDestino) { this.cuentaDestino = cuentaDestino; }

    public BigDecimal getMonto() { return monto; }
    public void setMonto(BigDecimal monto) { this.monto = monto; }

    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }
}