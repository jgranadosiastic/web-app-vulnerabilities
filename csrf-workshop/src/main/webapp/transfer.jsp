<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Verificar autenticación
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<html>
<head>
    <title>Transferencias - Banco Vulnerable</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f8f9fa; }
        .transfer-form { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 500px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="number"] { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { background: #dc3545; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .btn:hover { background: #c82333; }
        .vulnerability-info { background: #f8d7da; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div style="max-width: 600px; margin: 0 auto;">
        <h1>💸 Transferencias - Banco Vulnerable</h1>
        
        <div class="vulnerability-info">
            <h3>❌ VULNERABLE A CSRF</h3>
            <p>Este formulario NO tiene protección CSRF:</p>
            <ul>
                <li>❌ No usa tokens CSRF</li>
                <li>❌ No valida origen del request</li>
                <li>❌ Permite requests cross-site</li>
            </ul>
        </div>

        <div class="transfer-form">
            <h2>Realizar Transferencia</h2>
            
            <form method="POST" action="transfer-process.jsp">
                <!-- ⚠️ DELIBERADAMENTE SIN TOKEN CSRF -->
                
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
                
                <button type="submit" class="btn">Realizar Transferencia</button>
            </form>
        </div>

        <div style="background: #fff3cd; padding: 15px; border-radius: 5px; margin-top: 20px;">
            <h3>🎯 Para Practicar:</h3>
            <ol>
                <li>Inicia sesión en esta aplicación</li>
                <li>Visita <a href="csrf-attacker.jsp">csrf-attacker.jsp</a> en otra pestaña</li>
                <li>Observa cómo se ejecuta una transferencia automáticamente</li>
                <li>Regresa aquí y verifica que la transferencia se realizó</li>
            </ol>
        </div>

        <div style="text-align: center; margin-top: 20px;">
            <a href="dashboard.jsp">← Volver al Dashboard</a> | 
            <a href="secure-transfer.jsp">🛡️ Ver Versión Segura</a>
        </div>
    </div>
</body>
</html>