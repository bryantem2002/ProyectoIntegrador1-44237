<!DOCTYPE html>
<%@ page import="com.mycompany.billeteradigitalweb.model.Usuario" %>
<html lang="es" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Registro</title>
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet" type="text/css" />
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
  
</head>
<body class="min-h-screen flex items-center justify-center bg-black/50 bg-opacity-60" style="
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
  <!-- Modal para menor de edad -->
  <dialog id="age-modal" class="modal">
    <div class="modal-box max-w-md bg-white rounded-2xl p-0 overflow-hidden">
      <div class="bg-[#513dc4] p-6 text-center">
        <h3 class="font-bold text-2xl text-white">¡Ups! No puedes registrarte</h3>
      </div>
      <div class="p-6 text-center">
        <div class="flex justify-center mb-4">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
        </div>
        <p class="text-lg font-medium text-gray-700 mb-2">Lo sentimos, pero eres menor de edad.</p>
        <p class="text-gray-500 mb-6">De acuerdo a nuestros términos y condiciones, no puedes completar el registro.</p>
        <button onclick="document.getElementById('age-modal').close()" class="btn w-full bg-[#513dc4] text-white hover:bg-[#3a2b8f]">
          Entendido
        </button>
      </div>
    </div>
  </dialog>

  <div class="container px-4 sm:px-6 lg:px-8">
    <div class="card max-w-md mx-auto bg-white shadow-2xl rounded-3xl overflow-hidden transition-all duration-500" id="card-content">
      <!-- Contenido dinámico cargado por JavaScript -->
    </div>
  </div>

  <script src="js/api.js" type="module"></script>
  <script src="js/register.js" type="module"></script>
</body>
</html>