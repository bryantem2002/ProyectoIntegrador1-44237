package com.mycompany.billeteradigitalweb.model;

import java.math.BigDecimal;

public class Recarga {
    private BigDecimal monto;
    private int idCuenta;
    private int idMetodo;

    // Constructores
    public Recarga() {}

    public Recarga(BigDecimal monto, int idCuenta, int idMetodo) {
        this.monto = monto;
        this.idCuenta = idCuenta;
        this.idMetodo = idMetodo;
    }

    // Getters y Setters
    public BigDecimal getMonto() { return monto; }
    public void setMonto(BigDecimal monto) { this.monto = monto; }

    public int getIdCuenta() { return idCuenta; }
    public void setIdCuenta(int idCuenta) { this.idCuenta = idCuenta; }

    public int getIdMetodo() { return idMetodo; }
    public void setIdMetodo(int idMetodo) { this.idMetodo = idMetodo; }
}