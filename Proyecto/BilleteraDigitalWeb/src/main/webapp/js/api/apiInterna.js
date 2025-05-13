const BASE_URL = '<%= request.getContextPath() %>/usuariosSarah';

export async function verificarCorreo(correo) {
    try {
        const response = await fetch(`${BASE_URL}/correo/${encodeURIComponent(correo)}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            },
            credentials: 'include'
        });

        if (!response.ok) {
            throw new Error('Error al verificar el correo');
        }

        const data = await response.json();
        return data.exists;
    } catch (error) {
        console.error('Error al verificar el correo:', error);
        throw new Error('No se pudo verificar el correo');
    }
}

export async function loginUsuario(correo, pin) {
    try {
        const response = await fetch(`${BASE_URL}/login?correo=${encodeURIComponent(correo)}&contraseña=${encodeURIComponent(pin)}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            credentials: 'include'
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Error al iniciar sesión');
        }

        return await response.json();
    } catch (error) {
        console.error('Error al iniciar sesión:', error);
        throw error;
    }
}

export async function checkSession() {
    try {
        const response = await fetch(`${BASE_URL}/datos`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            },
            credentials: 'include'
        });
        return response.ok;
    } catch (error) {
        console.log('No hay sesión activa');
        return false;
    }
}