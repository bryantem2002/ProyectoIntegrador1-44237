
// Acordeón funcionalidad
document.querySelectorAll('[data-accordion-target]').forEach(button => {
    button.addEventListener('click', () => {
        const target = document.querySelector(button.getAttribute('data-accordion-target'));
        const isOpen = !target.classList.contains('hidden');

        // Cerrar todos los acordeones
        document.querySelectorAll('[data-accordion-target]').forEach(btn => {
            const tgt = document.querySelector(btn.getAttribute('data-accordion-target'));
            tgt.classList.add('hidden');
            btn.setAttribute('aria-expanded', false);
            btn.querySelector('[data-accordion-icon]').classList.remove('rotate-180');
        });

        // Abrir el seleccionado si estaba cerrado
        if (!isOpen) {
            target.classList.remove('hidden');
            button.setAttribute('aria-expanded', true);
            button.querySelector('[data-accordion-icon]').classList.add('rotate-180');
        }
    });
});

// Búsqueda de preguntas
document.getElementById('search-button').addEventListener('click', () => {
    const questionInput = document.getElementById('question-input').value.toLowerCase();
    const faqs = document.querySelectorAll('#accordion-collapse h2');

    let found = false;

    faqs.forEach((faq, index) => {
        const button = faq.querySelector('button');
        const questionText = button.textContent.toLowerCase();
        const body = document.querySelector(`#accordion-collapse-body-${index + 1}`);

        if (questionText.includes(questionInput)) {
            // Abrir
            document.querySelectorAll('[data-accordion-target]').forEach(btn => {
                const tgt = document.querySelector(btn.getAttribute('data-accordion-target'));
                tgt.classList.add('hidden');
                btn.setAttribute('aria-expanded', false);
                btn.querySelector('[data-accordion-icon]').classList.remove('rotate-180');
            });

            body.classList.remove('hidden');
            button.setAttribute('aria-expanded', true);
            button.querySelector('[data-accordion-icon]').classList.add('rotate-180');
            faq.scrollIntoView({ behavior: 'smooth', block: 'center' });
            faq.classList.add('bg-yellow-100');
            found = true;
        } else {
            faq.classList.remove('bg-yellow-100');
        }
    });

    if (!found) {
        alert(`No se encontró una pregunta relacionada con: "${questionInput}"`);
    }
});