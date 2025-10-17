<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Verificar autenticación
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}

// Generar token CSRF seguro
String csrfToken = java.util.UUID.randomUUID().toString();
session.setAttribute("csrfToken", csrfToken);
%>
<html>
<head>
    <title>Transferencias Seguras</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f8f9fa; }
        .transfer-form { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 500px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="number"] { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .btn:hover { background: #218838; }
        .security-info { background: #d4edda; padding: 15px; border-radius: 5px; margin: 20px 0; }
        .token-display { background: #e9ecef; padding: 10px; border-radius: 4px; font-family: monospace; margin: 10px 0; }
    </style>
</head>
<body>
    <div style="max-width: 600px; margin: 0 auto;">
        <h1>🛡️ Transferencias Seguras</h1>
        
        <div class="security-info">
            <h3>✅ PROTEGIDO CONTRA CSRF</h3>
            <p>Este formulario incluye protección CSRF:</p>
            <ul>
                <li>✅ Usa tokens CSRF únicos</li>
                <li>✅ Valida origen del request</li>
                <li>✅ Bloquea requests cross-site</li>
            </ul>
        </div>

        <div class="transfer-form">
            <h2>Realizar Transferencia Segura</h2>
            
            <form method="POST" action="secure-transfer-process.jsp">
                <!-- ✅ TOKEN CSRF INCLUIDO -->
                <input type="hidden" name="csrfToken" value="<%= csrfToken %>">
                
                <div class="form-group">
                    <label>Cuenta Destino:</label>
                    <input type="text" name="toAccount" placeholder="Número de cuenta" required>
                </div>
                
                <div class="form-group">
                    <label>Monto:</label>
                    <input type="number" name="amount" placeholder="0.00" step="0.01" required>
                </div>
                
                <div class="form-group">
                    <label>Descripción:</label>
                    <input type="text" name="description" placeholder="Concepto de la transferencia">
                </div>
                
                <div class="form-group">
                    <label>Token CSRF (para demostración):</label>
                    <div class="token-display"><%= csrfToken %></div>
                    <small>Este token cambia en cada carga y es único para tu sesión.</small>
                </div>
                
                <button type="submit" class="btn">Realizar Transferencia Segura</button>
            </form>
        </div>

        <div style="background: #e7f3ff; padding: 15px; border-radius: 5px; margin-top: 20px;">
            <h3>🔒 Cómo Funciona la Protección:</h3>
            <ol>
                <li>El servidor genera un token único para cada formulario</li>
                <li>El token se almacena en la sesión del usuario</li>
                <li>El formulario incluye el token como campo hidden</li>
                <li>Al procesar, el servidor verifica que el token coincida</li>
                <li>Los ataques CSRF no pueden acceder al token (Same-Origin Policy)</li>
            </ol>
        </div>

        <div style="text-align: center; margin-top: 20px;">
            <a href="transfer.jsp">🔓 Ver Versión Vulnerable</a> | 
            <a href="dashboard.jsp">← Dashboard</a>
        </div>
    </div>
</body>
</html>