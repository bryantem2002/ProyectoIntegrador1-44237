<%--
    Document   : panelUsuario
    Created on : 4 may 2025, 11:12:24
    Author     : USUARIO
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mycompany.billeteradigitalweb.model.Usuario"%>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard de Usuario</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        .glass-effect {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.1);
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-5px); }
            100% { transform: translateY(0px); }
        }

        .hover-float:hover {
            animation: float 2s ease-in-out infinite;
        }

        .sidebar-transition {
            transition: all 0.3s ease-in-out;
        }

        .hide-scrollbar::-webkit-scrollbar {
            display: none;
        }

        .hide-scrollbar {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        .error-message {
            color: red;
            font-size: 0.9rem;
            margin-top: 10px;
            display: none;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 50;
            align-items: center;
            justify-content: center;
            transition: opacity 0.3s ease;
        }

        .modal.active {
            display: flex;
            opacity: 1;
        }

        .modal-content {
            background-color: white;
            border-radius: 1rem;
            padding: 2rem;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            transform: translateY(-50px);
            transition: transform 0.3s ease;
        }

        .modal-content.active {
            transform: translateY(0);
        }

        .alert-error {
            background-color: #ef4444;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .animate-fadeIn {
            animation: fadeIn 0.3s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="bg-gray-50 overflow-x-hidden">
    <%
        // Verificar si hay una sesión activa
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) {
            System.out.println("No hay sesión activa, redirigiendo a login.jsp");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        } else {
            System.out.println("Sesión activa para usuario: " + usuario.getCorreo());
        }
    %>
    <!-- Overlay para móvil -->
    <div id="overlay" class="fixed inset-0 bg-black opacity-0 -z-10 transition-opacity duration-300 md:hidden"></div>

    <div class="fixed top-0 left-0 w-full bg-white md:hidden z-50 px-4 py-4 flex items-center shadow">
        <button id="menuButton" class="text-[#2BB15D] p-2">
            <i class="fas fa-bars text-2xl"></i>
        </button>
        <div class="flex items-center ml-4 space-x-2">
            <img src="<%= request.getContextPath() %>/img/logos.png" alt="Logo" class="w-6 h-6">
            <h1 class="text-xl font-bold">
                <span style="color: #4B34C3;">Faci</span><span style="color: #2BB15D;">Pago</span>
            </h1>
        </div>
    </div>

    <!-- Sidebar principal -->
    <aside id="sidebar" class="fixed top-0 left-0 h-full w-72 -translate-x-full md:translate-x-0 transition-transform duration-300 z-40">
        <div class="absolute inset-0 bg-[#1B2E2A] opacity-90"></div>
        <div class="relative h-full flex flex-col overflow-y-auto">
            <div class="text-center mb-8 pt-6 px-4">
                <div class="flex justify-center items-center space-x-2">
                    <img src="<%= request.getContextPath() %>/img/logos.png" alt="Logo" class="w-8 h-8">
                    <h1 class="text-2xl font-bold tracking-wider mb-2">
                        <span style="color: #FFFFFF;">Faci</span><span style="color: #2BB15D;">Pago</span>
                    </h1>
                </div>
                <div class="w-16 h-1 bg-white mx-auto rounded-full opacity-50"></div>
            </div>

            <div class="relative group mb-8 px-4">
                <div class="p-6 rounded-2xl bg-white bg-opacity-10 backdrop-blur-lg transition-all duration-300 group-hover:bg-opacity-20">
                    <div class="relative mx-auto w-24 h-24 mb-4">
                        <img src="https://cdn-icons-png.flaticon.com/512/4305/4305692.png" alt="Perfil" class="rounded-xl w-full h-full object-cover transition-transform duration-300 group-hover:scale-105">
                        <div class="absolute bottom-2 right-2 w-4 h-4 bg-green-400 rounded-full border-2 border-white"></div>
                    </div>
                    <h2 id="nombreUsuario" class="text-lg font-bold text-center text-white mb-1"><%= usuario.getNombre() %></h2>
                    <div class="mt-4 flex justify-center space-x-2">
                        <span id="correoUsuario" class="px-3 py-1 bg-blue-500 bg-opacity-30 rounded-full text-xs text-white"><%= usuario.getCorreo() %></span>
                    </div>
                </div>
            </div>

            <nav class="flex-grow px-4">
                <div class="space-y-2">
                    
                    <a href="panelUsuario.jsp" class="flex items-center px-6 py-4 rounded-xl transition-all duration-300 hover:bg-white hover:bg-opacity-10 text-white">
                        <div class="w-10 h-10 rounded-lg bg-white bg-opacity-10 flex items-center justify-center">
                            <i class="fas fa-home text-lg"></i>
                        </div>
                        <span class="ml-4 font-medium">Inicio</span>
                    </a>
                    <a href="panelDashboard.jsp" class="flex items-center px-6 py-4 rounded-xl transition-all duration-300 hover:bg-white hover:bg-opacity-10 text-white">
                        <div class="w-10 h-10 rounded-lg bg-white bg-opacity-10 flex items-center justify-center">
                            <i class="fas fa-chart-line text-lg"></i>
                        </div>
                        <span class="ml-4 font-medium">Dashboard</span>
                    </a>
                    <a href="panelhistorial.jsp" class="flex items-center px-6 py-4 rounded-xl transition-all duration-300 hover:bg-white hover:bg-opacity-10 text-white">
                        <div class="w-10 h-10 rounded-lg bg-white bg-opacity-10 flex items-center justify-center">
                            <i class="fas fa-history text-lg"></i>
                        </div>
                        <span class="ml-4 font-medium">Historial</span>
                    </a>
                    <a href="panelReportes" class="flex items-center px-6 py-4 rounded-xl transition-all duration-300 hover:bg-white hover:bg-opacity-10 text-white">
                        <div class="w-10 h-10 rounded-lg bg-white bg-opacity-10 flex items-center justify-center">
                            <i class="fas fa-file-alt text-lg"></i>
                        </div>
                        <span class="ml-4 font-medium">Reportes</span>
                    </a>
                    <div class="relative">
                        <button id="configButton" class="w-full flex items-center px-6 py-4 rounded-xl transition-all duration-300 hover:bg-white hover:bg-opacity-10 text-white focus:outline-none">
                            <div class="w-10 h-10 rounded-lg bg-white bg-opacity-10 flex items-center justify-center">
                                <i class="fas fa-cog text-lg"></i>
                            </div>
                            <span class="ml-4 font-medium">Configuración</span>
                            <i class="fas fa-chevron-down ml-auto"></i>
                        </button>
                        <div id="configMenu" class="hidden ml-14 mt-2 space-y-2">
                            <a href="seguridad.jsp" class="block px-4 py-2 rounded-xl transition-all duration-300 hover:bg-white hover:bg-opacity-10 text-white">
                                Seguridad
                            </a>
                            <a href="panelperfil.jsp" class="block px-4 py-2 rounded-xl transition-all duration-300 hover:bg-white hover:bg-opacity-10 text-white">
                                perfil
                            </a>
                        </div>
                    </div>
                </div>
            </nav>

            <div class="mt-auto px-4 pb-6">
                <div class="pt-6 border-t border-white border-opacity-20">
                    <button id="logoutButton" class="flex items-center px-6 py-4 rounded-xl transition-all duration-300 hover:bg-white hover:bg-opacity-10 text-white w-full text-left">
                        <div class="w-10 h-10 rounded-lg bg-white bg-opacity-10 flex items-center justify-center">
                            <i class="fas fa-sign-out-alt text-lg"></i>
                        </div>
                        <span class="ml-4 font-medium">Cerrar Sesión</span>
                    </button>
                </div>
            </div>
        </div>
    </aside>

    <!-- Contenido principal -->
    <main class="ml-0 md:ml-72 p-6 bg-gray-50 min-h-screen text-[#1B2E2A]">
        <div class="flex flex-col md:flex-row justify-between items-center mb-6">
            <h2 id="bienvenida" class="text-2xl font-bold mb-4 md:mb-0">Bienvenido, <%= usuario.getNombre() %>!</h2>
            <div class="flex items-center space-x-4">
                <button class="text-[#4B34C3] hover:text-[#2BB15D] transition">
                    <i class="fas fa-bell text-xl"></i>
                </button>
                <button class="text-[#4B34C3] hover:text-[#2BB15D] transition">
                    <i class="fas fa-question-circle text-xl"></i>
                </button>
            </div>
        </div>
                   
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
  <!-- Tarjeta: Saldo disponible -->
  <div class="bg-white shadow rounded-2xl p-6">
    <h3 class="text-lg font-semibold text-gray-600 mb-2">Saldo disponible</h3>
    <div class="flex items-center space-x-2">
      <span id="saldo" class="text-3xl font-bold text-gray-800">••••••</span>
      <button onclick="toggleSaldo()" class="text-gray-500 hover:text-[#2BB15D] transition">
        <i id="iconoOjo" class="fas fa-eye text-xl"></i>
      </button>
    </div>
    <p id="errorSaldo" class="text-sm text-red-500 mt-2"></p>
  </div>

  <!-- Tarjeta: Número de cuenta -->
  <div class="bg-white shadow rounded-2xl p-6">
    <h3 class="text-lg font-semibold text-gray-600 mb-2">Número de cuenta</h3>
    <div class="flex items-center space-x-2">
      <span id="accountNumberDisplay" class="text-xl font-mono text-gray-800">••••••</span>
      <button onclick="toggleSaldo()" class="text-gray-500 hover:text-[#2BB15D] transition">
        <i id="iconoOjoCuenta" class="fas fa-eye text-xl"></i>
      </button>
    </div>
  </div>

  <!-- Tarjeta: Opciones -->
  <div class="bg-white shadow rounded-2xl p-6 flex flex-col justify-between">
    <h3 class="text-lg font-semibold text-gray-600 mb-4">Opciones</h3>
    <div class="flex flex-col space-y-3">
      <button class="px-4 py-2 bg-[#2BB15D] text-white rounded-xl hover:bg-green-600 transition flex items-center justify-center">
        <i class="fas fa-qrcode mr-2"></i> Escanear QR
      </button>
      <button id="rechargeButton" class="bg-[#2BB15D] text-white px-4 py-2 rounded-xl hover:bg-[#23994e] transition flex items-center justify-center">
        <i class="fas fa-wallet mr-2"></i> Recargar
      </button>
      <button id="transferButton" class="px-4 py-2 bg-[#4B34C3] text-white rounded-xl hover:bg-indigo-700 transition flex items-center justify-center">
        <i class="fas fa-paper-plane mr-2"></i> Transferir
      </button>
    </div>
  </div>
</div>

            
            
<form id="formActualizar" action="/BilleteraDigitalWeb/api/usuarios/actualizar" method="post" class="bg-white rounded-2xl shadow-xl p-8 relative">
  <input type="hidden" name="idUsuario" value="<%= usuario.getIdUsuario() %>">

  

  <!-- Ícono de pregunta en la esquina superior derecha -->
  <div style="position: absolute; top: 16px; right: 16px; cursor: pointer;" id="infoIcon" tabindex="0" aria-describedby="infoTooltip" aria-label="Información">
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="12" cy="12" r="10" />
      <path d="M12 16v-4" />
      <circle cx="12" cy="8" r="1" />
    </svg>
  </div>

  <!-- Tooltip oculto inicialmente -->
  <div id="infoTooltip" role="tooltip" style="
    position: absolute; 
    top: 40px; 
    right: 16px; 
    background-color: #f9fafb; 
    border: 1px solid #ccc; 
    padding: 12px; 
    border-radius: 8px; 
    width: 280px; 
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    font-size: 14px;
    color: #333;
    display: none;
    z-index: 1000;
  ">
    Los datos como nombres, apellidos, DNI y fecha de nacimiento no pueden ser modificados debido a las políticas al crearse la cuenta. <br>
    Ante cualquier duda, comuníquese con el centro de soporte.
  </div>
  
  
  <!-- Nombre -->
<div class="relative mb-6">
  <label class="block text-sm font-medium text-slate-700 mb-2" for="nombre">Nombre</label>
  <input type="text" id="nombre" name="nombre" value="<%= usuario.getNombre() %>" required readonly
    class="w-full p-3 border border-slate-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 pl-10 bg-gray-100 cursor-not-allowed" />
  <span class="absolute left-3 top-10 text-slate-400">
    <i class="fas fa-user"></i>
  </span>
</div>

<!-- Apellido -->
<div class="relative mb-6">
  <label class="block text-sm font-medium text-slate-700 mb-2" for="apellido">Apellido</label>
  <input type="text" id="apellido" name="apellido" value="<%= usuario.getApellido() %>" required readonly
    class="w-full p-3 border border-slate-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 pl-10 bg-gray-100 cursor-not-allowed" />
  <span class="absolute left-3 top-10 text-slate-400">
    <i class="fas fa-user-tag"></i>
  </span>
</div>

<!-- DNI -->
<div class="relative mb-6">
  <label class="block text-sm font-medium text-slate-700 mb-2" for="dni">DNI</label>
  <input type="text" id="dni" name="dni" value="<%= usuario.getDni() %>" required readonly
    class="w-full p-3 border border-slate-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 pl-10 bg-gray-100 cursor-not-allowed" />
  <span class="absolute left-3 top-10 text-slate-400">
    <i class="fas fa-id-card"></i>
  </span>
</div>

<!-- Fecha de Nacimiento -->
<div class="relative mb-6">
  <label class="block text-sm font-medium text-slate-700 mb-2" for="fechaNacimiento">Fecha de Nacimiento</label>
  <input type="date" id="fechaNacimiento" name="fechaNacimiento" value="<%= usuario.getFechaNacimiento() %>" required readonly
    class="w-full p-3 border border-slate-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 bg-gray-100 cursor-not-allowed" />
</div>

  <!-- Teléfono -->
<div class="relative mb-6">
  <label for="telefono" class="block text-sm font-medium text-slate-700 mb-2">Teléfono</label>
  <input type="tel" id="telefono" name="telefono" value="<%= usuario.getTelefono() %>" required
    maxlength="9"
    pattern="[0-9]{9}"
    inputmode="numeric"
    title="El teléfono debe contener exactamente 9 dígitos numéricos"
    class="w-full p-3 border border-slate-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 pl-10" />
  <span class="absolute left-3 top-10 text-slate-400">
    <i class="fas fa-phone"></i>
  </span>
</div>

<!-- Correo -->
<div class="relative mb-6">
  <label for="correo" class="block text-sm font-medium text-slate-700 mb-2">Correo</label>
  <input type="email" id="correo" name="correo" value="<%= usuario.getCorreo() %>" required
    pattern="^[^\s@]+@[^\s@]+\.[^\s@]+$"
    title="Ingrese un correo válido, con formato ejemplo@dominio.com"
    class="w-full p-3 border border-slate-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 pl-10" />
  <span class="absolute left-3 top-10 text-slate-400">
    <i class="fas fa-envelope"></i>
  </span>
</div>

  <!-- Contraseña -->
  <div class="relative mb-6">
    <label class="block text-sm font-medium text-slate-700 mb-2" for="password">Contraseña</label>
    <input type="password" id="password" name="password" placeholder="••••••••"
      class="w-full p-3 border border-slate-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 pl-10" />
    <span class="absolute left-3 top-10 text-slate-400">
      <i class="fas fa-lock"></i>
    </span>
  </div>

  <!-- Botón Guardar -->
  <div class="flex justify-end">
    <button type="submit"
      class="px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors shadow-md">
      <i class="fas fa-save mr-2"></i> Guardar Cambios
    </button>
  </div>
</form>
      
           
     
<!-- Div para mostrar mensajes -->
<div id="mensaje" class="mt-4 font-semibold"></div>

<script>
  const infoIcon = document.getElementById('infoIcon');
  const infoTooltip = document.getElementById('infoTooltip');

  // Mostrar tooltip al hacer clic o foco
  infoIcon.addEventListener('click', () => {
    if (infoTooltip.style.display === 'none' || infoTooltip.style.display === '') {
      infoTooltip.style.display = 'block';
    } else {
      infoTooltip.style.display = 'none';
    }
  });

  // Ocultar tooltip si se pierde el foco
  infoIcon.addEventListener('blur', () => {
    infoTooltip.style.display = 'none';
  });

  // Opcional: ocultar tooltip si se hace clic fuera
  document.addEventListener('click', (e) => {
    if (!infoIcon.contains(e.target) && !infoTooltip.contains(e.target)) {
      infoTooltip.style.display = 'none';
    }
  });
</script>
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
     
            
        
        <!-- Modal para transferencias -->
        <div id="transferModal" class="modal">
            <div class="modal-content bg-white rounded-2xl shadow-xl max-w-md w-full mx-auto p-6">
                <!-- Interfaz inicial: Ingresar número de cuenta -->
                <div id="accountInputView" class="animate-fadeIn">
                    <div class="flex items-center justify-between mb-8">
                        <h2 class="text-2xl font-bold text-gray-800">Transferir Dinero</h2>
                        <button id="closeButton" class="text-gray-500 hover:text-gray-700 transition">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                    <div class="mb-6">
                        <label for="accountNumber" class="block text-sm font-medium text-gray-700 mb-2">Número de Cuenta</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-gray-400">
                                    <rect x="3" y="5" width="18" height="14" rx="2"></rect>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <input type="text" id="accountNumber" class="w-full pl-10 p-4 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2BB15D] focus:border-transparent bg-gray-50 transition" 
                                   maxlength="14" minlength="14" pattern="[0-9]{14}" placeholder="Ingrese 14 dígitos" required>
                        </div>
                    </div>
                    <div id="pin-alert" class="flex items-center p-4 text-sm bg-red-100 text-red-700 rounded-xl mt-2 hidden" role="alert">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span>Cuenta no encontrada</span>
                    </div>
                    <div class="flex justify-end space-x-3 mt-8">
                        <button id="cancelButton" class="px-6 py-3 bg-gray-100 text-gray-700 rounded-xl hover:bg-gray-200 transition font-medium">Cancelar</button>
                        <button id="nextButton" class="px-6 py-3 bg-[#2BB15D] text-white rounded-xl hover:bg-green-600 transition font-medium shadow-md">Siguiente</button>
                    </div>
                </div>

                <!-- Interfaz secundaria: Detalles de la transferencia -->
                <div id="transferDetailsView" class="hidden animate-fadeIn">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="text-2xl font-bold text-gray-800">Enviar a</h2>
                        <button id="backButton" class="text-gray-500 hover:text-gray-700 transition">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                    <div class="flex flex-col items-center mb-8 bg-gray-50 p-4 rounded-xl">
                        <div class="w-20 h-20 bg-[#2BB15D] bg-opacity-10 rounded-full flex items-center justify-center mb-2">
                            <img src="https://cdn-icons-png.flaticon.com/512/4305/4305692.png" alt="Perfil" class="w-12 h-12">
                        </div>
                        <p id="recipientName" class="text-lg font-semibold text-gray-800"></p>
                        <p id="maskedAccountNumber" class="text-xs text-gray-500 mt-1"></p>
                    </div>
                    <div class="mb-6">
                        <label for="transferAmount" class="block text-sm font-medium text-gray-700 mb-2">Monto a transferir</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <span class="text-gray-500 font-medium">S/</span>
                            </div>
                            <input type="number" id="transferAmount" class="w-full pl-10 p-4 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2BB15D] focus:border-transparent bg-gray-50 transition" 
                                   min="0" step="0.01" placeholder="0.00" required>
                        </div>
                    </div>
                    <div class="mb-6">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Desde</label>
                        <div class="bg-gray-50 p-4 rounded-xl border border-gray-200">
                            <div class="flex justify-between items-center">
                                <div>
                                    <p id="userAccountNumber" class="text-sm font-medium text-gray-800"></p>
                                    <p id="userBalance" class="text-sm text-gray-600 mt-1">Saldo: S/0.00</p>
                                </div>
                                <div class="bg-[#2BB15D] bg-opacity-10 p-2 rounded-full">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#2BB15D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="2" y="5" width="20" height="14" rx="2"></rect>
                                        <path d="M16 14V8M12 14V10M8 14v-3"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-6">
                        <label for="transferMessage" class="block text-sm font-medium text-gray-700 mb-2">Mensaje (Opcional)</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-gray-400">
                                    <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"></path>
                                </svg>
                            </div>
                            <input type="text" id="transferMessage" class="w-full pl-10 p-4 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2BB15D] focus:border-transparent bg-gray-50 transition" 
                                   placeholder="Escribe un mensaje">
                        </div>
                    </div>
                    <div id="error-alert" class="flex items-center p-4 text-sm bg-red-100 text-red-700 rounded-xl mt-2 hidden" role="alert">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span>Error</span>
                    </div>
                    <div class="flex justify-end space-x-3 mt-8">
                        <button id="cancelTransferButton" class="px-6 py-3 bg-gray-100 text-gray-700 rounded-xl hover:bg-gray-200 transition font-medium">Cancelar</button>
                        <button id="confirmTransferButton" class="px-6 py-3 bg-[#2BB15D] text-white rounded-xl hover:bg-green-600 transition font-medium shadow-md">Transferir</button>
                    </div>
                </div>

                <!-- Interfaz de carga -->
                <div id="loadingView" class="hidden flex flex-col items-center justify-center py-12 animate-fadeIn">
                    <div class="relative w-20 h-20">
                        <div class="w-20 h-20 border-4 border-gray-200 rounded-full"></div>
                        <div class="absolute top-0 w-20 h-20 border-4 border-[#2BB15D] border-t-transparent rounded-full animate-spin"></div>
                    </div>
                    <p class="mt-6 text-gray-700 font-medium">Procesando transferencia...</p>
                </div>

                <!-- Interfaz de éxito -->
                <div id="successView" class="hidden animate-fadeIn">
                    <div class="flex flex-col items-center justify-center py-6">
                        <div class="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mb-4">
                            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#2BB15D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                        </div>
                        <h2 class="text-2xl font-bold text-gray-800 mb-2">¡Transferencia exitosa!</h2>
                        <p class="text-gray-500 text-center mb-6">Tu dinero ha sido enviado correctamente</p>
                    </div>
                    <div class="bg-gray-50 p-5 rounded-xl mb-6 border border-gray-100">
                        <p id="transferSummary" class="text-gray-700"></p>
                    </div>
                    <div class="flex justify-center">
                        <button id="closeSuccessButton" class="w-full px-6 py-3 bg-[#2BB15D] text-white rounded-xl hover:bg-green-600 transition font-medium shadow-md">Finalizar</button>
                    </div>
                </div>
            </div>
        </div>
        
         <!-- Modal para detalles de transferencia -->
        <div id="historyModal" class="modal">
            <div class="modal-content bg-white rounded-2xl shadow-xl max-w-md w-full mx-auto p-6">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-2xl font-bold text-gray-800">Detalles de la Transacción</h2>
                    <button id="closeHistoryButton" class="text-gray-500 hover:text-gray-700 transition">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                </div>
                <div class="bg-gray-50 p-5 rounded-xl border border-gray-100">
                    <p class="text-sm text-gray-600 mb-2"><span class="font-medium">Fecha:</span> <span id="historyDate"></span></p>
                    <p class="text-sm text-gray-600 mb-2"><span class="font-medium">Hora:</span> <span id="historyTime"></span></p>
                    <p class="text-sm text-gray-600 mb-2"><span class="font-medium">Monto:</span> <span id="historyAmount"></span></p>
                    <p class="text-sm text-gray-600 mb-2"><span class="font-medium">Tipo:</span> <span id="historyType"></span></p>
                    <p class="text-sm text-gray-600 mb-2"><span class="font-medium">Origen:</span> <span id="historyOrigin"></span></p>
                    <p class="text-sm text-gray-600 mb-2"><span class="font-medium">Cuenta Destino:</span> <span id="historyDestination"></span></p>
                    <p class="text-sm text-gray-600"><span class="font-medium">Mensaje:</span> <span id="historyMessage"></span></p>
                </div>
                <div class="flex justify-end mt-6 space-x-3">
                    <button id="makeAnotherTransferButton" class="px-6 py-3 bg-[#2BB15D] text-white rounded-xl hover:bg-green-600 transition font-medium">Hacer otra transferencia</button>
                    <button id="closeHistoryButtonBottom" class="px-6 py-3 bg-gray-100 text-gray-700 rounded-xl hover:bg-gray-200 transition font-medium">Cerrar</button>
                </div>
            </div>
        </div>
       

        <!-- Modal de recarga -->
        <div id="rechargeModal" class="modal fixed inset-0 bg-black/70 backdrop-blur-md flex items-center justify-center hidden z-50 transition-all duration-300">
            <div class="bg-white rounded-3xl p-8 w-full max-w-md shadow-2xl relative border border-gray-100 overflow-hidden">
                <!-- Elemento decorativo de fondo -->
                <div class="absolute -top-16 -right-16 w-40 h-40 bg-[#2BB15D]/10 rounded-full blur-2xl"></div>
                <div class="absolute -bottom-20 -left-20 w-48 h-48 bg-[#2BB15D]/5 rounded-full blur-3xl"></div>
                
                <!-- Vista de ingreso -->
                <div id="rechargeInputView" class="relative">
                    <h2 class="text-2xl font-bold mb-8 text-gray-800 border-b pb-4">
                        Recargar Saldo
                    </h2>
                    
                    <div id="rechargeErrorAlert" class="hidden bg-red-50 border-l-4 border-red-500 text-red-700 p-4 rounded-xl mb-6">
                        <span>Error</span>
                    </div>
                    
                    <div class="mb-8">
                        <label class="block text-gray-700 font-medium mb-2 text-sm">Monto a recargar</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gray-500 font-medium">S/</span>
                            <input id="rechargeAmount" type="number" step="0.01" min="0" class="w-full border-0 bg-gray-50 rounded-2xl py-4 pl-10 pr-4 focus:ring-2 focus:ring-[#2BB15D] focus:border-transparent outline-none transition shadow-sm" placeholder="0.00">
                        </div>
                    </div>
                    
                    <div class="mb-8">
                        <label class="block text-gray-700 font-medium mb-3 text-sm">Método de pago</label>
                        <div class="space-y-4">
                            <div class="bg-gray-50 border-2 border-transparent rounded-2xl p-4 hover:border-[#2BB15D]/30 transition-all duration-200 cursor-pointer group">
                                <div class="flex items-center">
                                    <input type="radio" name="paymentMethod" value="1" class="h-5 w-5 accent-[#2BB15D]">
                                    <span class="font-medium ml-3">Tarjeta Izipay</span>
                                    <div class="ml-auto w-48 flex items-center justify-center">
                                        <img src="https://cdn.joinnus.com/payment/2023/izipay_v2.svg" alt="Izipay"/>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="bg-gray-50 border-2 border-transparent rounded-2xl p-4 hover:border-[#2BB15D]/30 transition-all duration-200 cursor-pointer group">
                                <div class="flex items-center">
                                    <input type="radio" name="paymentMethod" value="2" class="h-5 w-5 accent-[#2BB15D]">
                                    <span class="font-medium ml-3">Yape</span>
                                    <div class="ml-auto w-16 flex items-center justify-center">
                                        <img src="https://ingenieriacivilyconstruccion.com/wp-content/uploads/2024/12/Yape-v2.png" alt="Yape"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="flex justify-end space-x-3 mt-10">
                        <button id="rechargeCancelButton" class="bg-gray-100 text-gray-700 px-6 py-3 rounded-2xl font-medium hover:bg-gray-200 transition-all">Cancelar</button>
                        <button id="rechargeConfirmButton" class="bg-[#2BB15D] text-white px-6 py-3 rounded-2xl font-medium hover:bg-[#23994e] transition-all shadow-lg">Confirmar</button>
                    </div>
                </div>
                
                <!-- Vista de carga -->
                <div id="rechargeLoadingView" class="hidden text-center py-14">
                    <div class="relative w-20 h-20 mx-auto mb-8">
                        <div class="absolute top-0 left-0 w-full h-full border-4 border-gray-200 rounded-full"></div>
                        <div class="absolute top-0 left-0 w-full h-full border-4 border-t-[#2BB15D] border-r-transparent border-b-transparent border-l-transparent rounded-full animate-spin"></div>
                    </div>
                    <p class="text-gray-700 text-lg">Procesando su recarga...</p>
                </div>
                
                <!-- Vista de éxito -->
                <div id="rechargeSuccessView" class="hidden">
                    <div class="text-center mb-8">
                        <div class="w-20 h-20 mx-auto mb-4 bg-green-100 rounded-full flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#2BB15D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                        </div>
                        <h2 class="text-2xl font-bold text-gray-800">¡Recarga Exitosa!</h2>
                    </div>
                    
                    <div class="bg-gray-50 rounded-2xl p-6 mb-8">
                        <p id="rechargeSummary" class="text-gray-700"></p>
                    </div>
                    
                    <div class="flex justify-center">
                        <button id="rechargeCloseSuccessButton" class="bg-[#2BB15D] text-white px-8 py-4 rounded-2xl font-medium hover:bg-[#23994e] transition-all shadow-lg w-full">Finalizar</button>
                    </div>
                </div>
                
                <button id="rechargeCloseButton" class="absolute top-6 right-6 text-gray-400 hover:text-gray-600 transition-all w-8 h-8 flex items-center justify-center bg-white rounded-full shadow-sm">
                    ×
                </button>
            </div>
        </div>
        
        
    </main>

    <!-- Scripts -->
    <script src="<%= request.getContextPath() %>/js/datoscuenta.js"></script>
    
 <script>
  document.getElementById('formActualizar').addEventListener('submit', function(event) {
    event.preventDefault(); // evitar recarga

    const form = event.target;
    const mensajeDiv = document.getElementById('mensaje');
    mensajeDiv.textContent = ''; // limpiar mensaje previo
    mensajeDiv.className = 'mt-4 font-semibold';

    // Obtener valores de teléfono y correo
    const telefono = form.telefono.value.trim();
    const correo = form.correo.value.trim();

    // Validar teléfono: máximo 9 dígitos, solo números, debe empezar con 9
    const telefonoRegex = /^9[0-9]{0,8}$/; // empieza con 9 seguido de hasta 8 dígitos (total máximo 9)
    if (!telefonoRegex.test(telefono)) {
      mensajeDiv.textContent = 'El teléfono debe contener máximo 9 dígitos numéricos y comenzar con 9.';
      mensajeDiv.classList.add('text-red-600');
      return;
    }

    // Validar correo: debe tener un '@' y texto después
    const correoRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!correoRegex.test(correo)) {
      mensajeDiv.textContent = 'El correo electrónico no es válido.';
      mensajeDiv.classList.add('text-red-600');
      return;
    }

    // Si pasa validaciones, enviar formulario
    const formData = new FormData(form);

    fetch(form.action, {
      method: 'POST',
      body: new URLSearchParams(formData), // enviar como application/x-www-form-urlencoded
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.mensaje) {
        mensajeDiv.textContent = data.mensaje;
        mensajeDiv.classList.add('text-green-600');
      } else if (data.error) {
        mensajeDiv.textContent = data.error;
        mensajeDiv.classList.add('text-red-600');
      } else {
        mensajeDiv.textContent = 'Respuesta inesperada del servidor.';
        mensajeDiv.classList.add('text-yellow-600');
      }
    })
    .catch(() => {
      mensajeDiv.textContent = 'Error al guardar los cambios. Intenta nuevamente.';
      mensajeDiv.classList.add('text-red-600');
    });
  });
</script>



    
  


      
</body>
</html>