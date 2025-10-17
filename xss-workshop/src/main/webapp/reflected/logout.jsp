<%-- 
    Document   : logout
    Created on : Oct 15, 2025, 9:37:15 AM
    Author     : jose
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Eliminar todas las cookies
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        Cookie deleteCookie = new Cookie(cookie.getName(), "");
        deleteCookie.setMaxAge(0);
        response.addCookie(deleteCookie);
    }
}
%>
<html>
<head>
    <title>Logout - XSS Lab</title>
    <style>
        body { font-family: Arial; margin: 40px; text-align: center; }
        .success { background: #d4edda; padding: 20px; margin: 20px auto; max-width: 500px; }
    </style>
</head>
<body>
    <div class="success">
        <h1>✅ Sesión Cerrada</h1>
        <p>Todas las cookies han sido eliminadas.</p>
        <p><a href="login-cookies.jsp">Iniciar sesión nuevamente</a></p>
        <p><a href="index.jsp">Volver al inicio</a></p>
    </div>
</body>
</html>