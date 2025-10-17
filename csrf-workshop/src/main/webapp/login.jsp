<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Simular autenticación
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // Credenciales hardcodeadas para demo
    if ("usuario".equals(username) && "password".equals(password)) {
        // Crear sesión - DELIBERADAMENTE VULNERABLE
        session.setAttribute("username", username);
        session.setAttribute("userId", "1001");
        session.setAttribute("balance", "15000.00");
        
        // Cookies SIN HttpOnly para demostración
        Cookie userCookie = new Cookie("username", username);
        Cookie sessionCookie = new Cookie("sessionId", "sess_" + System.currentTimeMillis());
        response.addCookie(userCookie);
        response.addCookie(sessionCookie);
        
        response.sendRedirect("dashboard.jsp");
        return;
    } else {
        request.setAttribute("error", "Credenciales incorrectas");
    }
}
%>
<html>
<head>
    <title>Login - Banco Vulnerable</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f8f9fa; }
        .login-form { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 400px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { background: #dc3545; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .btn:hover { background: #c82333; }
        .error { color: #dc3545; margin-bottom: 15px; }
        .demo-info { background: #fff3cd; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div style="max-width: 500px; margin: 0 auto;">
        <h1>🔓 Login - Banco Vulnerable</h1>
        
        <div class="demo-info">
            <h3>🎯 Credenciales de Demo:</h3>
            <p><strong>Usuario:</strong> <code>usuario</code></p>
            <p><strong>Contraseña:</strong> <code>password</code></p>
            <p><small>Estas credenciales son hardcodeadas para el laboratorio.</small></p>
        </div>

        <div class="login-form">
            <h2>Iniciar Sesión</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form method="POST">
                <div class="form-group">
                    <label>Usuario:</label>
                    <input type="text" name="username" value="usuario" required>
                </div>
                
                <div class="form-group">
                    <label>Contraseña:</label>
                    <input type="password" name="password" value="password" required>
                </div>
                
                <button type="submit" class="btn">Iniciar Sesión</button>
            </form>
        </div>

        <div style="background: #f8d7da; padding: 15px; border-radius: 5px; margin-top: 20px;">
            <h3>⚠️ Configuración Vulnerable:</h3>
            <ul>
                <li>✅ Cookies SIN flag HttpOnly</li>
                <li>✅ Cookies SIN flag Secure</li>
                <li>✅ Sesiones sin tokens CSRF</li>
                <li>✅ No validación de origen</li>
            </ul>
        </div>

        <p style="text-align: center; margin-top: 20px;">
            <a href="index.jsp">← Volver al inicio</a>
        </p>
    </div>
</body>
</html>