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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>
        <style>
            .glass-effect {
                backdrop-filter: blur(10px);
                background: rgba(255, 255, 255, 0.1);
            }

            @keyframes float {
                0% {
                    transform: translateY(0px);
                }
                50% {
                    transform: translateY(-5px);
                }
                100% {
                    transform: translateY(0px);
                }
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
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body class="bg-gray-50 overflow-x-hidden">
        <%
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            if (usuario == null) {
                System.out.println("No hay sesión activa, redirigiendo a login.jsp");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            } else {
                System.out.println("Sesión activa para usuario: " + usuario.getCorreo());
            }

            String numeroCuenta = (String) session.getAttribute("numeroCuenta");
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
                        <a href="panelReportes.jsp" class="flex items-center px-6 py-4 rounded-xl transition-all duration-300 hover:bg-white hover:bg-opacity-10 text-white">
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

            <div id="default-carousel" class="relative w-full max-w-5xl mx-auto bg-[#2BB15D]/80 rounded-3xl shadow-lg border-2 border-[#2BB15D]" data-carousel="slide">
                <!-- Carousel wrapper -->
                <div class="relative h-72 md:h-[28rem] overflow-hidden rounded-3xl">
                    <div class="hidden duration-700 ease-in-out" data-carousel-item>
                        <img src="img/carrusel1.png" class="absolute block max-h-[28rem] max-w-full object-contain top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2" alt="...">
                    </div>
                    <div class="hidden duration-700 ease-in-out" data-carousel-item>
                        <img src="img/carrusel2.png" class="absolute block max-h-[28rem] max-w-full object-contain top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2" alt="...">
                    </div>
                    <div class="hidden duration-700 ease-in-out" data-carousel-item>
                        <img src="img/carrusel3.png" class="absolute block max-h-[28rem] max-w-full object-contain top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2" alt="...">
                    </div>
                    <div class="hidden duration-700 ease-in-out" data-carousel-item>
                        <img src="img/fondo4.png" class="absolute block max-h-[28rem] max-w-full object-contain top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2" alt="...">
                    </div>
                    <div class="hidden duration-700 ease-in-out" data-carousel-item>
                        <img src="img/fondo3.png" class="absolute block max-h-[28rem] max-w-full object-contain top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2" alt="...">
                    </div>
                </div>

                <!-- Indicadores del Slider -->
                <div class="absolute z-30 flex -translate-x-1/2 bottom-4 left-1/2 space-x-4 rtl:space-x-reverse">
                    <button type="button" class="w-4 h-4 rounded-full bg-[#2BB15D] opacity-80 hover:opacity-100 transition" aria-current="true" aria-label="Slide 1" data-carousel-slide-to="0"></button>
                    <button type="button" class="w-4 h-4 rounded-full bg-gray-300 opacity-60 hover:opacity-100 transition" aria-current="false" aria-label="Slide 2" data-carousel-slide-to="1"></button>
                    <button type="button" class="w-4 h-4 rounded-full bg-gray-300 opacity-60 hover:opacity-100 transition" aria-current="false" aria-label="Slide 3" data-carousel-slide-to="2"></button>
                    <button type="button" class="w-4 h-4 rounded-full bg-gray-300 opacity-60 hover:opacity-100 transition" aria-current="false" aria-label="Slide 4" data-carousel-slide-to="3"></button>
                    <button type="button" class="w-4 h-4 rounded-full bg-gray-300 opacity-60 hover:opacity-100 transition" aria-current="false" aria-label="Slide 5" data-carousel-slide-to="4"></button>
                </div>

                <!-- Controles del Slider -->
                <button type="button" class="hidden absolute top-0 left-0 z-30 flex items-center justify-center h-full px-6 cursor-pointer group focus:outline-none" data-carousel-prev>
                    <span class="inline-flex items-center justify-center w-12 h-12 rounded-full bg-purple-900 hover:bg-purple-800 group-focus:ring-4 group-focus:ring-purple-700">
                        <svg class="w-6 h-6 text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 1 1 5l4 4"/>
                        </svg>
                        <span class="sr-only">Previous</span>
                    </span>
                </button>
                <button type="button" class="hidden absolute top-0 right-0 z-30 flex items-center justify-center h-full px-6 cursor-pointer group focus:outline-none" data-carousel-next>
                    <span class="inline-flex items-center justify-center w-12 h-12 rounded-full bg-purple-900 hover:bg-purple-800 group-focus:ring-4 group-focus:ring-purple-700">
                        <svg class="w-6 h-6 text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 9 4-4-4-4"/>
                        </svg>
                        <span class="sr-only">Next</span>
                    </span>
                </button>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const carousel = document.getElementById('default-carousel');
                    const items = carousel.querySelectorAll('[data-carousel-item]');
                    const indicators = carousel.querySelectorAll('[data-carousel-slide-to]');
                    const prevBtn = carousel.querySelector('[data-carousel-prev]');
                    const nextBtn = carousel.querySelector('[data-carousel-next]');
                    let current = 0;
                    const total = items.length;

                    function showSlide(idx) {
                        items.forEach((item, i) => {
                            item.classList.toggle('hidden', i !== idx);
                            item.classList.toggle('block', i === idx);
                            indicators[i].setAttribute('aria-current', i === idx ? 'true' : 'false');
                            indicators[i].classList.toggle('bg-[#2BB15D]', i === idx);
                            indicators[i].classList.toggle('bg-gray-300', i !== idx);
                        });
                        current = idx;
                    }

                    showSlide(0);

                    indicators.forEach((btn, idx) => {
                        btn.addEventListener('click', () => showSlide(idx));
                    });

                    prevBtn.addEventListener('click', () => {
                        let idx = current - 1;
                        if (idx < 0)
                            idx = total - 1;
                        showSlide(idx);
                    });

                    nextBtn.addEventListener('click', () => {
                        let idx = (current + 1) % total;
                        showSlide(idx);
                    });

                    setInterval(() => {
                        let idx = (current + 1) % total;
                        showSlide(idx);
                    }, 6000);

                    carousel.addEventListener('mouseenter', () => {
                        prevBtn.classList.remove('hidden');
                        nextBtn.classList.remove('hidden');
                    });

                    carousel.addEventListener('mouseleave', () => {
                        prevBtn.classList.add('hidden');
                        nextBtn.classList.add('hidden');
                    });
                });
            </script>

            <div class="bg-white shadow-lg rounded-2xl p-4 sm:p-6 mb-6">
                <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center">
                    <div class="mb-4 sm:mb-0">
                        <h3 class="text-lg font-semibold text-gray-600 mb-1">Saldo disponible</h3>
                        <div class="flex items-center space-x-2">
                            <span id="saldo" class="text-2xl sm:text-3xl font-bold">••••••</span>
                            <button onclick="toggleSaldo()" class="text-gray-500 hover:text-[#2BB15D]">
                                <i id="iconoOjo" class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="flex items-center space-x-2 mt-2">
                            <span id="accountNumberDisplay" class="text-sm text-gray-600"></span>
                            <button onclick="toggleSaldo()" class="text-gray-500 hover:text-[#2BB15D]">
                                <i id="iconoOjoCuenta" class="fas fa-eye"></i>
                            </button>
                        </div>
                        <p id="errorSaldo" class="error-message"></p>
                    </div>
                    <div class="flex flex-wrap justify-center sm:justify-end space-x-2 sm:space-x-3 gap-y-2">
                        <button id="scanQRButton" class="px-3 py-2 bg-[#2BB15D] text-white rounded-xl hover:bg-green-600 transition text-sm sm:text-base">
                            <i class="fas fa-qrcode mr-1 sm:mr-2"></i> Escanear QR
                        </button>
                        <button id="showMyQRButton" class="px-3 py-2 bg-[#4B34C3] text-white rounded-xl hover:bg-indigo-700 transition text-sm sm:text-base">
                            <i class="fas fa-qrcode mr-1 sm:mr-2"></i> Mostrar mi QR
                        </button>
                        <button id="rechargeButton" class="bg-[#2BB15D] text-white px-3 py-2 rounded-lg hover:bg-[#23994e] flex items-center text-sm sm:text-base">
                            <i class="fas fa-wallet mr-1 sm:mr-2"></i> Recargar
                        </button>
                        <button id="transferButton" class="px-3 py-2 bg-[#4B34C3] text-white rounded-xl hover:bg-indigo-700 transition text-sm sm:text-base">
                            <i class="fas fa-paper-plane mr-1 sm:mr-2"></i> Transferir
                        </button>
                    </div>
                </div>
            </div>

            <div class="bg-white shadow rounded-2xl p-6">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-lg font-semibold text-gray-700">Movimientos recientes</h3>
                    <button onclick="toggleMovimientos()" class="text-[#2BB15D] hover:text-[#4B34C3]">
                        <i class="fas fa-chevron-down mr-1"></i> Mostrar movimientos
                    </button>
                </div>
                <div id="listaMovimientos" class="hidden space-y-3">
                    <!-- Movimientos se cargarán dinámicamente -->
                </div>
                <p id="errorMovimientos" class="error-message"></p>
            </div>

            <!-- Modal para escanear QR y subir imagen -->
            <div id="scanQRModal" class="modal">
                <div class="modal-content bg-white rounded-2xl shadow-xl max-w-md w-full mx-auto p-6">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="text-2xl font-bold text-gray-800">Escanear Código QR</h2>
                        <button id="closeScanQRButton" class="text-gray-500 hover:text-gray-700 transition">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                    <div id="qrScanView" class="animate-fadeIn">
                        <div class="flex flex-col items-center">
                            <div id="qrReader" class="w-full">
                                <video id="qrVideo" class="w-full rounded-lg mb-4" autoplay playsinline></video>
                            </div>
                            <div id="qrResult" class="text-gray-700 font-bold mt-4"></div>
                            <div id="qrErrorAlert" class="flex items-center p-4 text-sm bg-red-100 text-red-700 rounded-xl mt-2 hidden" role="alert">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                                <span id="qrErrorMessage">Error</span>
                            </div>
                            <div class="w-full border-t border-gray-200 my-4"></div>
                            <label class="block w-full mb-4">
                                <span class="text-gray-700 font-medium mb-2 block">O subir imagen con código QR</span>
                                <input type="file" id="qrFileInput" accept="image/*" class="block w-full text-sm text-gray-500
                                       file:mr-4 file:py-2 file:px-4
                                       file:rounded-xl file:border-0
                                       file:text-sm file:font-semibold
                                       file:bg-[#2BB15D] file:text-white
                                       hover:file:bg-[#23994e]">
                            </label>
                            <button id="scanQRFileButton" class="w-full px-4 py-3 bg-[#4B34C3] text-white rounded-xl hover:bg-indigo-700 transition font-medium">
                                Escanear QR desde imagen
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal para mostrar el código QR -->
            <div id="qrModal" class="modal">
                <div class="modal-content bg-white rounded-2xl shadow-xl max-w-md w-full mx-auto p-6">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="text-2xl font-bold text-gray-800">Mi Código QR</h2>
                        <button id="closeQRButton" class="text-gray-500 hover:text-gray-700 transition">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                    <div class="flex flex-col items-center">
                        <div class="relative">
                            <img id="qrImage" src="" alt="Código QR" class="w-64 h-64 mb-4">
                        </div>
                        <p class="text-gray-700 mb-4">Escanea este código QR para realizar transacciones.</p>
                        <button id="downloadQRButton" class="px-6 py-3 bg-[#2BB15D] text-white rounded-xl hover:bg-green-600 transition font-medium">
                            <i class="fas fa-download mr-2"></i> Descargar tu código QR
                        </button>
                    </div>
                </div>
            </div>
            <!-- Modal para transferencias manuales -->
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
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 (phi)24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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

            <!-- Nuevo modal para transferencias por QR -->
            <div id="qrTransferModal" class="modal">
                <div class="modal-content bg-white rounded-2xl shadow-xl max-w-md w-full mx-auto p-6">
                    <!-- Interfaz inicial: Detalles de la transferencia -->
                    <div id="qrTransferDetailsView" class="animate-fadeIn">
                        <div class="flex items-center justify-between mb-6">
                            <h2 class="text-2xl font-bold text-gray-800">Enviar a</h2>
                            <button id="qrCloseTransferButton" class="text-gray-500 hover:text-gray-700 transition">
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
                            <p id="qrRecipientName" class="text-lg font-semibold text-gray-800"></p>
                            <p id="qrMaskedAccountNumber" class="text-xs text-gray-500 mt-1"></p>
                        </div>
                        <div class="mb-6">
                            <label for="qrTransferAmount" class="block text-sm font-medium text-gray-700 mb-2">Monto a transferir</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <span class="text-gray-500 font-medium">S/</span>
                                </div>
                                <input type="number" id="qrTransferAmount" class="w-full pl-10 p-4 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2BB15D] focus:border-transparent bg-gray-50 transition"
                                       min="0" step="0.01" placeholder="0.00" required>
                            </div>
                        </div>
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Desde</label>
                            <div class="bg-gray-50 p-4 rounded-xl border border-gray-200">
                                <div class="flex justify-between items-center">
                                    <div>
                                        <p id="qrUserAccountNumber" class="text-sm font-medium text-gray-800"></p>
                                        <p id="qrUserBalance" class="text-sm text-gray-600 mt-1">Saldo: S/0.00</p>
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
                            <label for="qrTransferMessage" class="block text-sm font-medium text-gray-700 mb-2">Mensaje (Opcional)</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-gray-400">
                                    <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"></path>
                                    </svg>
                                </div>
                                <input type="text" id="qrTransferMessage" class="w-full pl-10 p-4 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2BB15D] focus:border-transparent bg-gray-50 transition"
                                       placeholder="Escribe un mensaje">
                            </div>
                        </div>
                        <div id="qrErrorAlertTransfer" class="flex items-center p-4 text-sm bg-red-100 text-red-700 rounded-xl mt-2 hidden" role="alert">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            <span id="qrErrorMessageTransfer">Error</span>
                        </div>
                        <div class="flex justify-end space-x-3 mt-8">
                            <button id="qrCancelTransferButton" class="px-6 py-3 bg-gray-100 text-gray-700 rounded-xl hover:bg-gray-200 transition font-medium">Cancelar</button>
                            <button id="qrConfirmTransferButton" class="px-6 py-3 bg-[#2BB15D] text-white rounded-xl hover:bg-green-600 transition font-medium shadow-md">Transferir</button>
                        </div>
                    </div>

                    <!-- Interfaz de carga -->
                    <div id="qrLoadingView" class="hidden flex flex-col items-center justify-center py-12 animate-fadeIn">
                        <div class="relative w-20 h-20">
                            <div class="w-20 h-20 border-4 border-gray-200 rounded-full"></div>
                            <div class="absolute top-0 w-20 h-20 border-4 border-[#2BB15D] border-t-transparent rounded-full animate-spin"></div>
                        </div>
                        <p class="mt-6 text-gray-700 font-medium">Procesando transferencia...</p>
                    </div>

                    <!-- Interfaz de éxito -->
                    <div id="qrSuccessView" class="hidden animate-fadeIn">
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
                            <p id="qrTransferSummary" class="text-gray-700"></p>
                        </div>
                        <div class="flex justify-center">
                            <button id="qrCloseSuccessButton" class="w-full px-6 py-3 bg-[#2BB15D] text-white rounded-xl hover:bg-green-600 transition font-medium shadow-md">Finalizar</button>
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
        <script src="<%= request.getContextPath() %>/js/datoscuentas.js"></script>
        <script src="<%= request.getContextPath() %>/js/qrcuenta.js"></script>

        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                const downloadQRButton = document.getElementById('downloadQRButton');
                                const qrImage = document.getElementById('qrImage');

                                downloadQRButton.addEventListener('click', function () {
                                    if (qrImage.src) {
                                        // Create a temporary link element for downloading
                                        const link = document.createElement('a');
                                        link.href = qrImage.src;
                                        link.download = 'Mi_Codigo_QR.png'; // Set the file name for download
                                        document.body.appendChild(link);
                                        link.click();
                                        document.body.removeChild(link); // Clean up
                                    } else {
                                        console.error('No QR code image available for download');
                                    }
                                });
                            });
        </script>
