<%-- 
    Document   : index
    Created on : 3 may 2025, 10:30:49
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inicio</title>
        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Iconos -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/2.6.0/uicons-regular-straight/css/uicons-regular-straight.css'>
       <style>
.whatsapp-float {
  position: fixed;
  bottom: 20px;
  left: 20px; /* Ahora en la parte izquierda */
  z-index: 1000;
  background-color: #25d366;
  padding: 10px;
  border-radius: 50%;
  box-shadow: 2px 2px 5px rgba(0,0,0,0.3);
  transition: transform 0.3s;
}

.whatsapp-float:hover {
  transform: scale(1.1);
}
</style>
    </head>

    <body class="bg-gray-100">
    <header class="fixed z-50 w-full bg-[#FBF9F6] shadow-lg">
  <div class="w-full max-w-screen-xl mx-auto px-4">
    <div class="flex items-center justify-between h-16">
      <!-- LOGO + Nombre -->
      <div class="flex items-center space-x-2">
        <img src="img/logos.png" alt="Logo" class="w-8 h-8" />
        <a href="index.jsp" class="flex items-center">
          <h1 class="text-2xl font-bold tracking-wider">
            <span style="color: #4B34C3;">Faci</span><span style="color: #2BB15D;">Pago</span>
          </h1>
        </a>
      </div>

      <!-- Navegación Desktop  -->
<nav class="hidden md:flex md:items-center md:space-x-8">
  <!-- Nosotros -->
  <div class="relative">
  <button onclick="toggleSubMenu('submenuNosotros')"
    class="flex items-center text-[#4B34C3] font-semibold cursor-pointer px-3 py-2 hover:text-[#2BB15D] transition duration-200">
    <i class="fi fi-rs-users-alt w-4 h-4 mr-1"></i>Nosotros
    <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
        d="M19 9l-7 7-7-7"></path>
    </svg>
  </button>

  <ul id="submenuNosotros"
    class="hidden absolute left-0 bg-white border border-gray-200 rounded-lg shadow-lg z-50 min-w-[180px] py-2 mt-1">
    <li><a href="conocenos.jsp"
        class="block px-5 py-2 text-gray-700 hover:bg-gray-100 hover:text-[#4B34C3]">Conócenos</a></li>
    <li><a href="Reseñas.jsp"
        class="block px-5 py-2 text-gray-700 hover:bg-gray-100 hover:text-[#4B34C3]">Reseñas</a></li>
  </ul>
</div>

  <!-- Ayuda -->
  <div class="relative">
  <button onclick="toggleSubMenu('submenuAyuda')"
    class="flex items-center text-[#2BB15D] font-semibold cursor-pointer px-3 py-2 hover:text-[#4B34C3] transition duration-200">
    <i class="fi fi-rs-interrogation w-4 h-4 mr-1"></i>Ayuda
    <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
        d="M19 9l-7 7-7-7"></path>
    </svg>
  </button>

  <ul id="submenuAyuda"
    class="hidden absolute left-0 bg-white border border-gray-200 rounded-lg shadow-lg z-50 min-w-[180px] py-2 mt-1">
     <li><a href="ayuda.jsp"
        class="block px-5 py-2 text-gray-700 hover:bg-gray-100 hover:text-[#4B34C3]">ayuda general</a></li>
    <li><a href="reclamos.jsp"
        class="block px-5 py-2 text-gray-700 hover:bg-gray-100 hover:text-[#4B34C3]">Reclamos</a></li>  
    <li><a href="preguntas.jsp"
        class="block px-5 py-2 text-gray-700 hover:bg-gray-100 hover:text-[#4B34C3]">Preguntas Frecuentes</a></li>
    
  </ul>
</div>

  <!-- Novedades -->
  <a href="index.jsp" class="flex items-center text-[#4B34C3] font-semibold px-3 py-2 hover:text-[#2BB15D] transition">
    <i class="fi fi-rs-newspaper-open w-4 h-4 mr-1"></i>Novedades
  </a>

  <!-- Contacto -->
  <a href="index.jsp" class="flex items-center text-[#2BB15D] font-semibold px-3 py-2 hover:text-[#4B34C3] transition">
    <i class="fas fa-phone-alt w-4 h-4 mr-1"></i>Contacto
  </a>
</nav>

      <!-- Botones -->
      <div class="flex items-center space-x-4">
        <i data-lucide="globe-2" class="w-5 h-5 text-gray-700"></i>

        <% String nombreUsuario = (String) session.getAttribute("nombreUsuario"); %>
        <% if (nombreUsuario != null) { %>
        <div class="hidden md:flex items-center space-x-4">
          <div class="flex items-center space-x-2 text-gray-800">
            <i class="fi fi-rs-user w-5 h-5"></i>
            <span><%= nombreUsuario %></span>
          </div>
          <a href="logout.jsp" class="px-4 py-2 bg-[#2BB15D] text-white rounded-full hover:bg-green-600 transition">
            Cerrar sesión <i class="fi fi-rs-sign-out ml-2"></i>
          </a>
        </div>
        <% } else { %>
        <a href="login.jsp" class="hidden md:flex items-center px-4 py-2 bg-[#4B34C3] text-white rounded-full hover:bg-indigo-700 transition">
          Iniciar sesión <i class="fi fi-rs-user ml-2"></i>
        </a>
        <% } %>

        <!-- Botón menú móvil -->
        <button type="button" id="menu-button"
          class="inline-flex items-center p-2 w-10 h-10 justify-center text-[#4B34C3] rounded-lg md:hidden hover:bg-[#eee] focus:outline-none focus:ring-2 focus:ring-[#4B34C3]">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 17 14">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
              stroke-width="2" d="M1 1h15M1 7h15M1 13h15" />
          </svg>
        </button>
      </div>
    </div>

    <!-- Menú Móvil -->
    <nav class="md:hidden hidden" id="navbar-collapse">
      <ul class="space-y-1 px-2 pb-3 pt-2">
        <!-- Nosotros -->
        <li>
          <button class="flex justify-between w-full items-center px-3 py-2 rounded-md text-[#4B34C3] hover:bg-[#eee] font-semibold"
            onclick="toggleSubMenu('submenu-nosotros')">
            <span><i class="fi fi-rs-users-alt w-5 h-5 mr-2"></i>Nosotros</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M19 9l-7 7-7-7"></path>
            </svg>
          </button>
          <ul id="submenu-nosotros" class="hidden pl-6">   
            <li><a href="conocenos.jsp" class="block px-4 py-2 text-gray-700 hover:bg-sky-100">Conócenos</a></li>
            <li><a href="Reseñas.jsp" class="block px-4 py-2 text-gray-700 hover:bg-sky-100">Reseñas</a></li>
          </ul>
        </li>


        <!-- Ayuda -->
        <li>
          <button class="flex justify-between w-full items-center px-3 py-2 rounded-md text-[#2BB15D] hover:bg-[#eee] font-semibold"
            onclick="toggleSubMenu('submenu-ayuda')">
            <span><i class="fi fi-rs-interrogation w-5 h-5 mr-2"></i>Ayuda</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M19 9l-7 7-7-7"></path>
            </svg>
          </button>
          <ul id="submenu-ayuda" class="hidden pl-6">
            <li><a href="ayuda.jsp" class="block px-4 py-2 text-gray-700 hover:bg-sky-100">Ayuda General</a></li> 
            <li><a href="reclamos.jsp" class="block px-4 py-2 text-gray-700 hover:bg-sky-100">Reclamos</a></li>
            <li><a href="preguntas.jsp" class="block px-4 py-2 text-gray-700 hover:bg-sky-100">Preguntas Recurrentes</a></li>
          </ul>
        </li>

        <!-- Noticias -->
        <li>
          <a href="noticias.jsp"
            class="flex items-center px-3 py-2 rounded-md text-[#4B34C3] hover:bg-[#eee] font-semibold">
            <i class="fi fi-rs-newspaper-open w-5 h-5 mr-2"></i>Novedades
          </a>
        </li>
        
        <!-- contactanos -->
       <li>
  <a href="noticias.jsp"
    class="flex items-center px-3 py-2 rounded-md text-[#2BB15D] hover:bg-[#eee] font-semibold">
    <i class="fas fa-phone-alt w-5 h-5 mr-2"></i>Contacto
  </a>
</li>
        
        
        

        <!-- Login / Logout Móvil -->
        <li class="px-3 py-2">
          <% if (nombreUsuario != null) { %>
          <div class="text-gray-700 mb-2 flex items-center space-x-2">
            <i class="fi fi-rs-user w-5 h-5"></i>
            <span><%= nombreUsuario %></span>
          </div>
          <a href="logout.jsp" class="block w-full px-4 py-2 bg-[#2BB15D] text-white text-center rounded-full hover:bg-green-600 transition">
            Cerrar sesión
          </a>
          <% } else { %>
          <a href="login.jsp" class="block w-full px-4 py-2 bg-[#4B34C3] text-white text-center rounded-full hover:bg-indigo-700 transition">
            Iniciar sesión
          </a>
          <% } %>
        </li>
      </ul>
    </nav>
  </div>
</header>

<div class="relative h-screen flex items-center justify-center overflow-hidden">
    <!-- Imagen de fondo -->
    <div class="absolute inset-0 z-0">
        <img src="img/fondo3.png" alt="Billetera digital background" class="w-full h-full object-cover" />
        <!-- Superposición para oscurecer la imagen y mejorar la legibilidad del texto -->
        <div class="absolute inset-0 bg-black opacity-20"></div>
    </div>

    <!-- Contenido -->
    <div class="relative z-10 text-center px-4 sm:px-6 lg:px-8">
        <h1 class="text-4xl sm:text-5xl md:text-6xl font-bold text-white mb-4">
            <span class="block" style="color: #4B34C3;">Descubre tu nueva</span>
            <span class="block" style="color: #2BB15D;">Billetera Digital</span>
        </h1>
        <p class="text-xl sm:text-2xl text-gray-300 mb-8 max-w-3xl mx-auto">
            Administra tu dinero de forma <strong style="color: #2BB15D;">fácil</strong>, <strong style="color: #2BB15D;">segura</strong> y sin complicaciones. Ideal para emprendedores y cualquier persona que quiera tener el <strong style="color: #2BB15D;">control de su pago</strong>.
        </p>

        <button
            class="font-bold py-3 px-8 rounded-full text-lg transition duration-300 hover:scale-105"
            style="background-color: #3E8E6A; color: white;"
            onclick="window.location.href = 'register.jsp';">
            Regístrate ahora <i class="ml-1 fi fi-rs-user-add"></i>
        </button>
    </div>
</div>
        
        
      <main class="w-full px-4 md:px-8 lg:px-20 mt-20 mb-16">
  <div class="flex flex-col md:flex-row items-center bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-lg transition-all max-w-6xl mx-auto overflow-hidden">

    <!-- Imagen lateral -->
    <img 
      class="object-contain w-full max-h-64 md:max-h-full md:w-64 md:rounded-none md:rounded-s-lg"
      src="img/pagobot.png"
      alt="Equipo FaciPago"
    />

    <!-- Contenido -->
    <div class="flex flex-col justify-between p-6 leading-normal w-full bg-gradient-to-br from-[#2BB15D]/90 to-[#1E4D3C]/90 text-white">
      <h2 class="mb-3 text-3xl font-bold tracking-tight">¿Por qué confiar en nosotros?</h2>

      <p class="mb-4 text-white/90">
        En FaciPago nos tomamos en serio tu seguridad y comodidad financiera. Nuestro equipo combina experiencia en tecnología, finanzas y atención al cliente para ofrecerte una plataforma confiable, eficiente y fácil de usar.
      </p>

      <!-- Fortalezas del equipo -->
      <ul class="grid grid-cols-1 md:grid-cols-2 gap-2 text-sm mb-4 font-medium">
        <li class="flex items-center gap-2 bg-white/10 p-2 rounded"><i class="fi fi-rs-lock"></i> Seguridad avanzada</li>
        <li class="flex items-center gap-2 bg-white/10 p-2 rounded"><i class="fi fi-rs-user-time"></i> Soporte 24/7</li>
        <li class="flex items-center gap-2 bg-white/10 p-2 rounded"><i class="fi fi-rs-chart-pie-alt"></i> Tecnología escalable</li>
        <li class="flex items-center gap-2 bg-white/10 p-2 rounded"><i class="fi fi-rs-heart"></i> Compromiso con el usuario</li>
      </ul>

      <!-- Botón como enlace -->
      <a href="conocenos.jsp" class="self-start inline-block px-6 py-3 bg-white text-[#2BB15D] font-bold rounded-full hover:bg-gray-100 transition-colors shadow">
        Conoce más de nosotros <i class="fi fi-rs-arrow-alt-right ml-2 mt-1"></i>
      </a>
    </div>

  </div>
</main>
        
        
        
        
        
        <div class="relative bg-[#F4F7FA] overflow-hidden">
  <div class="max-w-7xl mx-auto">
    <div class="relative z-10 pb-16 bg-[#F4F7FA] sm:pb-20 md:pb-24 lg:max-w-2xl lg:w-full lg:pb-32 xl:pb-36">
      <svg class="hidden lg:block absolute right-0 inset-y-0 h-full w-48 text-[#F4F7FA] transform translate-x-1/2"
           fill="currentColor" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">
        <polygon points="50,0 100,0 50,100 0,100" />
      </svg>

      <div class="relative pt-6 px-4 sm:px-6 lg:px-8"></div>

      <main class="mt-12 mx-auto max-w-7xl px-4 sm:mt-16 sm:px-6 md:mt-20 lg:mt-24 lg:px-8 xl:mt-32">
        <div class="sm:text-center lg:text-left">
          <h1 class="text-4xl tracking-tight font-extrabold text-[#2BB15D] sm:text-5xl md:text-6xl leading-tight">
            <span class="block">FaciPago</span>
            <span class="block text-[#4B34C3]">la forma inteligente de pagar</span>
          </h1>
          <p class="mt-4 text-base text-gray-600 sm:mt-6 sm:text-lg sm:max-w-xl sm:mx-auto md:mt-6 md:text-xl lg:mx-0">
            Pagos rápidos, seguros y sin complicaciones. Disfruta de una plataforma moderna para todas tus transacciones.
          </p>
          <div class="mt-6 sm:mt-8 sm:flex sm:justify-center lg:justify-start">
            <div class="rounded-md shadow">
              <a href="conocenos.jsp"
                 class="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-semibold rounded-xl text-white bg-[#2BB15D] hover:bg-[#24A150] md:py-4 md:text-lg md:px-10 transition duration-300 ease-in-out">
                Conoce más
              </a>
            </div>
            <div class="mt-3 sm:mt-0 sm:ml-3">
              <a href="conocenos.jsp"
                 class="w-full flex items-center justify-center px-8 py-3 border border-[#4B34C3] text-base font-semibold rounded-xl text-[#4B34C3] bg-white hover:bg-[#F0F0FF] md:py-4 md:text-lg md:px-10 transition duration-300 ease-in-out">
                Ver funcionalidades
              </a>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
  <div class="lg:absolute lg:inset-y-0 lg:right-0 lg:w-1/2 lg:h-full overflow-hidden">
  <img class="h-56 w-full object-cover sm:h-72 md:h-96 lg:w-full lg:h-full transform scale-95"
       src="img/fondo2.png"
       alt="Interfaz moderna de FaciPago">
</div>
</div>
        
        
<a href="https://wa.me/51940171614?text=Hola,%20me%20gustaría%20más%20información" 
   class="whatsapp-float" 
   target="_blank" 
   title="Contáctanos por WhatsApp">
  <img src="https://img.icons8.com/color/48/000000/whatsapp--v1.png" 
       alt="WhatsApp">
</a>
       
        
        
        

       <section class="py-16 bg-gradient-to-b from-blue-50 to-white">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="text-center mb-12">
      <h2 class="text-3xl font-extrabold tracking-tight text-blue-900 sm:text-4xl mb-4">Novedades sobre FaciPago</h2>
      <p class="mt-3 max-w-3xl mx-auto text-lg text-blue-600">
        Descubre las últimas novedades, mejoras e implementaciones del sistema FaciPago para usuarios y empresas.
      </p>
    </div>

    <!-- Carrusel -->
    <div id="carousel-facipago" class="relative w-full" data-carousel="slide">
      <!-- Imágenes -->
      <div class="relative h-64 overflow-hidden rounded-lg md:h-96">
        <!-- Noticia 1 -->
        <div class="hidden duration-700 ease-in-out" data-carousel-item="active">
          <a href="index.jsp">
            <img src="img/carrusel1.png" class="absolute block w-full h-full object-cover" alt="Nueva función QR en FaciPago">
          </a>
        </div>
        <!-- Noticia 2 -->
        <div class="hidden duration-700 ease-in-out" data-carousel-item>
          <a href="index.jsp">
            <img src="img/carrusel2.png" class="absolute block w-full h-full object-cover" alt="FaciPago se integra con billeteras digitales">
          </a>
        </div>
        <!-- Noticia 3 -->
        <div class="hidden duration-700 ease-in-out" data-carousel-item>
          <a href="index.jsp">
            <img src="img/carrusel3.png" class="absolute block w-full h-full object-cover" alt="Campaña FaciPago sin comisiones">
          </a>
        </div>
      </div>

      <!-- Controles -->
      <button type="button" class="absolute top-0 start-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none" data-carousel-prev>
        <span class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-blue-700/60 group-hover:bg-blue-800/80 focus:ring-4 focus:ring-white">
          <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
          </svg>
          <span class="sr-only">Anterior</span>
        </span>
      </button>
      <button type="button" class="absolute top-0 end-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none" data-carousel-next>
        <span class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-blue-700/60 group-hover:bg-blue-800/80 focus:ring-4 focus:ring-white">
          <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
          </svg>
          <span class="sr-only">Siguiente</span>
        </span>
      </button>
    </div>
  </div>
</section>


        <footer class="bg-[#1B2E2A] text-white mt-10 rounded-t-3xl shadow-xl">
  <div class="max-w-7xl mx-auto px-6 py-14 grid grid-cols-1 md:grid-cols-3 gap-10 items-start">

    <!-- Logo y nombre -->
    <div class="space-y-4 flex flex-col items-start">
      <div class="flex items-center space-x-3">
        <img src="img/logos.png" alt="Logo" class="w-12 h-12 object-contain rounded-lg shadow-md">
        <h2 class="text-3xl font-extrabold">
          <span class="text-[#4B34C3]">Faci</span><span class="text-[#2BB15D]">Pago</span>
        </h2>
      </div>
      <p class="text-[#B0B3C2] text-sm leading-relaxed">La forma más fácil y segura de manejar tu dinero desde cualquier lugar del Perú. Todo en una sola billetera digital.</p>
    </div>

    <!-- Enlaces útiles -->
    <div>
      <h3 class="text-lg font-semibold mb-4 text-[#2BB15D]">Navegación</h3>
      <ul class="space-y-2 text-[#B0B3C2] text-sm">
        <li><a href="terminos.html" class="hover:text-white"><i class="fa fa-angle-right mr-2"></i>Términos y condiciones</a></li>
        <li><a href="privacidad.html" class="hover:text-white"><i class="fa fa-angle-right mr-2"></i>Política de privacidad</a></li>
        <li><a href="soporte.html" class="hover:text-white"><i class="fa fa-angle-right mr-2"></i>Centro de soporte</a></li>
        <li><a href="faq.html" class="hover:text-white"><i class="fa fa-angle-right mr-2"></i>Preguntas frecuentes</a></li>
      </ul>
    </div>

    <!-- Contacto y redes -->
    <div>
      <h3 class="text-lg font-semibold mb-4 text-[#4B34C3]">Contáctanos</h3>
      <ul class="space-y-3 text-[#B0B3C2] text-sm">
        <li><i class="fa fa-phone-alt mr-2"></i>+51 999 999 999</li>
        <li><i class="fa fa-map-marker-alt mr-2"></i>Lima, Perú</li>
        <li><i class="fa fa-envelope mr-2"></i>contacto@facipago.pe</li>
      </ul>

      <div class="flex space-x-4 mt-4">
        <a href="#" target="_blank" class="hover:text-[#2BB15D]"><i class="fab fa-facebook-f text-xl"></i></a>
        <a href="#" target="_blank" class="hover:text-[#2BB15D]"><i class="fab fa-instagram text-xl"></i></a>
        <a href="#" target="_blank" class="hover:text-[#2BB15D]"><i class="fab fa-tiktok text-xl"></i></a>
      </div>
    </div>

  </div>

  <!-- Footer inferior -->
  <div class="border-t border-[#2BB15D]/20 mt-10 pt-6 pb-4 text-center text-sm text-[#B0B3C2]">
    <p>&copy; 2025 <span class="text-[#4B34C3] font-semibold">Faci</span><span class="text-[#2BB15D] font-semibold">Pago</span>. Todos los derechos reservados.</p>
    <p class="mt-1">Tu dinero, tu control. Servicios tecnológicos de transacción seguros.</p>
  </div>
</footer>



    <script src="js/carrusel.js"></script>
        
        <script>
  document.getElementById("menu-button").addEventListener("click", function () {
    const nav = document.getElementById("navbar-collapse");
    nav.classList.toggle("hidden");
  });

  function toggleSubMenu(id) {
    // Oculta todos los submenús abiertos excepto el que se va a mostrar
    document.querySelectorAll("ul[id^='submenu']").forEach(el => {
      if (el.id !== id) el.classList.add("hidden");
    });

    // Alternar visibilidad del submenú seleccionado
    const submenu = document.getElementById(id);
    submenu.classList.toggle("hidden");
  }

  // Cierra los submenús si haces clic fuera
  document.addEventListener("click", function (e) {
    const isInside = e.target.closest("button[onclick], ul[id^='submenu']");
    if (!isInside) {
      document.querySelectorAll("ul[id^='submenu']").forEach(el => el.classList.add("hidden"));
    }
  });
</script>
<script src="https://cdn.tailwindcss.com"></script>
<!-- Flowbite -->
<script src="https://unpkg.com/flowbite@2.2.1/dist/flowbite.min.js"></script>
<script type="text/javascript">
    var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
    (function(){
    var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
    s1.async=true;
    s1.src='https://embed.tawk.to/681a3af7c905ab190eada0e4/1iqj7cm0s';
    s1.charset='UTF-8';
    s1.setAttribute('crossorigin','*');
    s0.parentNode.insertBefore(s1,s0);
    })();
    </script>

    </body>

</html>
