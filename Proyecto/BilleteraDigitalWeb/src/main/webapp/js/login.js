let userData = {
  email: '',
  pin: ''
};

// Función para mostrar el formulario de email
function showEmailForm() {
  const cardContent = document.getElementById('card-content');
  cardContent.classList.add('opacity-0', 'scale-95');
  setTimeout(() => {
    cardContent.innerHTML = `
      <div class="h-1 bg-[#2bb15d]"></div>
      <div class="card-body p-8 sm:p-10 animate-slide-in">
        <div class="text-center mb-8">
          <img src="img/Logo.png" alt="Logo" class="mx-auto mb-4 w-32" />
          <h1 class="text-4xl font-extrabold text-[#513dc4]">Iniciar Sesión</h1>
          <p class="text-gray-600 mt-3 text-lg">Ingresa tu correo electrónico para continuar</p>
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
            <div id="email-alert" class="alert alert-error text-white mt-2 hidden" role="alert">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
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
            ¿No tienes una cuenta? 
            <a href="register.jsp" class="text-[#513dc4] hover:text-[#2bb15d] hover:underline font-medium">Registrar</a>
          </p>
        </div>
      </div>
    `;
    cardContent.classList.remove('opacity-0', 'scale-95');
    cardContent.classList.add('opacity-100', 'scale-100');

    document.getElementById('email-form').addEventListener('submit', async function(event) {
      event.preventDefault();
      const emailInput = document.getElementById('email-input');
      const submitBtn = event.target.querySelector('button[type="submit"]');
      const emailAlert = document.getElementById('email-alert');
      emailAlert.classList.add('hidden');
      emailAlert.querySelector('span').textContent = '';

      submitBtn.disabled = true;
      submitBtn.innerHTML = '<span class="loading loading-spinner"></span>';

      try {
        const response = await fetch(`http://localhost:8080/BilleteraDigitalWeb/api/usuarios/correo/${encodeURIComponent(emailInput.value)}`, {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'X-API-Key': 'miClaveSecreta123'
          }
        });

        if (!response.ok) {
          throw new Error('Error al verificar el correo');
        }

        const data = await response.json();
        if (!data.exists) {
          emailAlert.querySelector('span').textContent = 'No hay un correo asociado registrado';
          emailAlert.classList.remove('hidden');
          return;
        }

        userData.email = emailInput.value;
        showPinForm();
      } catch (error) {
        console.error('Error al verificar el correo:', error);
        emailAlert.querySelector('span').textContent = 'Error al verificar el correo';
        emailAlert.classList.remove('hidden');
      } finally {
        submitBtn.disabled = false;
        submitBtn.textContent = 'Siguiente';
      }
    });
  }, 300);
}

// Función para mostrar el formulario de PIN
function showPinForm() {
  const cardContent = document.getElementById('card-content');
  cardContent.classList.add('opacity-0', 'scale-95');
  setTimeout(() => {
    cardContent.innerHTML = `
      <div class="h-1 bg-[#2bb15d]"></div>
      <div class="card-body p-8 sm:p-10 animate-fade-in">
        <div class="text-center mb-8">
          <img src="img/Logo.png" alt="Logo" class="mx-auto mb-4 w-32" />
          <h1 class="text-4xl font-extrabold text-[#513dc4]">Ingresa tu PIN</h1>
          <p class="text-gray-600 mt-3 text-lg">Usa tu PIN de 6 dígitos para iniciar sesión</p>
        </div>
        
        <div class="form-control w-full mb-8">
          <div class="flex justify-center gap-3 mb-4" id="pin-display"></div>
          <div id="pin-alert" class="alert alert-error text-white mt-2 hidden" role="alert">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <span></span>
          </div>
        </div>
        
        <div class="grid grid-cols-3 gap-3 mb-6" id="keypad"></div>
        
        <div class="form-control mt-8 flex flex-col sm:flex-row gap-4">
          <button 
            type="button" 
            id="back-button" 
            class="btn btn-lg w-full sm:w-1/2 bg-gray-300 border-none rounded-full text-gray-800 font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300"
          >
            Regresar
          </button>
          <button 
            type="button" 
            id="login-button" 
            class="btn btn-lg w-full sm:w-1/2 bg-[#2bb15d] border-none rounded-full text-white font-semibold text-lg hover:shadow-xl hover:scale-105 transform transition-all duration-300 disabled:opacity-50"
            disabled
          >
            Iniciar Sesión
          </button>
        </div>
        
        <div class="text-center mt-6">
          <div class="flex items-center justify-center gap-2 text-sm text-gray-500">
            <i class="fas fa-lock text-[#513dc4]"></i>
            <p>Teclado aleatorio para mayor seguridad</p>
          </div>
        </div>
      </div>
    `;
    cardContent.classList.remove('opacity-0', 'scale-95');
    cardContent.classList.add('opacity-100', 'scale-100');

    generatePinDisplay();
    generateKeypad();

    document.getElementById('back-button').addEventListener('click', showEmailForm);

    document.getElementById('login-button').addEventListener('click', async function() {
      const loginBtn = this;
      const pinAlert = document.getElementById('pin-alert');
      pinAlert.classList.add('hidden');
      pinAlert.querySelector('span').textContent = '';

      loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Iniciando...';
      loginBtn.disabled = true;

      try {
        const response = await fetch(`http://localhost:8080/BilleteraDigitalWeb/api/usuarios/login?correo=${encodeURIComponent(userData.email)}&contraseña=${encodeURIComponent(userData.pin)}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-API-Key': 'miClaveSecreta123'
          }
        });

        if (!response.ok) {
          const errorData = await response.json();
          throw new Error(errorData.error || 'Error al iniciar sesión');
        }

        const data = await response.json();
        window.location.href = 'panelUsuario.jsp';
      } catch (error) {
        console.error('Error al iniciar sesión:', error);
        pinAlert.querySelector('span').textContent = 'Contraseña incorrecta';
        pinAlert.classList.remove('hidden');
      } finally {
        loginBtn.innerHTML = 'Iniciar Sesión';
        loginBtn.disabled = false;
      }
    });
  }, 300);
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
      document.getElementById('login-button').disabled = false;
    }
  }
}

function removePinDigit() {
  if (userData.pin.length > 0) {
    userData.pin = userData.pin.slice(0, -1);
    updatePinDisplay();
    document.getElementById('login-button').disabled = true;
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
  showEmailForm();
});