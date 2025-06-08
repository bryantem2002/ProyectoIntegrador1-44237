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
        if (idx < 0) idx = total - 1;
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

document.addEventListener('DOMContentLoaded', function () {
    const showMyQRButton = document.getElementById('showMyQRButton');
    const qrModal = document.getElementById('qrModal');
    const closeQRButton = document.getElementById('closeQRButton');
    const qrImage = document.getElementById('qrImage');
    const scanQRButton = document.getElementById('scanQRButton');
    const scanQRModal = document.getElementById('scanQRModal');
    const closeScanQRButton = document.getElementById('closeScanQRButton');
    const qrVideo = document.getElementById('qrVideo');
    const qrResult = document.getElementById('qrResult');
    const qrFileInput = document.getElementById('qrFileInput');
    const scanQRFileButton = document.getElementById('scanQRFileButton');
    const qrScanView = document.getElementById('qrScanView');
    const qrTransferModal = document.getElementById('qrTransferModal');
    const qrCloseTransferButton = document.getElementById('qrCloseTransferButton');
    const qrCancelTransferButton = document.getElementById('qrCancelTransferButton');
    const qrConfirmTransferButton = document.getElementById('qrConfirmTransferButton');
    const qrRecipientName = document.getElementById('qrRecipientName');
    const qrMaskedAccountNumber = document.getElementById('qrMaskedAccountNumber');
    const qrUserAccountNumber = document.getElementById('qrUserAccountNumber');
    const qrUserBalance = document.getElementById('qrUserBalance');
    const qrTransferAmount = document.getElementById('qrTransferAmount');
    const qrTransferMessage = document.getElementById('qrTransferMessage');
    const qrErrorAlert = document.getElementById('qrErrorAlert');
    const qrErrorMessage = document.getElementById('qrErrorMessage');
    const qrErrorAlertTransfer = document.getElementById('qrErrorAlertTransfer');
    const qrErrorMessageTransfer = document.getElementById('qrErrorMessageTransfer');
    const qrLoadingView = document.getElementById('qrLoadingView');
    const qrSuccessView = document.getElementById('qrSuccessView');
    const qrTransferDetailsView = document.getElementById('qrTransferDetailsView');
    const qrCloseSuccessButton = document.getElementById('qrCloseSuccessButton');
    const qrTransferSummary = document.getElementById('qrTransferSummary');
    const listaMovimientos = document.getElementById('listaMovimientos');
    const errorMovimientos = document.getElementById('errorMovimientos');
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
    const currentUserAccount = '<%= numeroCuenta %>';

    let recipientData = null;

    // Verificar elementos del DOM
    const elements = {
        showMyQRButton, qrModal, closeQRButton, qrImage, scanQRButton, scanQRModal, closeScanQRButton, qrVideo,
        qrResult, qrFileInput, scanQRFileButton, qrScanView, qrTransferModal, qrCloseTransferButton,
        qrCancelTransferButton, qrConfirmTransferButton, qrRecipientName, qrMaskedAccountNumber,
        qrUserAccountNumber, qrUserBalance, qrTransferAmount, qrTransferMessage, qrErrorAlert,
        qrErrorMessage, qrErrorAlertTransfer, qrErrorMessageTransfer, qrLoadingView, qrSuccessView,
        qrTransferDetailsView, qrCloseSuccessButton, qrTransferSummary, listaMovimientos, errorMovimientos,
        historyModal, closeHistoryButton, closeHistoryButtonBottom, makeAnotherTransferButton,
        historyDate, historyTime, historyAmount, historyType, historyOrigin, historyDestination, historyMessage
    };
    Object.entries(elements).forEach(([key, element]) => {
        if (!element) {
            console.warn(`Elemento "${key}" no encontrado en el DOM.`);
        }
    });

    // Función para enmascarar número de cuenta
    function maskAccountNumber(accountNumber) {
        if (!accountNumber || accountNumber.length < 4) return '****';
        return '*'.repeat(accountNumber.length - 4) + accountNumber.slice(-4);
    }

    // Limpiar contenido del modal
    function clearModalContent() {
        qrResult.textContent = '';
        qrFileInput.value = '';
        qrErrorAlert.classList.add('hidden');
        qrScanView.classList.remove('hidden');
        qrTransferModal.classList.remove('active');
        qrTransferAmount.value = '';
        qrTransferMessage.value = '';
        qrErrorAlertTransfer.classList.add('hidden');
        qrTransferDetailsView.classList.remove('hidden');
        qrLoadingView.classList.add('hidden');
        qrSuccessView.classList.add('hidden');
        recipientData = null;
    }

    // Función para cargar el historial de transferencias
    window.loadTransferHistory = async function () {
        try {
            const response = await fetch('http://localhost:8080/BilleteraDigitalWeb/api/historial/combinado', {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });
            if (!response.ok) {
                throw new Error('Error al cargar el historial de transacciones');
            }
            const historyData = await response.json();
            console.log('Historial cargado:', historyData);


        } catch (error) {
            console.error('Error al cargar historial:', error);
            errorMovimientos.textContent = error.message || 'Error al cargar el historial';
            errorMovimientos.classList.remove('hidden');
            listaMovimientos.classList.add('hidden');
        }
    };

    // Función para mostrar detalles de la transacción en el modal
    function showTransactionDetails(transaction) {
        const date = new Date(transaction.fecha);
        historyDate.textContent = date.toLocaleDateString('es-PE', { day: '2-digit', month: '2-digit', year: 'numeric' });
        historyTime.textContent = date.toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' });
        historyAmount.textContent = `S/${transaction.monto.toFixed(2)}`;
        historyType.textContent = transaction.tipo === 'Egreso' ? 'Transferencia enviada' : transaction.tipo === 'Recarga' ? 'Recarga' : transaction.tipo;
        historyOrigin.textContent = transaction.cuenta_origen ? maskAccountNumber(transaction.cuenta_origen) : 'N/A';
        historyDestination.textContent = transaction.cuenta_destino ? maskAccountNumber(transaction.cuenta_destino) : 'N/A';
        historyMessage.textContent = transaction.mensaje || 'Ninguno';

        historyModal.classList.add('active');
        setTimeout(() => {
            document.querySelector('#historyModal .modal-content').classList.add('active');
        }, 10);
    }

    // Cerrar modal de historial
    [closeHistoryButton, closeHistoryButtonBottom].forEach(button => {
        button.addEventListener('click', () => {
            document.querySelector('#historyModal .modal-content').classList.remove('active');
            setTimeout(() => {
                historyModal.classList.remove('active');
            }, 300);
        });
    });

    // Hacer otra transferencia
    makeAnotherTransferButton.addEventListener('click', () => {
        document.querySelector('#historyModal .modal-content').classList.remove('active');
        setTimeout(() => {
            historyModal.classList.remove('active');
            qrTransferModal.classList.add('active');
            document.querySelector('#qrTransferModal .modal-content').classList.add('active');
            clearModalContent();
        }, 300);
    });

    // Mostrar código QR del usuario
    showMyQRButton.addEventListener('click', function () {
        if (!window.userAccountData || !window.userAccountData.numeroCuenta) {
            console.error('No se encontró el número de cuenta del usuario');
            return;
        }
        const qrCodeUrl = `https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${encodeURIComponent(window.userAccountData.numeroCuenta)}`;
        qrImage.src = qrCodeUrl;
        qrModal.classList.add('active');
        setTimeout(() => {
            document.querySelector('#qrModal .modal-content').classList.add('active');
        }, 10);
    });

    // Cerrar modal de QR
    closeQRButton.addEventListener('click', function () {
        document.querySelector('#qrModal .modal-content').classList.remove('active');
        setTimeout(() => {
            qrModal.classList.remove('active');
        }, 300);
    });

    // Abrir modal de escaneo QR
    scanQRButton.addEventListener('click', function () {
        clearModalContent();
        scanQRModal.classList.add('active');
        setTimeout(() => {
            document.querySelector('#scanQRModal .modal-content').classList.add('active');
            startQRScanner();
        }, 10);
    });

    // Cerrar modal de escaneo QR
    closeScanQRButton.addEventListener('click', function () {
        document.querySelector('#scanQRModal .modal-content').classList.remove('active');
        setTimeout(() => {
            scanQRModal.classList.remove('active');
            stopQRScanner();
            clearModalContent();
        }, 300);
    });

    // Cerrar modal de transferencia QR
    qrCloseTransferButton.addEventListener('click', function () {
        document.querySelector('#qrTransferModal .modal-content').classList.remove('active');
        setTimeout(() => {
            qrTransferModal.classList.remove('active');
            clearModalContent();
        }, 300);
    });

    // Cancelar transferencia QR y volver a escanear
    qrCancelTransferButton.addEventListener('click', function () {
        document.querySelector('#qrTransferModal .modal-content').classList.remove('active');
        setTimeout(() => {
            qrTransferModal.classList.remove('active');
            scanQRModal.classList.add('active');
            document.querySelector('#scanQRModal .modal-content').classList.add('active');
            startQRScanner();
            clearModalContent();
        }, 300);
    });

    // Confirmar transferencia QR
    qrConfirmTransferButton.addEventListener('click', async () => {
        if (!recipientData || !recipientData.numero_cuenta) {
            qrErrorMessageTransfer.textContent = 'No se ha seleccionado un destinatario válido';
            qrErrorAlertTransfer.classList.remove('hidden');
            return;
        }

        const amount = parseFloat(qrTransferAmount.value);
        const message = qrTransferMessage.value.trim();

        if (isNaN(amount) || amount <= 0) {
            qrErrorMessageTransfer.textContent = 'El monto debe ser mayor a 0';
            qrErrorAlertTransfer.classList.remove('hidden');
            return;
        }
        if (window.userAccountData && amount > window.userAccountData.saldo) {
            qrErrorMessageTransfer.textContent = 'No se puede transferir por falta de monto';
            qrErrorAlertTransfer.classList.remove('hidden');
            return;
        }

        qrTransferDetailsView.classList.add('hidden');
        qrLoadingView.classList.remove('hidden');
        qrSuccessView.classList.add('hidden');

        try {
            console.log('Realizando transferencia QR...');
            const transferUrl = '/BilleteraDigitalWeb/api/transferencias?origen=' + encodeURIComponent(window.userAccountData.numeroCuenta) + '&destino=' + encodeURIComponent(recipientData.numero_cuenta) + '&monto=' + encodeURIComponent(amount.toFixed(2)) + '&mensaje=' + encodeURIComponent(message);
            const transferResponse = await fetch(transferUrl, {
                method: 'POST',
                headers: { 'Accept': 'application/json' }
            });

            if (!transferResponse.ok) {
                const errorData = await transferResponse.json();
                throw new Error(errorData.error || 'Error al realizar la transferencia');
            }

            // Actualizar datos de la cuenta del usuario
            const accountResponse = await fetch('http://localhost:8080/BilleteraDigitalWeb/api/usuarios/cuenta', {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });
            if (!accountResponse.ok) {
                throw new Error('Error al actualizar los datos de la cuenta');
            }
            const accountData = await accountResponse.json();
            console.log('Cuenta actualizada:', accountData);

            if (!accountData.saldo && accountData.saldo !== 0 || !accountData.numeroCuenta || !accountData.idUsuario) {
                throw new Error('Datos de la cuenta incompletos');
            }

            // Actualizar datos globales
            window.userAccountData = {
                numeroCuenta: accountData.numeroCuenta,
                saldo: accountData.saldo,
                idUsuario: accountData.idUsuario,
                idCuenta: accountData.idCuenta,
                idEstado: accountData.idEstado,
                fechaCreacion: accountData.fechaCreacion
            };
            window.updateUserBalance(accountData.saldo);

            // Actualizar historial combinado
            await window.loadTransferHistory();

            qrTransferDetailsView.classList.add('hidden');
            qrLoadingView.classList.add('hidden');
            qrSuccessView.classList.remove('hidden');

            const summary = `Has transferido S/${amount.toFixed(2)} a ${recipientData.nombre} ${recipientData.apellido} (${recipientData.numero_cuenta}). Mensaje: ${message || 'Ninguno'}`;
            qrTransferSummary.textContent = summary;
            console.log('Resumen de transferencia:', summary);
        } catch (error) {
            console.error('Error al realizar transferencia QR:', error);
            qrTransferDetailsView.classList.remove('hidden');
            qrLoadingView.classList.add('hidden');
            qrSuccessView.classList.add('hidden');
            qrErrorMessageTransfer.textContent = error.message || 'Error al realizar la transferencia';
            qrErrorAlertTransfer.classList.remove('hidden');
        }
    });

    // Cerrar modal de éxito
    qrCloseSuccessButton.addEventListener('click', function () {
        document.querySelector('#qrTransferModal .modal-content').classList.remove('active');
        setTimeout(() => {
            qrTransferModal.classList.remove('active');
            clearModalContent();
        }, 300);
    });

    // Iniciar escáner QR
    function startQRScanner() {
        navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
            .then(function(stream) {
                qrVideo.srcObject = stream;
                qrVideo.play();
                requestAnimationFrame(scanQR);
            })
            .catch(function(error) {
                console.error('Error al acceder a la cámara:', error);
                qrErrorMessage.textContent = 'Error al acceder a la cámara: ' + error.message;
                qrErrorAlert.classList.remove('hidden');
                qrScanView.classList.remove('hidden');
            });
    }

    // Detener escáner QR
    function stopQRScanner() {
        const stream = qrVideo.srcObject;
        if (stream) {
            const tracks = stream.getTracks();
            tracks.forEach(track => track.stop());
            qrVideo.srcObject = null;
        }
    }

    // Escanear código QR
    function scanQR() {
        if (!qrVideo.videoWidth || !qrVideo.videoHeight) {
            requestAnimationFrame(scanQR);
            return;
        }

        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        canvas.width = qrVideo.videoWidth;
        canvas.height = qrVideo.videoHeight;
        context.drawImage(qrVideo, 0, 0, canvas.width, canvas.height);
        const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
        const code = jsQR(imageData.data, imageData.width, imageData.height, {
            inversionAttempts: 'dontInvert',
        });

        if (code && code.data) {
            console.log('QR Code Data:', code.data);
            qrResult.textContent = 'Número de cuenta encontrado: ' + code.data;
            stopQRScanner();
            fetchAccountData(code.data.trim());
        } else {
            requestAnimationFrame(scanQR);
        }
    }

    // Escanear QR desde archivo
    scanQRFileButton.addEventListener('click', function () {
        const file = qrFileInput.files[0];
        if (!file) {
            qrErrorMessage.textContent = 'Por favor, selecciona un archivo primero.';
            qrErrorAlert.classList.remove('hidden');
            return;
        }

        const reader = new FileReader();
        reader.onload = function(event) {
            const img = new Image();
            img.onload = function() {
                const canvas = document.createElement('canvas');
                const context = canvas.getContext('2d');
                canvas.width = img.width;
                canvas.height = img.height;
                context.drawImage(img, 0, 0, img.width, img.height);
                const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
                const code = jsQR(imageData.data, imageData.width, imageData.height, {
                    inversionAttempts: 'dontInvert',
                });

                if (code && code.data) {
                    console.log('QR Code Data from file:', code.data);
                    qrResult.textContent = 'Número de cuenta encontrado: ' + code.data;
                    fetchAccountData(code.data.trim());
                } else {
                    qrErrorMessage.textContent = 'No se encontró ningún código QR en la imagen.';
                    qrErrorAlert.classList.remove('hidden');
                    qrScanView.classList.remove('hidden');
                }
            };
            img.onerror = function() {
                qrErrorMessage.textContent = 'Error al cargar la imagen.';
                qrErrorAlert.classList.remove('hidden');
                qrScanView.classList.remove('hidden');
            };
            img.src = event.target.result;
        };
        reader.onerror = function() {
            qrErrorMessage.textContent = 'Error al leer el archivo.';
            qrErrorAlert.classList.remove('hidden');
            qrScanView.classList.remove('hidden');
        };
        reader.readAsDataURL(file);
    });

    // Obtener datos de la cuenta escaneada
    async function fetchAccountData(accountNumber) {
        if (!accountNumber) {
            qrErrorMessage.textContent = 'Número de cuenta inválido.';
            qrErrorAlert.classList.remove('hidden');
            qrScanView.classList.remove('hidden');
            return;
        }

        if (accountNumber === currentUserAccount) {
            qrErrorMessage.textContent = 'No se puede hacer transferencia a tu propia cuenta.';
            qrErrorAlert.classList.remove('hidden');
            qrScanView.classList.remove('hidden');
            return;
        }

        if (!/^\d{14}$/.test(accountNumber)) {
            qrErrorMessage.textContent = 'El número de cuenta debe tener 14 dígitos';
            qrErrorAlert.classList.remove('hidden');
            qrScanView.classList.remove('hidden');
            return;
        }

        try {
            const response = await fetch(`/BilleteraDigitalWeb/api/usuarios/cuenta/${encodeURIComponent(accountNumber)}`, {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });
            console.log('API Response Status:', response.status);
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(response.status === 404 ? errorData.error : 'Error al buscar la cuenta');
            }
            recipientData = await response.json();
            console.log('Cuenta encontrada:', recipientData);

            if (!recipientData.numero_cuenta || !recipientData.nombre || !recipientData.apellido) {
                throw new Error('Datos de la cuenta incompletos');
            }

            qrErrorAlert.classList.add('hidden');
            qrScanView.classList.add('hidden');
            scanQRModal.classList.remove('active');
            qrTransferModal.classList.add('active');
            setTimeout(() => {
                document.querySelector('#qrTransferModal .modal-content').classList.add('active');
            }, 10);

            qrRecipientName.textContent = `${recipientData.nombre} ${recipientData.apellido}`;
            qrMaskedAccountNumber.textContent = 'Termina en: ' + maskAccountNumber(accountNumber);
            qrMaskedAccountNumber.dataset.accountNumber = accountNumber;
            qrUserAccountNumber.textContent = window.userAccountData ? `Cuenta: ${window.userAccountData.numeroCuenta}` : 'Cuenta: N/A';
            qrUserBalance.textContent = window.userAccountData ? `Saldo: S/${window.userAccountData.saldo.toFixed(2)}` : 'Saldo';
        } catch (error) {
            console.error('Error al buscar cuenta:', error);
            qrErrorMessage.textContent = error.message || 'Error al buscar la cuenta';
            qrErrorAlert.classList.remove('hidden');
            qrScanView.classList.remove('hidden');
        }
    }
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

    // Cargar historial al iniciar
    window.loadTransferHistory();
});