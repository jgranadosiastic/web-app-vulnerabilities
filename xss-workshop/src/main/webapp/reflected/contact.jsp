<%-- 
    Document   : contact
    Created on : Oct 14, 2025, 5:50:30 PM
    Author     : jose
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Contacto - XSS Lab</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .success { background: #d4edda; padding: 15px; margin: 10px 0; }
        .vulnerable { background: #f8d7da; padding: 10px; margin: 5px 0; }
    </style>
</head>
<body>
    <h1>📧 Formulario de Contacto (POST)</h1>

    <div class="vulnerable">
        <strong>VULNERABILIDAD:</strong> Reflected XSS en mensaje de confirmación
    </div>

    <form method="POST" action="contact.jsp">
        <label>Nombre:</label><br>
        <input type="text" name="name" required><br><br>

        <label>Email:</label><br>
        <input type="email" name="email" required><br><br>

        <label>Mensaje:</label><br>
        <textarea name="message" rows="4" cols="50" required></textarea><br><br>

        <button type="submit">Enviar Mensaje</button>
    </form>

    <%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");
        
        if (name != null && email != null && message != null) {
    %>
            <div class="success">
                <h3>✅ Mensaje Enviado Exitosamente</h3>
                <p><strong>Gracias <%= name %></strong>, hemos recibido tu mensaje.</p>
                <p>Te contactaremos pronto a: <strong><%= email %></strong></p>
                
                <div class="vulnerable">
                    <strong>VULNERABLE:</strong> Nombre reflejado sin sanitización
                </div>
            </div>
    <%
        }
    }
    %>

    <hr>
    <h3>🎯 Cómo probar:</h3>
    <ol>
        <li>Llenar el formulario con payload en el campo "name"</li>
        <li>Ejemplo: <code>&lt;script&gt;alert('XSS')&lt;/script&gt;</code></li>
        <li>Al enviar, el payload se ejecutará en la página de confirmación</li>
    </ol>

    <p><a href="index.jsp">← Volver al inicio</a></p>
</body>
</html>