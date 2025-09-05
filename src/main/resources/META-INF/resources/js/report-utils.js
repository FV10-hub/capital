function openAndPrintReport(endpoint, parametrosJson) {
    fetch(endpoint, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(parametrosJson)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        return response.blob();
    })
    .then(blob => {
        const url = URL.createObjectURL(blob);

        const win = window.open(url, '_blank');

        if (!win) {
            alert('El navegador bloqueó la ventana emergente. Permití popups para este sitio.');
            URL.revokeObjectURL(url);
            return;
        }

        setTimeout(() => URL.revokeObjectURL(url), 60000);
    })
    .catch(error => {
        console.error("Error al generar el reporte:", error);

        const errorWin = window.open('', '_blank');
        if (errorWin) {
            errorWin.document.write(
                '<!doctype html><html><head><title>Error</title></head>' +
                '<body style="font-family:sans-serif;padding:16px;">' +
                '<p style="color:red;">Error al generar el reporte: ' + error.message + '</p>' +
                '</body></html>'
            );
        }
    });
}


function downloadReport(endpoint, parametrosJson, nombreArchivo = 'reporte.pdf') {
    fetch(endpoint, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(parametrosJson)
    })
    .then(response => {
        if (!response.ok) throw new Error(`Error HTTP: ${response.status}`);

        let filename = "geogoeogeoogeosoos"
        return response.blob().then(blob => ({ blob, filename }));
    })
    .then(({ blob, filename }) => {
        // Crear un enlace temporal para descargar
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename; // Usar el nombre del archivo
        document.body.appendChild(a);
        a.click();
        a.remove();
        window.URL.revokeObjectURL(url);
    })
    .catch(error => {
        console.error("Error al descargar el reporte:", error);
        alert("Error al descargar el reporte");
    });
}