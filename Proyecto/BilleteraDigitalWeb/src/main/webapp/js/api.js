const API_URL = 'https://api.consultasperu.com/api/v1/query';
const API_TOKEN = '502aa732c49c292289e80a80ca067c1a137af549a5f3a4d3831f01c8547d9f62';

export async function consultarDNI(dniNumber) {
    try {
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                token: API_TOKEN,
                type_document: 'dni',
                document_number: dniNumber
            })
        });

        if (!response.ok) {
            throw new Error('Error en la respuesta de la API');
        }

        const data = await response.json();
        
        if (!data.success) {
            throw new Error(data.message || 'Error al consultar el DNI');
        }

        return {
            nombre: data.data.name,
            apellidos: data.data.surname,
            fechaNacimiento: data.data.date_of_birth
        };
    } catch (error) {
        console.error('Error al consultar la API:', error);
        throw new Error('No se pudo verificar el DNI. Por favor intente nuevamente.');
    }
}

export function esMayorDeEdad(fechaNacimiento) {
    if (!fechaNacimiento) return false;
    
    const fechaNac = new Date(fechaNacimiento);
    const hoy = new Date();
    
    let edad = hoy.getFullYear() - fechaNac.getFullYear();
    const mes = hoy.getMonth() - fechaNac.getMonth();
    
    if (mes < 0 || (mes === 0 && hoy.getDate() < fechaNac.getDate())) {
        edad--;
    }
    
    return edad >= 18;
}