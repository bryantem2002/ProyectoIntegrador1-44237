package com.mycompany.billeteradigitalweb.model;

import java.sql.Timestamp;
import java.math.BigDecimal;

public class Cuenta {
    private int idCuenta;
    private String numeroCuenta;
    private BigDecimal saldo;
    private int idUsuario;
    private int idEstado;
    private Timestamp fechaCreacion;

    // Constructores
    public Cuenta() {}

    public Cuenta(String numeroCuenta, BigDecimal saldo, int idUsuario, int idEstado) {
        this.numeroCuenta = numeroCuenta;
        this.saldo = saldo;
        this.idUsuario = idUsuario;
        this.idEstado = idEstado;
    }

    // Getters y Setters
    public int getIdCuenta() { return idCuenta; }
    public void setIdCuenta(int idCuenta) { this.idCuenta = idCuenta; }

    public String getNumeroCuenta() { return numeroCuenta; }
    public void setNumeroCuenta(String numeroCuenta) { this.numeroCuenta = numeroCuenta; }

    public BigDecimal getSaldo() { return saldo; }
    public void setSaldo(BigDecimal saldo) { this.saldo = saldo; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public int getIdEstado() { return idEstado; }
    public void setIdEstado(int idEstado) { this.idEstado = idEstado; }

    public Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }
}