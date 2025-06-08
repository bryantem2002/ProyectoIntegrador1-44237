document.addEventListener('DOMContentLoaded', () => {
    console.log('Iniciando datoscuenta.js');

    // Elementos del DOM
    const menuButton = document.getElementById('menuButton');
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');
    const configButton = document.getElementById('configButton');
    const configMenu = document.getElementById('configMenu');
    const logoutButton = document.getElementById('logoutButton');
    const nombreUsuario = document.getElementById('nombreUsuario');
    const correoUsuario = document.getElementById('correoUsuario');
    const bienvenida = document.getElementById('bienvenida');
    const saldo = document.getElementById('saldo');
    const errorSaldo = document.getElementById('errorSaldo');
    const listaMovimientos = document.getElementById('listaMovimientos');
    const errorMovimientos = document.getElementById('errorMovimientos');
    const transferButton = document.getElementById('transferButton');
    const transferModal = document.getElementById('transferModal');
    const accountInputView = document.getElementById('accountInputView');
    const transferDetailsView = document.getElementById('transferDetailsView');
    const loadingView = document.getElementById('loadingView');
    const successView = document.getElementById('successView');
    const accountNumberInput = document.getElementById('accountNumber');
    const pinAlert = document.getElementById('pin-alert');
    const errorAlert = document.getElementById('error-alert');
    const closeButton = document.getElementById('closeButton');
    const backButton = document.getElementById('backButton');
    const nextButton = document.getElementById('nextButton');
    const cancelButton = document.getElementById('cancelButton');
    const recipientName = document.getElementById('recipientName');
    const userAccountNumber = document.getElementById('userAccountNumber');
    const maskedAccountNumber = document.getElementById('maskedAccountNumber');
    const userBalance = document.getElementById('userBalance');
    const transferAmount = document.getElementById('transferAmount');
    const transferMessage = document.getElementById('transferMessage');
    const cancelTransferButton = document.getElementById('cancelTransferButton');
    const confirmTransferButton = document.getElementById('confirmTransferButton');
    const closeSuccessButton = document.getElementById('closeSuccessButton');
    const transferSummary = document.getElementById('transferSummary');
    const accountNumberDisplay = document.getElementById('accountNumberDisplay');
    const iconoOjoCuenta = document.getElementById('iconoOjoCuenta');
    const historyModal = document.getElementById('historyModal');
    const closeHistoryButton = document.getElementById('closeHistoryButton');
    const closeHistoryButtonBottom = document.getElementById('closeHistoryButtonBottom');
    const makeAnotherTransferButton = document.getElementById('makeAnotherTransferButton');
    const historyDate = document.getElementById('historyDate');
    const historyTime = document.getElementById('historyTime');
    const historyAmount = document.getElementById('historyAmount');
    const historyType = document.getElementById('historyType');
    const historyOrigin = document.getElementById('historyOrigin');
    const historyDestination = document.getElementById('historyDestination');
    const historyMessage = document.getElementById('historyMessage');
    // Elementos del modal de recarga
    const rechargeButton = document.getElementById('rechargeButton');
    const rechargeModal = document.getElementById('rechargeModal');
    const rechargeInputView = document.getElementById('rechargeInputView');
    const rechargeLoadingView = document.getElementById('rechargeLoadingView');
    const rechargeSuccessView = document.getElementById('rechargeSuccessView');
    const rechargeAmount = document.getElementById('rechargeAmount');
    const rechargeErrorAlert = document.getElementById('rechargeErrorAlert');
    const rechargeCloseButton = document.getElementById('rechargeCloseButton');
    const rechargeCancelButton = document.getElementById('rechargeCancelButton');
    const rechargeConfirmButton = document.getElementById('rechargeConfirmButton');
    const rechargeCloseSuccessButton = document.getElementById('rechargeCloseSuccessButton');
    const rechargeSummary = document.getElementById('rechargeSummary');

    let isOpen = false;
    let isConfigOpen = false;
    let isSaldoVisible = false;
    let userAccountData = null;
    let recipientData = null;
    let transferHistory = [];
    let currentTransferId = null;

    window.userAccountData = userAccountData; // Exponer globalmente

    // Verificar elementos
    const elements = {
        menuButton, sidebar, overlay, configButton, configMenu, logoutButton, nombreUsuario, correoUsuario, bienvenida, saldo, errorSaldo, listaMovimientos, errorMovimientos,
        transferButton, transferModal, accountInputView, transferDetailsView, loadingView, successView, accountNumberInput, pinAlert, errorAlert, closeButton,
        backButton, nextButton, cancelButton, recipientName, userAccountNumber, maskedAccountNumber, userBalance, transferAmount, transferMessage,
        cancelTransferButton, confirmTransferButton, closeSuccessButton, transferSummary, accountNumberDisplay, iconoOjoCuenta,
        historyModal, closeHistoryButton, closeHistoryButtonBottom, makeAnotherTransferButton, historyDate, historyTime, historyAmount, historyType, historyOrigin, historyDestination, historyMessage,
        rechargeButton, rechargeModal, rechargeInputView, rechargeLoadingView, rechargeSuccessView, rechargeAmount, rechargeErrorAlert, rechargeCloseButton, rechargeCancelButton, rechargeConfirmButton, rechargeCloseSuccessButton, rechargeSummary
    };
    Object.entries(elements).forEach(([key, element]) => {
        if (!element) {
            console.warn(`Elemento "${key}" no encontrado en el DOM. Verifica que el ID exista en panelUsuario.jsp.`);
        }
    });

    // Actualizar saldo en userAccountData y UI
    function updateUserBalance(newBalance) {
        console.log('Actualizando saldo:', newBalance);
        if (userAccountData) {
            userAccountData.saldo = newBalance;
            window.userAccountData = userAccountData;
            console.log('userAccountData actualizado:', userAccountData);
        } else {
            console.warn('userAccountData es null al intentar actualizar saldo');
        }
        if (saldo) {
            const saldoValue = parseFloat(newBalance);
            const saldoFormatted = isNaN(saldoValue) ? '0.00' : saldoValue.toFixed(2);
            saldo.dataset.saldo = 'S/' + saldoFormatted;
            saldo.textContent = isSaldoVisible ? saldo.dataset.saldo : '••••••';
            console.log('Saldo en UI actualizado:', saldo.dataset.saldo);
        } else {
            console.warn('Elemento #saldo no encontrado');
        }
        if (userBalance) {
            const saldoValue = parseFloat(newBalance);
            const saldoFormatted = isNaN(saldoValue) ? '0.00' : saldoValue.toFixed(2);
            userBalance.textContent = 'Saldo: S/' + saldoFormatted;
        } else {
            console.warn('Elemento #userBalance no encontrado');
        }
    }
    window.updateUserBalance = updateUserBalance; // Exponer globalmente

    // Formatear fecha (YYYY-MM-DD)
    function formatDate(isoDate) {
        const cleanDate = isoDate.replace('[UTC]', '');
        const date = new Date(cleanDate);
        if (isNaN(date)) {
            console.error('Fecha inválida:', isoDate);
            return 'Fecha inválida';
        }
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return year + '-' + month + '-' + day;
    }

    // Formatear hora (HH:MM)
    function formatTime(isoDate) {
        const cleanDate = isoDate.replace('[UTC]', '');
        const date = new Date(cleanDate);
        if (isNaN(date)) {
            console.error('Fecha inválida:', isoDate);
            return 'Hora inválida';
        }
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        return hours + ':' + minutes;
    }

    // Enmascarar número de cuenta
    function maskAccountNumber(accountNumber) {
        if (!accountNumber) {
            console.warn('Número de cuenta no proporcionado para enmascarar');
            return '••••';
        }
        return '*'.repeat(accountNumber.length - 4) + accountNumber.slice(-4);
    }

    // Abrir modal de transferencia con cuenta prellenada
    async function openTransferModalWithAccount(accountNumber) {
        if (!transferModal || !accountInputView || !transferDetailsView || !loadingView || !successView || !accountNumberInput) {
            console.error('Faltan elementos para abrir modal de transferencia');
            return;
        }
        transferModal.classList.add('active');
        accountInputView.classList.remove('hidden');
        transferDetailsView.classList.add('hidden');
        loadingView.classList.add('hidden');
        successView.classList.add('hidden');
        accountNumberInput.value = accountNumber || '';
        if (pinAlert) pinAlert.classList.add('hidden');
        if (errorAlert) errorAlert.classList.add('hidden');
        if (accountNumber) {
            console.log('Validando cuenta automáticamente:', accountNumber);
            await validateAndShowTransferDetails(accountNumber);
        }
        console.log('Modal de transferencia abierto con cuenta:', accountNumber);
    }

    // Validar y mostrar detalles de la transferencia
    async function validateAndShowTransferDetails(accountNumber) {
        if (!accountNumber) {
            if (pinAlert) {
                pinAlert.classList.remove('hidden');
                pinAlert.querySelector('span').textContent = 'Ingrese un número de cuenta';
            }
            return;
        }
        if (userAccountData && accountNumber === userAccountData.numeroCuenta) {
            if (pinAlert) {
                pinAlert.classList.remove('hidden');
                pinAlert.querySelector('span').textContent = 'No se puede hacer transferencia a la misma cuenta';
            }
            return;
        }
        if (!/^\d{14}$/.test(accountNumber)) {
            if (pinAlert) {
                pinAlert.classList.remove('hidden');
                pinAlert.querySelector('span').textContent = 'El número de cuenta debe tener 14 dígitos';
            }
            return;
        }

        try {
            console.log('Buscando cuenta:', accountNumber);
            const response = await fetch('/BilleteraDigitalWeb/api/usuarios/cuenta/' + accountNumber, {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(response.status === 404 ? errorData.error : 'Error al buscar la cuenta');
            }

            recipientData = await response.json();
            console.log('Cuenta encontrada:', recipientData);

            if (!recipientData.numero_cuenta || !recipientData.nombre || !recipientData.apellido) {
                throw new Error('Datos de la cuenta incompletos');
            }

            if (accountInputView && transferDetailsView && loadingView && successView) {
                accountInputView.classList.add('hidden');
                transferDetailsView.classList.remove('hidden');
                loadingView.classList.add('hidden');
                successView.classList.add('hidden');
            }

            if (recipientName && maskedAccountNumber) {
                recipientName.textContent = recipientData.nombre + ' ' + recipientData.apellido;
                const masked = maskAccountNumber(recipientData.numero_cuenta);
                maskedAccountNumber.textContent = 'Termina en: ' + masked;
            }

            if (userAccountData && userAccountNumber && userBalance) {
                userAccountNumber.textContent = 'Cuenta: ' + userAccountData.numeroCuenta;
                const saldoValue = parseFloat(userAccountData.saldo);
                const saldoFormatted = isNaN(saldoValue) ? '0.00' : saldoValue.toFixed(2);
                userBalance.textContent = 'Saldo: S/' + saldoFormatted;
            }

            if (transferAmount) transferAmount.value = '';
            if (transferMessage) transferMessage.value = '';
            if (pinAlert) pinAlert.classList.add('hidden');
            if (errorAlert) errorAlert.classList.add('hidden');
        } catch (error) {
            console.error('Error al buscar cuenta:', error);
            if (pinAlert) {
                pinAlert.classList.remove('hidden');
                pinAlert.querySelector('span').textContent = error.message || 'Error al buscar la cuenta';
            }
        }
    }

    // Cargar historial combinado
    async function loadTransferHistory() {
        if (!userAccountData || !userAccountData.numeroCuenta) {
            console.error('No se puede cargar historial: datos de la cuenta no disponibles');
            if (errorMovimientos) {
                errorMovimientos.textContent = 'Datos de la cuenta no disponibles';
                errorMovimientos.style.display = 'block';
            }
            return;
        }
        try {
            console.log('Cargando historial combinado para cuenta:', userAccountData.numeroCuenta);
            const response = await fetch('http://localhost:8080/BilleteraDigitalWeb/api/historial/combinado', {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });
            if (!response.ok) {
                throw new Error(response.status === 401 ? 'No has iniciado sesión' : `Error al cargar historial: ${response.status} ${response.statusText}`);
            }
            transferHistory = await response.json();
            console.log('Historial combinado cargado:', transferHistory);

            if (!Array.isArray(transferHistory)) {
                throw new Error('El historial no es un arreglo');
            }

            transferHistory.forEach(movement => {
                if (!movement.id || !movement.fecha || !movement.monto || !movement.tipo) {
                    console.warn('Movimiento con datos incompletos:', movement);
                }
            });

            if (listaMovimientos) {
                listaMovimientos.innerHTML = '';
                if (transferHistory.length === 0) {
                    listaMovimientos.innerHTML = '<p class="text-gray-600">No hay movimientos recientes</p>';
                } else {
                    transferHistory.forEach(movement => {
                        const div = document.createElement('div');
                        div.className = 'flex justify-between items-center border-b pb-2';
                        const formattedDate = formatDate(movement.fecha);
                        const isRecharge = movement.tipo === 'Recarga';
                        const amountClass = isRecharge ? 'text-green-600' : 'text-red-500';
                        const amountSign = isRecharge ? '+' : '-';
                        div.innerHTML = `
                            <span class="text-gray-600">${formattedDate}</span>
                            <div class="flex items-center space-x-3">
                                <span class="${amountClass} font-semibold">${amountSign} S/${movement.monto.toFixed(2)}</span>
                                <button class="view-details text-gray-500 hover:text-[#2BB15D]" data-id="${movement.id}">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        `;
                        listaMovimientos.appendChild(div);
                    });
                }
            } else {
                console.warn('Elemento #listaMovimientos no encontrado');
            }
            if (errorMovimientos) {
                errorMovimientos.textContent = '';
                errorMovimientos.style.display = 'none';
            }
            document.querySelectorAll('.view-details').forEach(button => {
                button.addEventListener('click', () => {
                    const movementId = parseInt(button.dataset.id);
                    showTransferDetails(movementId);
                });
            });
        } catch (error) {
            console.error('Error en loadTransferHistory:', error);
            if (error.message === 'No has iniciado sesión') {
                window.location.href = 'login.jsp';
            } else if (errorMovimientos) {
                errorMovimientos.textContent = error.message || 'Error al cargar el historial';
                errorMovimientos.style.display = 'block';
            }
        }
    }

    // Mostrar detalles de la transacción
    function showTransferDetails(movementId) {
        const movement = transferHistory.find(t => t.id === movementId);
        if (!movement) {
            console.error('Movimiento no encontrado:', movementId);
            return;
        }
        currentTransferId = movementId;
        const isRecharge = movement.tipo === 'Recarga';
        if (historyModal && historyDate && historyTime && historyAmount && historyType && historyOrigin && historyDestination && historyMessage && makeAnotherTransferButton) {
            historyModal.classList.add('active');
            historyDate.textContent = formatDate(movement.fecha);
            historyTime.textContent = formatTime(movement.fecha);
            const amountClass = isRecharge ? 'text-green-600' : 'text-red-500';
            const amountSign = isRecharge ? '+' : '-';
            historyAmount.innerHTML = `<span class="${amountClass}">${amountSign} S/${movement.monto.toFixed(2)}</span>`;
            historyType.textContent = movement.tipo;
            historyOrigin.textContent = movement.origen || (movement.cuenta_origen ? maskAccountNumber(movement.cuenta_origen) : 'N/A');
            historyDestination.textContent = movement.cuenta_destino ? maskAccountNumber(movement.cuenta_destino) : 'N/A';
            historyMessage.textContent = movement.mensaje || 'Ninguno';
            makeAnotherTransferButton.classList.toggle('hidden', isRecharge);
            console.log('Mostrando detalles de movimiento:', movement);
        } else {
            console.error('Faltan elementos para mostrar detalles de movimiento');
        }
    }

 // Cargar datos del usuario y la cuenta
async function loadUserData() {
    console.log('Cargando datos del usuario...');
    try {
        const userResponse = await fetch('/BilleteraDigitalWeb/api/usuarios/datos', {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        });
        if (!userResponse.ok) {
            throw new Error(userResponse.status === 401 ? 'No has iniciado sesión' : `Error al cargar datos del usuario: ${userResponse.status} ${userResponse.statusText}`);
        }
        const userData = await userResponse.json();
        console.log('Datos del usuario recibidos:', userData);

        const accountResponse = await fetch('/BilleteraDigitalWeb/api/usuarios/cuenta', {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        });
        if (!accountResponse.ok) {
            throw new Error(accountResponse.status === 401 ? 'No has iniciado sesión' : `Error al cargar datos de la cuenta: ${accountResponse.status} ${userResponse.statusText}`);
        }
        const accountData = await accountResponse.json();
        console.log('Datos de la cuenta recibidos:', accountData);

        if (!userData.nombre || !userData.apellido || !userData.correo) {
            throw new Error('Datos del usuario incompletos: falta nombre, apellido o correo');
        }
        if (!accountData.saldo && accountData.saldo !== 0 || !accountData.numeroCuenta) {
            throw new Error('Datos de la cuenta incompletos: falta saldo o número de cuenta');
        }
        if (!userData.idCliente) {
            console.warn('idCliente no encontrado en datos del usuario. Las recargas no funcionarán.');
        }

        userAccountData = {
            idCliente: userData.idCliente || null,
            numeroCuenta: accountData.numeroCuenta,
            saldo: accountData.saldo,
            nombre: userData.nombre + ' ' + userData.apellido,
            correo: userData.correo
        };
        window.userAccountData = userAccountData;
        console.log('userAccountData establecido:', userAccountData);

        if (nombreUsuario) {
            nombreUsuario.textContent = userAccountData.nombre;
            console.log('Nombre actualizado en UI:', nombreUsuario.textContent);
        }
        if (correoUsuario) {
            correoUsuario.textContent = userAccountData.correo;
            console.log('Correo actualizado en UI:', correoUsuario.textContent);
        }
        if (bienvenida) {
            bienvenida.textContent = 'Bienvenido, ' + userData.nombre + '!';
            console.log('Bienvenida actualizada en UI:', bienvenida.textContent);
        }
        if (saldo) {
            const saldoValue = parseFloat(accountData.saldo);
            const saldoFormatted = isNaN(saldoValue) ? '0.00' : saldoValue.toFixed(2);
            saldo.dataset.saldo = 'S/' + saldoFormatted;
            saldo.textContent = '••••••';
            console.log('Saldo almacenado en UI:', saldo.dataset.saldo);
        }
        if (accountNumberDisplay) {
            const masked = maskAccountNumber(accountData.numeroCuenta);
            accountNumberDisplay.dataset.numeroCuenta = accountData.numeroCuenta;
            accountNumberDisplay.textContent = 'Cuenta: ' + masked;
            console.log('Número de cuenta almacenado en UI:', accountNumberDisplay.dataset.numeroCuenta);
        }
        if (errorSaldo) {
            errorSaldo.textContent = '';
            errorSaldo.style.display = 'none';
        }

        await loadTransferHistory();
    } catch (error) {
        console.error('Error en loadUserData:', error);
        if (error.message === 'No has iniciado sesión') {
            console.log('Redirigiendo a login.jsp debido a falta de sesión');
            window.location.href = 'login.jsp';
        } else if (errorSaldo) {
            errorSaldo.textContent = error.message || 'Error al cargar los datos';
            errorSaldo.style.display = 'block';
        }
    }
}

// Función para enmascarar el número de cuenta
function maskAccountNumber(accountNumber) {
    if (!accountNumber || accountNumber.length < 4) return '****';
    return '**** **** **** ' + accountNumber.slice(-4);
}

// Función para mostrar el modal con el código QR
function showQRModal() {
    const qrModal = document.getElementById('qrModal');
    const qrImage = document.getElementById('qrImage');
    const qrAccountNumber = document.getElementById('qrAccountNumber');
    const qrErrorAlert = document.getElementById('qrErrorAlert');

    if (!window.userAccountData || !window.userAccountData.numeroCuenta) {
        qrErrorAlert.textContent = 'Error: No se encontró el número de cuenta';
        qrErrorAlert.classList.remove('hidden');
        qrImage.classList.add('hidden');
        qrAccountNumber.textContent = '';
        qrModal.classList.add('active');
        return;
    }

    const accountNumber = window.userAccountData.numeroCuenta;
    const qrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${encodeURIComponent(accountNumber)}`;

    qrImage.src = qrUrl;
    qrImage.classList.remove('hidden');
    qrAccountNumber.textContent = `Cuenta: ${accountNumber}`;
    qrErrorAlert.classList.add('hidden');
    qrModal.classList.add('active');
}

// Función para cerrar el modal de QR
function closeQRModal() {
    const qrModal = document.getElementById('qrModal');
    qrModal.classList.remove('active');
}

// Inicializar eventos al cargar el DOM
document.addEventListener('DOMContentLoaded', function () {
    loadUserData();

    // Evento para el botón "Mostrar mi QR"
    const showQRButton = document.getElementById('showQRButton');
    if (showQRButton) {
        showQRButton.addEventListener('click', showQRModal);
    }

    // Eventos para los botones de cerrar el modal de QR
    const qrCloseButton = document.getElementById('qrCloseButton');
    const qrCloseButtonTop = document.getElementById('qrCloseButtonTop');
    if (qrCloseButton) {
        qrCloseButton.addEventListener('click', closeQRModal);
    }
    if (qrCloseButtonTop) {
        qrCloseButtonTop.addEventListener('click', closeQRModal);
    }
});
    // Manejar logout
    if (logoutButton) {
        logoutButton.addEventListener('click', async () => {
            try {
                console.log('Cerrando sesión...');
                const response = await fetch('/BilleteraDigitalWeb/api/usuarios/logout', {
                    method: 'POST',
                    headers: { 'Accept': 'application/json' }
                });
                if (response.ok) {
                    console.log('Logout exitoso');
                    window.location.href = 'login.jsp';
                } else {
                    throw new Error(`Error al cerrar sesión: ${response.status} ${response.statusText}`);
                }
            } catch (error) {
                console.error('Error en logout:', error);
                if (errorSaldo) {
                    errorSaldo.textContent = 'Error al cerrar sesión';
                    errorSaldo.style.display = 'block';
                }
            }
        });
    }

    // Funcionalidad de la sidebar
    function toggleSidebar() {
        isOpen = !isOpen;
        if (sidebar && overlay) {
            sidebar.classList.toggle('-translate-x-full', !isOpen);
            overlay.classList.toggle('opacity-50', isOpen);
            overlay.classList.toggle('z-30', isOpen);
            console.log('Sidebar abierto:', isOpen);
        }
    }

    if (menuButton) {
        menuButton.addEventListener('click', toggleSidebar);
    }
    if (overlay) {
        overlay.addEventListener('click', () => {
            if (isOpen) toggleSidebar();
        });
    }

    if (configButton) {
        configButton.addEventListener('click', () => {
            isConfigOpen = !isConfigOpen;
            if (configMenu) {
                configMenu.classList.toggle('hidden', !isConfigOpen);
                console.log('Configuración abierta:', isConfigOpen);
            }
        });
    }

    window.addEventListener('resize', () => {
        if (window.innerWidth >= 768) {
            isOpen = false;
            if (sidebar && overlay) {
                sidebar.classList.remove('-translate-x-full');
                overlay.classList.remove('opacity-50', 'z-30');
            }
        } else if (!isOpen && sidebar) {
            sidebar.classList.add('-translate-x-full');
        }
    });

    // Alternar visibilidad del saldo y número de cuenta
    window.toggleSaldo = function() {
        console.log('Ejecutando toggleSaldo');
        if (!saldo || !accountNumberDisplay || !document.getElementById('iconoOjo') || !iconoOjoCuenta) {
            console.error('Faltan elementos para toggleSaldo');
            return;
        }
        isSaldoVisible = !isSaldoVisible;
        saldo.textContent = isSaldoVisible ? saldo.dataset.saldo : '••••••';
        accountNumberDisplay.textContent = isSaldoVisible ? 'Cuenta: ' + accountNumberDisplay.dataset.numeroCuenta : 'Cuenta: ' + maskAccountNumber(accountNumberDisplay.dataset.numeroCuenta);
        const iconoOjo = document.getElementById('iconoOjo');
        iconoOjo.classList.toggle('fa-eye', isSaldoVisible);
        iconoOjo.classList.toggle('fa-eye-slash', !isSaldoVisible);
        iconoOjoCuenta.classList.toggle('fa-eye', isSaldoVisible);
        iconoOjoCuenta.classList.toggle('fa-eye-slash', !isSaldoVisible);
        console.log('Saldo visible:', isSaldoVisible);
    };

    // Alternar visibilidad de movimientos
    window.toggleMovimientos = function() {
        console.log('Ejecutando toggleMovimientos');
        if (listaMovimientos) {
            listaMovimientos.classList.toggle('hidden');
        } else {
            console.warn('Elemento #listaMovimientos no encontrado');
        }
    };

    // Funcionalidad del modal de transferencia
    function openTransferModal() {
        if (transferModal && accountInputView && transferDetailsView && loadingView && successView) {
            transferModal.classList.add('active');
            accountInputView.classList.remove('hidden');
            transferDetailsView.classList.add('hidden');
            loadingView.classList.add('hidden');
            successView.classList.add('hidden');
            if (accountNumberInput) {
                accountNumberInput.value = '';
                accountNumberInput.focus();
            }
            if (pinAlert) pinAlert.classList.add('hidden');
            if (errorAlert) errorAlert.classList.add('hidden');
            console.log('Modal de transferencia abierto');
        } else {
            console.error('Faltan elementos para abrir modal de transferencia');
        }
    }

    function closeTransferModal() {
        if (transferModal) {
            transferModal.classList.remove('active');
            recipientData = null;
            console.log('Modal de transferencia cerrado');
        }
    }

    if (transferButton) {
        transferButton.addEventListener('click', openTransferModal);
    }
    if (closeButton) {
        closeButton.addEventListener('click', closeTransferModal);
    }
    if (cancelButton) {
        cancelButton.addEventListener('click', closeTransferModal);
    }
    if (cancelTransferButton) {
        cancelTransferButton.addEventListener('click', closeTransferModal);
    }
    if (closeSuccessButton) {
        closeSuccessButton.addEventListener('click', closeTransferModal);
    }
    if (backButton) {
        backButton.addEventListener('click', () => {
            if (accountInputView && transferDetailsView && loadingView && successView) {
                accountInputView.classList.remove('hidden');
                transferDetailsView.classList.add('hidden');
                loadingView.classList.add('hidden');
                successView.classList.add('hidden');
                if (accountNumberInput) {
                    accountNumberInput.value = '';
                    accountNumberInput.focus();
                }
                if (errorAlert) errorAlert.classList.add('hidden');
                console.log('Regresando a ingreso de número de cuenta');
            }
        });
    }

    // Funcionalidad del modal de historial
    function closeHistoryModal() {
        if (historyModal) {
            historyModal.classList.remove('active');
            currentTransferId = null;
            console.log('Modal de historial cerrado');
        }
    }

    if (closeHistoryButton) {
        closeHistoryButton.addEventListener('click', closeHistoryModal);
    }
    if (closeHistoryButtonBottom) {
        closeHistoryButtonBottom.addEventListener('click', closeHistoryModal);
    }
    if (makeAnotherTransferButton) {
        makeAnotherTransferButton.addEventListener('click', async () => {
            if (!currentTransferId) {
                console.error('No se ha seleccionado ninguna transacción');
                return;
            }
            const movement = transferHistory.find(t => t.id === currentTransferId);
            if (!movement) {
                console.error('Transacción no encontrada:', currentTransferId);
                return;
            }
            if (movement.tipo === 'Recarga') {
                console.warn('No se puede hacer otra transferencia desde una recarga');
                return;
            }
            closeHistoryModal();
            await openTransferModalWithAccount(movement.cuenta_destino);
        });
    }

    // Validar y buscar cuenta
    if (nextButton && accountNumberInput) {
        nextButton.addEventListener('click', async () => {
            const accountNumber = accountNumberInput.value.trim();
            await validateAndShowTransferDetails(accountNumber);
        });
    }

    // Realizar transferencia
    if (confirmTransferButton) {
        confirmTransferButton.addEventListener('click', async () => {
            const amount = parseFloat(transferAmount.value);
            const message = transferMessage.value.trim();

            if (isNaN(amount) || amount <= 0) {
                if (errorAlert) {
                    errorAlert.classList.remove('hidden');
                    errorAlert.querySelector('span').textContent = 'El monto debe ser mayor a 0';
                }
                return;
            }
            if (userAccountData && amount > userAccountData.saldo) {
                if (errorAlert) {
                    errorAlert.classList.remove('hidden');
                    errorAlert.querySelector('span').textContent = 'No se puede transferir por falta de monto';
                }
                return;
            }

            if (accountInputView && transferDetailsView && loadingView && successView) {
                accountInputView.classList.add('hidden');
                transferDetailsView.classList.add('hidden');
                loadingView.classList.remove('hidden');
                successView.classList.add('hidden');
            }

            try {
                console.log('Realizando transferencia...');
                const url = '/BilleteraDigitalWeb/api/transferencias?origen=' + encodeURIComponent(userAccountData.numeroCuenta) + '&destino=' + encodeURIComponent(recipientData.numero_cuenta) + '&monto=' + encodeURIComponent(amount.toFixed(2)) + '&mensaje=' + encodeURIComponent(message);
                const response = await fetch(url, {
                    method: 'POST',
                    headers: { 'Accept': 'application/json' }
                });

                if (!response.ok) {
                    const errorData = await response.json();
                    throw new Error(errorData.error || 'Error al realizar la transferencia');
                }

                const accountResponse = await fetch('/BilleteraDigitalWeb/api/usuarios/cuenta', {
                    method: 'GET',
                    headers: { 'Accept': 'application/json' }
                });
                if (!accountResponse.ok) {
                    throw new Error('Error al actualizar el saldo');
                }
                const accountData = await accountResponse.json();
                console.log('Cuenta actualizada:', accountData);

                if (!accountData.saldo && accountData.saldo !== 0 || !accountData.numeroCuenta) {
                    throw new Error('Datos de la cuenta incompletos');
                }

                userAccountData.saldo = accountData.saldo;
                window.userAccountData = userAccountData;
                updateUserBalance(accountData.saldo);

                if (accountInputView && transferDetailsView && loadingView && successView) {
                    accountInputView.classList.add('hidden');
                    transferDetailsView.classList.add('hidden');
                    loadingView.classList.add('hidden');
                    successView.classList.remove('hidden');
                }

                if (transferSummary) {
                    const summary = 'Has transferido S/' + amount.toFixed(2) + ' a ' + recipientData.nombre + ' ' + recipientData.apellido + ' (' + recipientData.numero_cuenta + '). Mensaje: ' + (message || 'Ninguno');
                    transferSummary.textContent = summary;
                    console.log('Resumen de transferencia:', summary);
                }

                await loadTransferHistory();
            } catch (error) {
                console.error('Error al realizar transferencia:', error);
                if (accountInputView && transferDetailsView && loadingView && successView) {
                    accountInputView.classList.add('hidden');
                    transferDetailsView.classList.remove('hidden');
                    loadingView.classList.add('hidden');
                    successView.classList.add('hidden');
                }
                if (errorAlert) {
                    errorAlert.classList.remove('hidden');
                    errorAlert.querySelector('span').textContent = error.message || 'Error al realizar la transferencia';
                }
            }
        });
    }

    // Funcionalidad del modal de recarga
    function openRechargeModal() {
        if (rechargeModal && rechargeInputView && rechargeLoadingView && rechargeSuccessView && rechargeAmount) {
            rechargeModal.classList.add('active');
            rechargeInputView.classList.remove('hidden');
            rechargeLoadingView.classList.add('hidden');
            rechargeSuccessView.classList.add('hidden');
            rechargeAmount.value = '';
            rechargeAmount.focus();
            if (rechargeErrorAlert) rechargeErrorAlert.classList.add('hidden');
            const defaultMethod = document.querySelector('input[name="paymentMethod"][value="1"]');
            if (defaultMethod) {
                defaultMethod.checked = true;
                console.log('Método de pago por defecto seleccionado: Tarjeta Izipay');
            } else {
                console.warn('No se encontró input[name="paymentMethod"][value="1"]');
            }
            console.log('Modal de recarga abierto');
        } else {
            console.error('Faltan elementos para abrir modal de recarga. Verifica #rechargeModal y sus hijos en panelUsuario.jsp');
        }
    }

    function closeRechargeModal() {
        if (rechargeModal) {
            rechargeModal.classList.remove('active');
            console.log('Modal de recarga cerrado');
        }
    }

    function getSelectedPaymentMethod() {
        const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');
        if (!selectedMethod) {
            console.warn('No se seleccionó ningún método de pago');
            return null;
        }
        return parseInt(selectedMethod.value);
    }

    async function performRecharge() {
        const amount = parseFloat(rechargeAmount.value);
        const method = getSelectedPaymentMethod();

        if (isNaN(amount) || amount <= 0) {
            if (rechargeErrorAlert) {
                rechargeErrorAlert.classList.remove('hidden');
                rechargeErrorAlert.querySelector('span').textContent = 'El monto debe ser mayor a 0';
            }
            return;
        }

        if (!method || ![1, 2].includes(method)) {
            if (rechargeErrorAlert) {
                rechargeErrorAlert.classList.remove('hidden');
                rechargeErrorAlert.querySelector('span').textContent = 'Seleccione un método de pago';
            }
            return;
        }

        if (rechargeInputView && rechargeLoadingView && rechargeSuccessView) {
            rechargeInputView.classList.add('hidden');
            rechargeLoadingView.classList.remove('hidden');
            rechargeSuccessView.classList.add('hidden');
        }

        try {
            console.log('Realizando recarga con:', { amount, cuenta: userAccountData.idCliente, method });
            const url = `http://localhost:8080/BilleteraDigitalWeb/api/recargas?monto=${encodeURIComponent(amount.toFixed(2))}&metodo=${encodeURIComponent(method)}`;
            const response = await fetch(url, {
                method: 'POST',
                headers: { 'Accept': 'application/json' }
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || `Error al realizar la recarga: ${response.status} ${response.statusText}`);
            }

            const accountResponse = await fetch('/BilleteraDigitalWeb/api/usuarios/cuenta', {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });
            if (!accountResponse.ok) {
                throw new Error('Error al actualizar el saldo');
            }
            const accountData = await accountResponse.json();
            console.log('Cuenta actualizada tras recarga:', accountData);

            if (!accountData.saldo && accountData.saldo !== 0) {
                throw new Error('Datos de la cuenta incompletos');
            }

            updateUserBalance(accountData.saldo);

            if (rechargeInputView && rechargeLoadingView && rechargeSuccessView) {
                rechargeInputView.classList.add('hidden');
                rechargeLoadingView.classList.add('hidden');
                rechargeSuccessView.classList.remove('hidden');
            }

            if (rechargeSummary) {
                const methodText = method === 1 ? 'Tarjeta Izipay' : 'Yape';
                const summary = `Has recargado S/${amount.toFixed(2)} mediante ${methodText}.`;
                rechargeSummary.textContent = summary;
                console.log('Resumen de recarga:', summary);
            }

            await loadTransferHistory();
        } catch (error) {
            console.error('Error al realizar recarga:', error);
            if (rechargeInputView && rechargeLoadingView && rechargeSuccessView) {
                rechargeInputView.classList.remove('hidden');
                rechargeLoadingView.classList.add('hidden');
                rechargeSuccessView.classList.add('hidden');
            }
            if (rechargeErrorAlert) {
                rechargeErrorAlert.classList.remove('hidden');
                rechargeErrorAlert.querySelector('span').textContent = error.message || 'Error al realizar la recarga';
            }
        }
    }

    if (rechargeButton) {
        rechargeButton.addEventListener('click', openRechargeModal);
    }
    if (rechargeCloseButton) {
        rechargeCloseButton.addEventListener('click', closeRechargeModal);
    }
    if (rechargeCancelButton) {
        rechargeCancelButton.addEventListener('click', closeRechargeModal);
    }
    if (rechargeCloseSuccessButton) {
        rechargeCloseSuccessButton.addEventListener('click', closeRechargeModal);
    }
    if (rechargeConfirmButton) {
        rechargeConfirmButton.addEventListener('click', performRecharge);
    }

    // Iniciar carga de datos
    loadUserData();
});
