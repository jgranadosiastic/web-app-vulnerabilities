<%-- 
    Document   : login-cookies
    Created on : Oct 14, 2025, 9:40:04 PM
    Author     : jose
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Simular autenticación y crear cookies
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    if ("admin".equals(username) && "password123".equals(password)) {
        // Crear cookies de sesión
        Cookie userCookie = new Cookie("username", username);
        Cookie sessionCookie = new Cookie("sessionId", "sess_" + System.currentTimeMillis());
        Cookie roleCookie = new Cookie("userRole", "administrator");
        Cookie authCookie = new Cookie("authToken", "token_" + (int)(Math.random() * 10000));
        
        // Configurar cookies (algunas sin HttpOnly para poder robarlas)
        userCookie.setMaxAge(3600); // 1 hora
        sessionCookie.setMaxAge(3600);
        roleCookie.setMaxAge(3600);
        authCookie.setMaxAge(3600);
        
        // NO usar HttpOnly para demostración educativa
        // userCookie.setHttpOnly(true);
        // sessionCookie.setHttpOnly(true);
        
        response.addCookie(userCookie);
        response.addCookie(sessionCookie);
        response.addCookie(roleCookie);
        response.addCookie(authCookie);
        
        response.sendRedirect("profile-with-cookies.jsp");
        return;
    }
}

// Verificar si ya hay cookies
Cookie[] cookies = request.getCookies();
String currentUser = null;
if (cookies != null) {
    for (Cookie cookie : cookies) {
        if ("username".equals(cookie.getName())) {
            currentUser = cookie.getValue();
            break;
        }
    }
}
%>
<html>
<head>
    <title>Login con Cookies - XSS Lab</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .cookie-info { background: #e7f3ff; padding: 15px; margin: 10px 0; }
        .login-form { background: #fff3cd; padding: 20px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>🔐 Login con Cookies de Sesión</h1>
    
    <% if (currentUser != null) { %>
        <div class="cookie-info">
            <h3>✅ Ya estás autenticado</h3>
            <p>Usuario: <strong><%= currentUser %></strong></p>
            <p><a href="profile-with-cookies.jsp">Ir a tu perfil</a> | 
               <a href="logout.jsp">Cerrar sesión</a></p>
        </div>
    <% } else { %>
        <div class="login-form">
            <h3>📝 Iniciar Sesión para Generar Cookies</h3>
            <p><strong>Credenciales de prueba:</strong> usuario: <code>admin</code> / contraseña: <code>password123</code></p>
            
            <form method="POST">
                <label>Usuario:</label><br>
                <input type="text" name="username" value="admin" required><br><br>
                
                <label>Contraseña:</label><br>
                <input type="password" name="password" value="password123" required><br><br>
                
                <button type="submit">Iniciar Sesión</button>
            </form>
        </div>
    <% } %>
    
    <div class="cookie-info">
        <h3>🍪 Cookies que se generarán:</h3>
        <ul>
            <li><code>username</code> - Nombre del usuario</li>
            <li><code>sessionId</code> - ID único de sesión</li>
            <li><code>userRole</code> - Rol del usuario</li>
            <li><code>authToken</code> - Token de autenticación</li>
        </ul>
        <p><strong>Nota:</strong> Estas cookies NO tienen flag HttpOnly para fines educativos.</p>
    </div>
    
    <p><a href="index.jsp">← Volver al inicio</a></p>
</body>
</html>