<%-- 
    Document   : ayuda
    Created on : 17 nov 2024, 22:57:37
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
     <li><a href="preguntas.jsp"
        class="block px-5 py-2 text-gray-700 hover:bg-gray-100 hover:text-[#4B34C3]">ayuda general</a></li>
    <li><a href="reclamos.jsp"
        class="block px-5 py-2 text-gray-700 hover:bg-gray-100 hover:text-[#4B34C3]">Reclamos</a></li>  
    <li><a href="preguntas.jsp"
        class="block px-5 py-2 text-gray-700 hover:bg-gray-100 hover:text-[#4B34C3]">Preguntas Frecuentes</a></li>
    
  </ul>
</div>

  <!-- Novedades -->
  <a href="novedades.jsp" class="flex items-center text-[#4B34C3] font-semibold px-3 py-2 hover:text-[#2BB15D] transition">
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
          <a href="novedades.jsp"
            class="flex items-center px-3 py-2 rounded-md text-[#4B34C3] hover:bg-[#eee] font-semibold">
            <i class="fi fi-rs-newspaper-open w-5 h-5 mr-2"></i>Novedades
          </a>
        </li>
        
        <!-- contactanos -->
       <li>
  <a href="index.jsp"
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

    <section class="py-12 bg-gray-100">
        <div class="container mx-auto text-center mt-20">
            <h2 class="text-3xl font-bold mb-6">Ayuda General</h2>
            <p class="text-cyan-500 mb-4">
                <a href="index.jsp" class="hover:underline font-bold">Inicio</a> / 
                <a href="ayuda.jsp" class="hover:underline font-bold">Ayuda</a>
            </p>
            <p class="mb-4 font-bold" style="font-family: Arial, sans-serif;">Para cualquier consulta o reclamo, puede comunicarse al <strong>+51 999999999</strong></p>
    
            <h3 class="text-2xl font-semibold mb-4" style="font-family: Arial, sans-serif;">Nuestras Oficinas de Atención al cliente se encuentran ubicadas en:</h3>
    
            <div class="mb-8">
                <h4 class="text-xl font-bold" style="font-family: Arial, sans-serif;"></h4>
                <p style="font-family: Arial, sans-serif;">Lima, Peru</p>
                <p><strong>Horario de atención:</strong></p>
                <p style="font-family: Arial, sans-serif;">Lunes a Domingo 24/7</p>
            </div>
    
            
    
            <div class="mt-6">
                <h3 class="text-xl font-semibold mb-2" style="font-family: Arial, sans-serif;">Algunos canales de atencion y dudas</h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    <a href="preguntas.jsp" class="flex flex-col items-center hover:scale-105 transition duration-300">
                        <img src="img/signo.png" alt="Preguntas frecuentes" class="w-24 h-24 mb-2"/>
                        <span class="text-cyan-500 font-bold" style="font-family: Arial, sans-serif;">Preguntas frecuentes</span>
                    </a>
                    
                    <a href="reclamos.jsp" class="flex flex-col items-center hover:scale-105 transition duration-300">
                        <img src="img/megafono.png" alt="Formulario de Reclamos" class="w-24 h-24 mb-2"/>
                        <span class="text-cyan-500 font-bold" style="font-family: Arial, sans-serif;">Formulario de Reclamos</span>
                    </a>

                    
                    
                    <a href="index.jsp" class="flex flex-col items-center hover:scale-105 transition duration-300">
                        <img src="img/sugerencia.png" alt="Sugerencias" class="w-24 h-24 mb-2"/>
                        <span class="text-cyan-500 font-bold" style="font-family: Arial, sans-serif;">Sugerencias (pronto)</span>
                    </a>
                    
                    
                </div>
            </div>
    
        </div>
    </section>
        
        <a href="https://wa.me/51940171614?text=Hola,%20me%20gustaría%20más%20información" 
   class="whatsapp-float" 
   target="_blank" 
   title="Contáctanos por WhatsApp">
  <img src="https://img.icons8.com/color/48/000000/whatsapp--v1.png" 
       alt="WhatsApp">
</a>
    


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
        <li><a href="politicaprivacidad.html" class="hover:text-white"><i class="fa fa-angle-right mr-2"></i>Política de privacidad</a></li>
        <li><a href="ayuda.jsp" class="hover:text-white"><i class="fa fa-angle-right mr-2"></i>Centro de soporte</a></li>
        <li><a href="preguntas.jsp" class="hover:text-white"><i class="fa fa-angle-right mr-2"></i>Preguntas frecuentes</a></li>
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

<script src="js/preguntas.js"> </script>

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
