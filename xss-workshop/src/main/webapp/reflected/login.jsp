<%-- 
    Document   : login
    Created on : Oct 14, 2025, 5:50:46 PM
    Author     : jose
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - XSS Lab</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .error { background: #f8d7da; color: #721c24; padding: 15px; margin: 10px 0; }
        .vulnerable { background: #fff3cd; padding: 10px; margin: 5px 0; }
    </style>
</head>
<body>
    <h1>🔐 Sistema de Login (Mensajes de Error)</h1>

    <div class="vulnerable">
        <strong>VULNERABILIDAD:</strong> XSS Reflected en mensajes de error
    </div>

    <form method="GET" action="login.jsp">
        <label>Usuario:</label><br>
        <input type="text" name="username"><br><br>

        <label>Contraseña:</label><br>
        <input type="password" name="password"><br><br>

        <button type="submit">Iniciar Sesión</button>
    </form>

    <%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    if (username != null && password != null) {
        // Simulación de validación (siempre falla para demostración)
        String errorMsg = request.getParameter("error");
        if (errorMsg == null) {
            errorMsg = "Credenciales inválidas para usuario: " + username;
        }
    %>
        <div class="error">
            <h3>❌ Error de Autenticación</h3>
            <p><%= errorMsg %></p>
            
            <div class="vulnerable">
                <strong>VULNERABLE:</strong> Mensaje de error sin sanitización
            </div>
        </div>
    <%
    }
    %>

    <hr>
    <h3>🎯 Vectores de Ataque:</h3>
    <ul>
        <li><code>login.jsp?username=admin&password=test</code> (Error normal)</li>
        <li><code>login.jsp?username=&lt;script&gt;alert(1)&lt;/script&gt;&password=test</code></li>
        <li><code>login.jsp?username=test&password=test&error=&lt;img src=x onerror=alert(1)&gt;</code></li>
    </ul>

    <p><a href="index.jsp">← Volver al inicio</a></p>
</body>
</html>