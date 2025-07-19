<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.billeteradigitalweb.model.Usuario" %>
<html lang="es" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Iniciar Sesión</title>
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet" type="text/css" />
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
  <style>
    .animate-fade-in {
      animation: fadeIn 0.5s ease-in-out;
    }
    .animate-slide-in {
      animation: slideIn 0.5s ease-in-out;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes slideIn {
      from { opacity: 0; transform: translateX(-10px); }
      to { opacity: 1; transform: translateX(0); }
    }
  </style>
</head>
<body class="min-h-screen flex items-center justify-center bg-black/50 bg-opacity-0" style="
  background-image: url('img/fondo4.png');
  background-size: 100%;
  background-position: center top;">
  <%
    // Verificar si hay una sesión activa
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario != null) {
      response.sendRedirect(request.getContextPath() + "/panelUsuario.jsp");
      return;
    }
  %>
  <div class="container px-4 sm:px-6 lg:px-8">
    <div class="card max-w-md mx-auto bg-white shadow-2xl rounded-3xl overflow-hidden transition-all duration-500" id="card-content">
      <div class="flex justify-center items-center h-64">
        <span class="loading loading-spinner text-[#2bb15d]"></span>
      </div>
    </div>
  </div>
  <script src="js/loginn.js"></script>
</body>
</html>