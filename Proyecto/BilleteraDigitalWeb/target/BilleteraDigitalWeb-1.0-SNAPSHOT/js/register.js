import { consultarDNI, esMayorDeEdad } from './api.js';

let userData = {
  email: '',
  dni: '',
  nombre: '',
  apellidos: '',
  fechaNacimiento: '',
  pin: '',
  telefono: '' // Nuevo campo para teléfono
};

// Función para animar la transición entre cards
function animateCardTransition(newContent) {
  const cardContent = document.getElementById('card-content');
  
  // Agregar animación de salida
  cardContent.classList.add('animate-fade-out');
  
  // Esperar a que termine la animación de salida
  setTimeout(() => {
    // Cambiar el contenido
    cardContent.innerHTML = newContent;
    
    // Remover animación de salida y agregar animación de entrada
    cardContent.classList.remove('animate-fade-out');
    cardContent.classList.add('animate-fade-in');
    
    // Remover la animación de entrada después de que termine
    setTimeout(() => {
      cardContent.classList.remove('animate-fade-in');
    }, 500);
  }, 300);
}

// Función para mostrar el formulario de email
function showEmailForm() {
  const newContent = `
    <div class="h-1 bg-[#2bb15d]"></div>
    <div class="card-body p-8 sm:p-10">
      <div class="text-center mb-8">
        <img src="img/Logo.png" alt="Logo" class="mx-auto mb-4 w-32" />
        <h1 class="text-4xl font-extrabold text-[#513dc4]">Únete a nosotros</h1>
        <p class="text-gray-600 mt-3 text-lg">Ingresa tu correo electrónico para comenzar</p>
      </div>
      
      <form id="email-form">
        <div class="form-control w-full mb-6">
          <label class="label relative">
            <span class="label-text absolute -top-2 left-3 px-2 text-sm font-medium text-[#513dc4] bg-white rounded">Correo Electrónico</span>
            <input 
              type="email" 
              placeholder="ejemplo@correo.com" 
              class="input input-bordered input-md w-full p-3 border-2 border-[#513dc4] rounded-lg focus:border-[#2bb15d] focus:ring-2 focus:ring-[#2bb15d]/20 transition-all duration-300" 
              id="email-input"
              value="${userData.email}"
              required
            />
          </label>
          <div id="email-alert" class="alert text-white alert-error hidden mt-2" role="alert">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span></span>
          </div>
        </div>
        
        <div class="form-control mt-8">
          <button type="submit" class="btn btn-lg w-full bg-[#2bb15d] border-none rounded-full text-white font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300">
            Siguiente
          </button>
        </div>
      </form>
      
      <div class="text-center mt-6">
        <p class="text-sm text-gray-500">
          Al continuar, aceptas nuestros 
          <a href="terminos.html" class="text-[#513dc4] hover:text-[#2bb15d] hover:underline font-medium">Términos y condiciones</a>
        </p>
      </div>
    </div>
  `;
  
  animateCardTransition(newContent);
  
  // Agregar event listeners después de que la animación haya terminado
  setTimeout(() => {
    document.getElementById('email-form').addEventListener('submit', async function(event) {
      event.preventDefault();
      const emailInput = document.getElementById('email-input');
      const submitBtn = event.target.querySelector('button[type="submit"]');
      const emailAlert = document.getElementById('email-alert');
      emailAlert.classList.add('hidden');
      emailAlert.querySelector('span').textContent = '';

      submitBtn.disabled = true;
      submitBtn.innerHTML = `
        <span class="loading loading-spinner"></span>
      `;

      try {
        // Verificar si el correo ya existe
        const checkResponse = await fetch(`http://localhost:8080/BilleteraDigitalWeb/api/usuarios/correo/${encodeURIComponent(emailInput.value)}`, {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'X-API-Key': 'miClaveSecreta123'
          }
        });

        if (!checkResponse.ok) {
          throw new Error('Error al verificar el correo');
        }

        const checkData = await checkResponse.json();
        if (checkData.exists) {
          emailAlert.querySelector('span').textContent = 'Este correo ya está en uso por otro usuario';
          emailAlert.classList.remove('hidden');
          return;
        }

        // Si no existe (exists: false), proceder con el flujo
        userData.email = emailInput.value;
        showDNIForm();
      } catch (error) {
        console.error('Error al verificar el correo:', error);
        emailAlert.querySelector('span').textContent = error.message || 'Error al verificar el correo';
        emailAlert.classList.remove('hidden');
      } finally {
        submitBtn.disabled = false;
        submitBtn.textContent = 'Siguiente';
      }
    });
  }, 500);
}

// Función para mostrar el formulario de DNI
function showDNIForm() {
  const newContent = `
    <div class="h-1 bg-[#2bb15d]"></div>
    <div class="card-body p-8 sm:p-10">
      <div class="text-center mb-8">
        <img src="img/Logo.png" alt="Logo" class="mx-auto mb-4 w-32" />
        <h1 class="text-4xl font-extrabold text-[#513dc4]">Continúa tu registro</h1>
        <p class="text-gray-600 mt-3 text-lg">Ingresa tu número de DNI (máximo 8 dígitos)</p>
      </div>
      
      <form id="dni-form">
        <div class="form-control w-full mb-6">
          <label class="label relative">
            <span class="label-text absolute -top-2 left-3 px-2 text-sm font-medium text-[#513dc4] bg-white rounded">Número de DNI</span>
            <input 
              type="text" 
              placeholder="12345678" 
              class="input input-bordered input-md w-full p-3 border-2 border-[#513dc4] rounded-lg focus:border-[#2bb15d] focus:ring-2 focus:ring-[#2bb15d]/20 transition-all duration-300" 
              maxlength="8"
              pattern="[0-9]{8}"
              id="dni-input"
              value="${userData.dni}"
              required
            />
          </label>
          <div id="dni-alert" class="alert alert-error text-white hidden mt-2" role="alert">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span></span>
          </div>
        </div>
        
        <div class="form-control mt-8 flex flex-col sm:flex-row gap-4">
          <button type="button" id="back-button" class="btn btn-lg w-full sm:w-1/2 bg-gray-300 border-none rounded-full text-gray-800 font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300">
            Regresar
          </button>
          <button type="submit" class="btn btn-lg w-full sm:w-1/2 bg-[#2bb15d] border-none rounded-full text-white font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300" id="submit-dni">
            Verificar
          </button>
        </div>
      </form>
      
      <div class="text-center mt-6">
        <p class="text-sm text-gray-500">
          Al continuar, aceptas nuestros 
          <a href="terminos.html" class="text-[#513dc4] hover:text-[#2bb15d] hover:underline font-medium">Términos y condiciones</a>
        </p>
      </div>
    </div>
  `;

  animateCardTransition(newContent);
  
  setTimeout(() => {
    document.getElementById('back-button').addEventListener('click', showEmailForm);
    
    document.getElementById('dni-form').addEventListener('submit', async function(e) {
      e.preventDefault();
      const dniInput = document.getElementById('dni-input');
      const submitBtn = document.getElementById('submit-dni');
      const dniAlert = document.getElementById('dni-alert');
      dniAlert.classList.add('hidden');
      dniAlert.querySelector('span').textContent = '';

      if (!/^\d{8}$/.test(dniInput.value)) {
        dniAlert.querySelector('span').textContent = 'Por favor ingrese un DNI válido de 8 dígitos';
        dniAlert.classList.remove('hidden');
        return;
      }

      submitBtn.disabled = true;
      submitBtn.innerHTML = `
        <span class="loading loading-spinner"></span>
      `;

      try {
        // Verificar si el DNI ya existe
        const checkResponse = await fetch(`http://localhost:8080/BilleteraDigitalWeb/api/usuarios/dni/${dniInput.value}`, {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'X-API-Key': 'miClaveSecreta123'
          }
        });

        if (!checkResponse.ok) {
          throw new Error('Error al verificar el DNI');
        }

        const checkData = await checkResponse.json();
        if (checkData.exists) {
          dniAlert.querySelector('span').textContent = 'Este DNI ya está en uso por otro usuario';
          dniAlert.classList.remove('hidden');
          return;
        }

        // Si no existe (exists: false), proceder con la consulta
        const datosUsuario = await consultarDNI(dniInput.value);
        userData.dni = dniInput.value;
        userData.nombre = datosUsuario.nombre;
        userData.apellidos = datosUsuario.apellidos;
        userData.fechaNacimiento = datosUsuario.fechaNacimiento;
        
        const esMayor = esMayorDeEdad(userData.fechaNacimiento);
        
        if (esMayor) {
          showUserDataCard();
        } else {
          document.getElementById('age-modal').showModal();
        }
      } catch (error) {
        console.error('Error al verificar o consultar DNI:', error);
        dniAlert.querySelector('span').textContent = error.message || 'Error al verificar el DNI';
        dniAlert.classList.remove('hidden');
      } finally {
        submitBtn.disabled = false;
        submitBtn.textContent = 'Verificar';
      }
    });
  }, 500);
}

// Función para mostrar los datos del usuario
function showUserDataCard() {
  const newContent = `
    <div class="h-1 bg-[#2bb15d]"></div>
    <div class="card-body p-8 sm:p-10">
      <div class="text-center mb-8">
        <img src="img/Logo.png" alt="Logo" class="mx-auto mb-4 w-32" />
        <h1 class="text-4xl font-extrabold text-[#513dc4]">¡Datos verificados!</h1>
        <p class="text-gray-600 mt-3 text-lg">Puedes editar tus datos si es necesario</p>
      </div>
      
      <div class="bg-[#f8f9fa] rounded-xl p-6 mb-6">
        <div class="flex flex-col gap-4">
          <div class="flex flex-col gap-1">
            <label class="font-medium text-gray-600">Nombre:</label>
            <input 
              type="text" 
              value="${userData.nombre}" 
              class="input input-bordered w-full p-2 border border-gray-300 rounded-lg focus:border-[#2bb15d] focus:ring-2 focus:ring-[#2bb15d]/20"
              id="edit-nombre"
              required
            />
          </div>
          <div class="flex flex-col gap-1">
            <label class="font-medium text-gray-600">Apellidos:</label>
            <input 
              type="text" 
              value="${userData.apellidos}" 
              class="input input-bordered w-full p-2 border border-gray-300 rounded-lg focus:border-[#2bb15d] focus:ring-2 focus:ring-[#2bb15d]/20"
              id="edit-apellidos"
              required
            />
          </div>
          <div class="flex flex-col gap-1">
            <label class="font-medium text-gray-600">Fecha de Nacimiento:</label>
            <input 
              type="date" 
              value="${userData.fechaNacimiento}" 
              class="input input-bordered w-full p-2 border border-gray-300 rounded-lg focus:border-[#2bb15d] focus:ring-2 focus:ring-[#2bb15d]/20"
              id="edit-fecha"
              required
            />
          </div>
          <div class="flex flex-col gap-1">
            <label class="font-medium text-gray-600">DNI:</label>
            <input 
              type="text" 
              value="${userData.dni}" 
              class="input input-bordered w-full p-2 border border-gray-300 rounded-lg focus:border-[#2bb15d] focus:ring-2 focus:ring-[#2bb15d]/20"
              id="edit-dni"
              maxlength="8"
              pattern="[0-9]{8}"
              required
            />
          </div>
          <div class="flex flex-col gap-1">
            <label class="font-medium text-gray-600">Teléfono:</label>
            <input 
              type="tel" 
              placeholder="999999999" 
              value="${userData.telefono}" 
              class="input input-bordered w-full p-2 border border-gray-300 rounded-lg focus:border-[#2bb15d] focus:ring-2 focus:ring-[#2bb15d]/20"
              id="edit-telefono"
              pattern="[0-9]{9}"
              required
            />
          </label>
          </div>
        </div>
      </div>
      
      <div class="form-control mt-8 flex flex-col sm:flex-row gap-4">
        <button type="button" id="back-button" class="btn btn-lg w-full sm:w-1/2 bg-gray-300 border-none rounded-full text-gray-800 font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300">
          Regresar
        </button>
        <button type="button" id="save-button" class="btn btn-lg w-full sm:w-1/2 bg-[#2bb15d] border-none rounded-full text-white font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300">
          Continuar
        </button>
      </div>
    </div>
  `;
  
  animateCardTransition(newContent);
  
  setTimeout(() => {
    document.getElementById('back-button').addEventListener('click', showDNIForm);
    
    document.getElementById('save-button').addEventListener('click', function() {
      userData.nombre = document.getElementById('edit-nombre').value;
      userData.apellidos = document.getElementById('edit-apellidos').value;
      userData.fechaNacimiento = document.getElementById('edit-fecha').value;
      userData.dni = document.getElementById('edit-dni').value;
      userData.telefono = document.getElementById('edit-telefono').value;
      
      const esMayor = esMayorDeEdad(userData.fechaNacimiento);
      
      if (!esMayor) {
        document.getElementById('age-modal').showModal();
        return;
      }
      
      this.innerHTML = '<i class="fas fa-check"></i> Guardado';
      setTimeout(() => {
        this.innerHTML = 'Continuar';
        showFacialRecognition();
      }, 1000);
    });
  }, 500);
}

// Función para mostrar el reconocimiento facial
function showFacialRecognition() {
  const newContent = `
    <div class="h-1 bg-[#2bb15d]"></div>
    <div class="card-body p-8 sm:p-10">
      <div id="intro-screen">
        <div class="text-center mb-8">
          <img src="img/Logo.png" alt="Logo" class="mx-auto mb-4 w-32" />
          <h1 class="text-4xl font-extrabold text-[#513dc4]">Verificación Biométrica</h1>
          <p class="text-gray-600 mt-3 text-lg">Verifica tu identidad para tu billetera digital</p>
        </div>
        <button id="start-scan-btn" class="btn btn-lg w-full bg-[#2bb15d] border-none rounded-full text-white font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300">
          Iniciar Verificación
        </button>
        <div class="text-center mt-6">
          <div class="flex items-center justify-center gap-2 text-sm text-gray-500">
            <i class="fas fa-lock text-[#513dc4]"></i>
            <p>Tu privacidad está protegida</p>
          </div>
        </div>
      </div>
      <div id="camera-screen" class="hidden">
        <div class="relative mb-6">
          <button id="back-from-camera-btn" class="absolute top-0 left-0 btn btn-sm btn-circle bg-gray-300/50 border-none text-gray-800 hover:bg-gray-400">
            <i class="fas fa-arrow-left"></i>
          </button>
          <div class="text-center">
            <h2 class="text-2xl font-semibold text-[#513dc4]">Posiciona tu rostro</h2>
            <p class="text-gray-600 text-sm mt-2">Mantén tu cara centrada en el marco</p>
          </div>
        </div>
        <div class="relative rounded-2xl overflow-hidden border-2 border-[#513dc4]/30 mb-6">
          <div class="aspect-[3/4] bg-black flex items-center justify-center overflow-hidden relative">
            <video id="camera-video" class="absolute inset-0 z-0 h-full w-full object-cover" autoplay playsinline></video>
            <canvas id="camera-canvas" class="hidden absolute inset-0 z-10"></canvas>
            <div class="absolute inset-0 z-10">
              <svg class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2" width="240" height="300" viewBox="0 0 240 300" fill="none">
                <path d="M60 20H30C18.9543 20 10 28.9543 10 40V70" stroke="#2bb15d" stroke-width="3" stroke-linecap="round"/>
                <path d="M180 20H210C221.046 20 230 28.9543 230 40V70" stroke="#2bb15d" stroke-width="3" stroke-linecap="round"/>
                <path d="M60 280H30C18.9543 280 10 271.046 10 260V230" stroke="#2bb15d" stroke-width="3" stroke-linecap="round"/>
                <path d="M180 280H210C221.046 280 230 271.046 230 260V230" stroke="#2bb15d" stroke-width="3" stroke-linecap="round"/>
                <circle cx="120" cy="150" r="90" stroke="#2bb15d" stroke-width="2" stroke-dasharray="6 6"/>
              </svg>
            </div>
            <div id="camera-status" class="absolute bottom-4 left-0 right-0 text-center text-sm font-medium text-white"></div>
          </div>
        </div>
        <button id="take-photo-btn" class="btn btn-lg w-full bg-[#2bb15d] border-none rounded-full text-white font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300">
          <i class="fas fa-camera mr-2"></i> Tomar Foto
        </button>
        <div class="text-center mt-4">
          <p class="text-sm text-gray-600">Asegúrate de estar en un lugar bien iluminado</p>
        </div>
      </div>
      <div id="scan-screen" class="hidden">
        <div class="relative mb-6">
          <button id="back-btn" class="absolute top-0 left-0 btn btn-sm btn-circle bg-gray-300/50 border-none text-gray-800 hover:bg-gray-400">
            <i class="fas fa-arrow-left"></i>
          </button>
          <div class="text-center">
            <h2 class="text-2xl font-semibold text-[#513dc4]">Procesando imagen</h2>
            <p class="text-gray-600 text-sm mt-2">Verificando tu identidad</p>
          </div>
        </div>
        <div class="relative rounded-2xl overflow-hidden border-2 border-[#513dc4]/30 mb-6">
          <div class="aspect-[3/4] bg-black flex items-center justify-center overflow-hidden relative">
            <img id="captured-photo" class="absolute inset-0 z-0 h-full w-full object-cover" />
            <div id="scan-overlay" class="absolute inset-0 z-10 opacity-0">
              <div id="face-points" class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-56 h-56"></div>
            </div>
            <div id="scan-line" class="absolute left-0 right-0 h-1 bg-[#2bb15d] hidden"></div>
            <div id="scan-status" class="absolute bottom-4 left-0 right-0 text-center text-sm font-medium text-white"></div>
          </div>
          <div class="absolute bottom-4 left-4 right-4 flex justify-between items-center px-4">
            <div class="text-xs font-mono text-[#513dc4] scan-info hidden">
              <i class="fas fa-circle-notch mr-1"></i>
              <span id="scan-info-text">Iniciando...</span>
            </div>
            <div class="scan-progress hidden">
              <div class="w-16 h-1 bg-gray-300 rounded-full overflow-hidden">
                <div id="progress-bar" class="h-full w-0 bg-[#2bb15d] transition-all duration-300"></div>
              </div>
            </div>
          </div>
        </div>
        <div class="text-center">
          <p id="scan-instructions" class="text-sm text-gray-600">Procesando datos biométricos</p>
        </div>
      </div>
      <div id="success-screen" class="hidden">
        <div class="text-center mb-8">
          <img src="img/Logo.png" alt="Logo" class="mx-auto mb-4 w-32" />
          <h1 class="text-4xl font-extrabold text-[#513dc4]">¡Verificación Exitosa!</h1>
          <p class="text-gray-600 mt-3 text-lg">Tu identidad ha sido confirmada</p>
        </div>
        <div class="space-y-4 mb-6">
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-[#2bb15d]/20 flex items-center justify-center">
              <i class="fas fa-shield-alt text-[#2bb15d]"></i>
            </div>
            <p class="text-sm text-gray-600">Autenticación biométrica completada</p>
          </div>
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-[#2bb15d]/20 flex items-center justify-center">
              <i class="fas fa-fingerprint text-[#2bb15d]"></i>
            </div>
            <p class="text-sm text-gray-600">Datos faciales verificados</p>
          </div>
        </div>
        <button id="continue-btn" class="btn btn-lg w-full bg-[#2bb15d] border-none rounded-full text-white font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300">
          Continuar
        </button>
      </div>
    </div>
  `;

  animateCardTransition(newContent);
  
  setTimeout(() => {
    // Variables para reconocimiento facial
    let scanInProgress = false;
    let scanProgress = 0;
    let cameraStream = null;
    let photoTaken = false;

    // DOM References
    const introScreen = document.getElementById('intro-screen');
    const cameraScreen = document.getElementById('camera-screen');
    const scanScreen = document.getElementById('scan-screen');
    const successScreen = document.getElementById('success-screen');
    const cameraVideo = document.getElementById('camera-video');
    const cameraCanvas = document.getElementById('camera-canvas');
    const cameraStatus = document.getElementById('camera-status');
    const capturedPhoto = document.getElementById('captured-photo');
    const facePoints = document.getElementById('face-points');
    const scanLine = document.getElementById('scan-line');
    const scanStatus = document.getElementById('scan-status');
    const scanInfoText = document.getElementById('scan-info-text');
    const progressBar = document.getElementById('progress-bar');
    const scanOverlay = document.getElementById('scan-overlay');

    // Buttons
    const startScanBtn = document.getElementById('start-scan-btn');
    const takePhotoBtn = document.getElementById('take-photo-btn');
    const backFromCameraBtn = document.getElementById('back-from-camera-btn');
    const backBtn = document.getElementById('back-btn');
    const continueBtn = document.getElementById('continue-btn');

    // Start Camera
    async function startCamera() {
      try {
        const constraints = {
          video: {
            facingMode: 'user',
            width: { ideal: 1280 },
            height: { ideal: 720 }
          }
        };
        cameraStream = await navigator.mediaDevices.getUserMedia(constraints);
        cameraVideo.srcObject = cameraStream;
        cameraStatus.textContent = 'Cámara iniciada. Centra tu rostro.';
        cameraStatus.classList.add('text-[#2bb15d]');
        takePhotoBtn.disabled = false;
      } catch (error) {
        console.error('Error al acceder a la cámara:', error);
        cameraStatus.textContent = 'Error al acceder a la cámara. Por favor, permite el acceso.';
        cameraStatus.classList.add('text-red-500');
        simulateCameraFeed();
      }
    }

    // Simulate Camera Feed
    function simulateCameraFeed() {
      const ctx = cameraCanvas.getContext('2d');
      cameraCanvas.width = 640;
      cameraCanvas.height = 480;
      ctx.fillStyle = '#1f2937';
      ctx.fillRect(0, 0, cameraCanvas.width, cameraCanvas.height);
      ctx.fillStyle = '#4b5563';
      ctx.beginPath();
      ctx.arc(cameraCanvas.width / 2, cameraCanvas.height / 2, 100, 0, Math.PI * 2);
      ctx.fill();
      ctx.fillStyle = '#1f2937';
      ctx.beginPath();
      ctx.ellipse(cameraCanvas.width / 2 - 40, cameraCanvas.height / 2 - 20, 15, 10, 0, 0, Math.PI * 2);
      ctx.ellipse(cameraCanvas.width / 2 + 40, cameraCanvas.height / 2 - 20, 15, 10, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.beginPath();
      ctx.ellipse(cameraCanvas.width / 2, cameraCanvas.height / 2 + 40, 30, 15, 0, 0, Math.PI);
      ctx.fill();
      const dataURL = cameraCanvas.toDataURL('image/png');
      cameraVideo.poster = dataURL;
      cameraStatus.textContent = 'Usando cámara simulada. Centra tu rostro.';
      cameraStatus.classList.add('text-yellow-500');
    }

    // Take Photo
    function takePhoto() {
      const canvas = cameraCanvas;
      const context = canvas.getContext('2d');
      canvas.width = cameraVideo.videoWidth || 640;
      canvas.height = cameraVideo.videoHeight || 480;
      context.drawImage(cameraVideo, 0, 0, canvas.width, canvas.height);
      const photoDataUrl = canvas.toDataURL('image/png');
      capturedPhoto.src = photoDataUrl;
      photoTaken = true;
      showScanScreen();
    }

    // Stop Camera
    function stopCamera() {
      if (cameraStream) {
        cameraStream.getTracks().forEach(track => track.stop());
        cameraStream = null;
      }
      cameraVideo.srcObject = null;
    }

    // Show Camera Screen
    function showCameraScreen() {
      introScreen.classList.add('opacity-0', 'scale-95');
      setTimeout(() => {
        introScreen.classList.add('hidden');
        cameraScreen.classList.remove('hidden');
        cameraScreen.classList.remove('opacity-0', 'scale-95');
        cameraScreen.classList.add('opacity-100', 'scale-100');
        startCamera();
      }, 300);
    }

    // Show Scan Screen
    function showScanScreen() {
      cameraScreen.classList.add('opacity-0', 'scale-95');
      setTimeout(() => {
        cameraScreen.classList.add('hidden');
        scanScreen.classList.remove('hidden');
        scanScreen.classList.remove('opacity-0', 'scale-95');
        scanScreen.classList.add('opacity-100', 'scale-100');
        stopCamera();
        setTimeout(() => startScanSimulation(), 500);
      }, 300);
    }

    // Show Intro Screen
    function showIntroScreen() {
      stopCamera();
      const activeScreen = cameraScreen.classList.contains('hidden') ? scanScreen : cameraScreen;
      activeScreen.classList.add('opacity-0', 'scale-95');
      setTimeout(() => {
        activeScreen.classList.add('hidden');
        introScreen.classList.remove('hidden');
        introScreen.classList.remove('opacity-0', 'scale-95');
        introScreen.classList.add('opacity-100', 'scale-100');
        resetScan();
      }, 300);
    }

    // Show Success Screen
    function showSuccessScreen() {
      scanScreen.classList.add('opacity-0', 'scale-95');
      setTimeout(() => {
        scanScreen.classList.add('hidden');
        successScreen.classList.remove('hidden');
        successScreen.classList.remove('opacity-0', 'scale-95');
        successScreen.classList.add('opacity-100', 'scale-100');
      }, 300);
    }

    // Reset Scan
    function resetScan() {
      scanProgress = 0;
      photoTaken = false;
      scanInProgress = false;
      scanLine.classList.add('hidden');
      scanLine.style.top = '0%';
      progressBar.style.width = '0%';
      scanStatus.textContent = '';
      scanOverlay.style.opacity = '0';
      facePoints.innerHTML = '';
      document.querySelectorAll('.scan-info, .scan-progress').forEach(el => el.classList.add('hidden'));
    }

    // Start Scan Simulation
    function startScanSimulation() {
      scanInProgress = true;
      document.querySelectorAll('.scan-info, .scan-progress').forEach(el => el.classList.remove('hidden'));
      scanInfoText.textContent = 'Analizando imagen...';
      scanStatus.textContent = 'Detectando rasgos faciales';
      setTimeout(() => {
        if (!scanInProgress) return;
        scanOverlay.style.opacity = '1';
        generateFacePoints();
        scanInfoText.textContent = 'Rostro detectado';
        scanStatus.textContent = 'Analizando rasgos biométricos';
        scanLine.classList.remove('hidden');
        startScanLineAnimation();
        startProgressSimulation();
      }, 1500);
    }

    // Generate Face Points
    function generateFacePoints() {
      facePoints.innerHTML = '';
      const pointsCount = 20;
      for (let i = 0; i < pointsCount; i++) {
        const angle = (i / pointsCount) * Math.PI * 2;
        const radiusX = 70 + (Math.sin(i * 8) * 5);
        const radiusY = 100 + (Math.cos(i * 6) * 5);
        const x = Math.cos(angle) * radiusX;
        const y = Math.sin(angle) * radiusY;
        const point = document.createElement('div');
        point.className = 'absolute w-2 h-2 bg-[#2bb15d] rounded-full transition-all duration-300';
        point.style.left = `calc(50% + ${x}px)`;
        point.style.top = `calc(50% + ${y}px)`;
        point.style.opacity = '0';
        setTimeout(() => point.style.opacity = '1', i * 100);
        facePoints.appendChild(point);
      }
    }

    // Start Scan Line Animation
    function startScanLineAnimation() {
      let progress = 0;
      const duration = 3000;
      const interval = 20;
      const animate = () => {
        if (!scanInProgress) return;
        progress += (interval / duration) * 100;
        if (progress >= 100) progress = 0;
        scanLine.style.top = `${progress}%`;
        if (scanInProgress && progress < 100) setTimeout(animate, interval);
      };
      animate();
    }

    // Start Progress Simulation
    function startProgressSimulation() {
      let currentProgress = 0;
      const updateInterval = 100;
      const totalDuration = 5000;
      const progressStep = (updateInterval / totalDuration) * 100;
      const updateProgress = () => {
        if (!scanInProgress) return;
        currentProgress += progressStep;
        progressBar.style.width = `${currentProgress}%`;
        updateScanStatus(currentProgress);
        if (currentProgress >= 100) {
          setTimeout(() => {
            scanStatus.textContent = '¡Verificación completada!';
            scanStatus.classList.add('text-[#2bb15d]', 'font-bold');
            setTimeout(() => showSuccessScreen(), 1000);
          }, 500);
          return;
        }
        if (scanInProgress) setTimeout(updateProgress, updateInterval);
      };
      updateProgress();
    }

    // Update Scan Status
    function updateScanStatus(progress) {
      if (progress < 30) scanInfoText.textContent = 'Analizando rasgos faciales...';
      else if (progress < 60) scanInfoText.textContent = 'Verificando identidad...';
      else if (progress < 90) scanInfoText.textContent = 'Autenticando usuario...';
      else scanInfoText.textContent = 'Completando verificación...';
    }

    // Check Camera Support
    function checkCameraSupport() {
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        alert('Tu navegador no soporta acceso a la cámara. Se usará una simulación.');
        return false;
      }
      return true;
    }

    // Event Listeners para reconocimiento facial
    startScanBtn.addEventListener('click', showCameraScreen);
    backFromCameraBtn.addEventListener('click', () => {
      stopCamera();
      showUserDataCard();
    });
    backBtn.addEventListener('click', () => {
      stopCamera();
      showUserDataCard();
    });
    takePhotoBtn.addEventListener('click', takePhoto);
    continueBtn.addEventListener('click', () => {
      showPinForm();
    });
    checkCameraSupport();
  }, 500);
}

// Función para mostrar el formulario de PIN
function showPinForm() {
  const newContent = `
    <div class="h-1 bg-[#2bb15d]"></div>
    <div class="card-body p-8 sm:p-10">
      <div class="text-center mb-8">
        <img src="img/Logo.png" alt="Logo" class="mx-auto mb-4 w-32" />
        <h1 class="text-4xl font-extrabold text-[#513dc4]">Crea tu PIN de seguridad</h1>
        <p class="text-gray-600 mt-3 text-lg">Ingresa un PIN de 6 dígitos para tu billetera</p>
      </div>
      
      <div class="form-control w-full mb-8">
        <div class="flex justify-center gap-3 mb-4" id="pin-display"></div>
      </div>
      
      <div class="grid grid-cols-3 gap-3 mb-6" id="keypad"></div>
      
      <div class="form-control mt-8 flex flex-col sm:flex-row gap-4">
        <button 
          type="button" 
          id="back-button-pin" 
          class="btn btn-lg w-full sm:w-1/2 bg-gray-300 border-none rounded-full text-gray-800 font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300"
        >
          Regresar
        </button>
        <button 
          type="button" 
          id="finish-registration" 
          class="btn btn-lg w-full sm:w-1/2 bg-[#2bb15d] border-none rounded-full text-white font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300 disabled:opacity-50"
          disabled
        >
          Finalizar Registro
        </button>
      </div>
      
      <div class="text-center mt-6">
        <div class="flex items-center justify-center gap-2 text-sm text-gray-500">
          <i class="fas fa-lock text-[#513dc4]"></i>
          <p>Teclado aleatorio para mayor seguridad</p>
        </div>
        <p class="text-sm text-gray-500 mt-2">
          Al continuar, aceptas nuestros 
          <a href="#" class="text-[#513dc4] hover:text-[#2bb15d] hover:underline font-medium">Términos y condiciones</a>
        </p>
      </div>
    </div>
  `;

  animateCardTransition(newContent);
  
  setTimeout(() => {
    generatePinDisplay();
    generateKeypad();

    document.getElementById('back-button-pin').addEventListener('click', showFacialRecognition);

    document.getElementById('finish-registration').addEventListener('click', async function() {
      this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Registrando...';
      this.disabled = true;

      // Preparar los datos para la API
      const userPayload = {
        nombre: userData.nombre,
        apellido: userData.apellidos,
        correo: userData.email,
        contraseña: userData.pin,
        dni: userData.dni,
        telefono: userData.telefono,
        fechaNacimiento: userData.fechaNacimiento
      };

      try {
        const response = await fetch('http://localhost:8080/BilleteraDigitalWeb/api/usuarios/register', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-API-Key': 'miClaveSecreta123'
          },
          body: JSON.stringify(userPayload)
        });

        if (!response.ok) {
          const errorData = await response.json();
          throw new Error(errorData.error || 'Error al registrar usuario');
        }

        const result = await response.json();
        alert(result.message || 'Usuario registrado exitosamente');
        // Redirigir a login.jsp
        window.location.href = '/BilleteraDigitalWeb/login.jsp';
      } catch (error) {
        console.error('Error al registrar:', error);
        alert('Error: ' + error.message);
        this.innerHTML = 'Finalizar Registro';
        this.disabled = false;
      }
    });
  }, 500);
}

// Funciones para el teclado de PIN
function generatePinDisplay() {
  const display = document.getElementById('pin-display');
  display.innerHTML = '';
  for (let i = 0; i < 6; i++) {
    const dot = document.createElement('div');
    dot.classList.add('w-5', 'h-5', 'rounded-full', 'border-2', 'border-[#513dc4]', 'transition-all', 'duration-300');
    dot.id = `pin-dot-${i}`;
    display.appendChild(dot);
  }
}

function shuffleArray(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

function generateKeypad() {
  const numbers = shuffleArray([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
  const keypad = document.getElementById('keypad');
  keypad.innerHTML = '';
  
  numbers.slice(0, 9).forEach(num => {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'btn bg-white border border-[#513dc4]/20 hover:bg-[#2bb15d] hover:text-white text-[#513dc4] rounded-xl text-xl font-medium shadow-sm transition-all duration-200 hover:shadow-md';
    button.textContent = num;
    button.onclick = () => addDigit(num);
    keypad.appendChild(button);
  });
  
  keypad.appendChild(document.createElement('div'));
  
  const zeroButton = document.createElement('button');
  zeroButton.type = 'button';
  zeroButton.className = 'btn bg-white border border-[#513dc4]/20 hover:bg-[#2bb15d] hover:text-white text-[#513dc4] rounded-xl text-xl font-medium shadow-sm transition-all duration-200 hover:shadow-md';
  zeroButton.textContent = numbers[9];
  zeroButton.onclick = () => addDigit(numbers[9]);
  keypad.appendChild(zeroButton);
  
  const backspaceButton = document.createElement('button');
  backspaceButton.type = 'button';
  backspaceButton.className = 'btn bg-white border border-[#513dc4]/20 hover:bg-[#2bb15d] hover:text-white text-[#513dc4] rounded-xl text-xl font-medium shadow-sm transition-all duration-200 hover:shadow-md';
  backspaceButton.innerHTML = '<i class="fas fa-backspace"></i>';
  backspaceButton.onclick = removePinDigit;
  keypad.appendChild(backspaceButton);
}

function addDigit(digit) {
  if (userData.pin.length < 6) {
    userData.pin += digit;
    updatePinDisplay();
    if (userData.pin.length === 6) {
      document.getElementById('finish-registration').disabled = false;
    }
  }
}

function removePinDigit() {
  if (userData.pin.length > 0) {
    userData.pin = userData.pin.slice(0, -1);
    updatePinDisplay();
    document.getElementById('finish-registration').disabled = true;
  }
}

function updatePinDisplay() {
  for (let i = 0; i < 6; i++) {
    const dot = document.getElementById(`pin-dot-${i}`);
    if (i < userData.pin.length) {
      dot.classList.remove('border-[#513dc4]', 'bg-transparent');
      dot.classList.add('border-[#2bb15d]', 'bg-[#2bb15d]', 'scale-125');
    } else {
      dot.classList.remove('border-[#2bb15d]', 'bg-[#2bb15d]', 'scale-125');
      dot.classList.add('border-[#513dc4]', 'bg-transparent');
    }
  }
}

// Inicialización
document.addEventListener('DOMContentLoaded', function() {
  // Añadir estilos CSS para las animaciones
  const style = document.createElement('style');
  style.textContent = `
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes fadeOut {
      from { opacity: 1; transform: translateY(0); }
      to { opacity: 0; transform: translateY(-10px); }
    }
    .animate-fade-in {
      animation: fadeIn 0.5s ease-out forwards;
    }
    .animate-fade-out {
      animation: fadeOut 0.3s ease-in forwards;
    }
  `;
  document.head.appendChild(style);
  
  showEmailForm();
});
