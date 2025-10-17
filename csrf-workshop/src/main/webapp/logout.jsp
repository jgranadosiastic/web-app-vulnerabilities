<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Invalidar sesión
session.invalidate();

// Eliminar cookies
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
    <title>Logout</title>
    <style>
        body { font-family: Arial; margin: 40px; text-align: center; background: #f8f9fa; }
        .success { background: #d4edda; padding: 40px; border-radius: 8px; max-width: 500px; margin: 0 auto; }
    </style>
</head>
<body>
    <div class="success">
        <h1>✅ Sesión Cerrada</h1>
        <p>Tu sesión ha sido cerrada exitosamente y todas las cookies han sido eliminadas.</p>
        <p>Ahora estás protegido contra ataques CSRF desde esta sesión.</p>
        
        <div style="margin-top: 30px;">
            <a href="login.jsp" style="margin-right: 15px;">🔓 Iniciar Sesión Nuevamente</a>
            <a href="index.jsp">🏠 Página Principal</a>
        </div>
    </div>
</body>
</html>