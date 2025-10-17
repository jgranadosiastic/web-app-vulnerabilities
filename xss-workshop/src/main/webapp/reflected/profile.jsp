<%-- 
    Document   : profile
    Created on : Oct 14, 2025, 5:50:11 PM
    Author     : jose
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Perfil de Usuario - XSS Lab</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .context { background: #fff3cd; padding: 15px; margin: 10px 0; border-left: 4px solid #ffc107; }
        .vulnerable { background: #f8d7da; padding: 10px; margin: 5px 0; }
    </style>
</head>
<body>
    <h1>👤 Perfil de Usuario (Múltiples Contextos)</h1>

    <div class="context">
        <strong>MÚLTIPLES VECTORES:</strong> Diferentes contextos de inyección
    </div>

    <%
    String name = request.getParameter("name");
    String bio = request.getParameter("bio");
    String website = request.getParameter("website");
    String theme = request.getParameter("theme");
    %>

    <form method="GET" action="profile.jsp">
        <h3>Editar Perfil:</h3>
        
        <div class="vulnerable">
            <strong>Contexto HTML:</strong> Campo nombre
        </div>
        <label>Nombre:</label><br>
        <input type="text" name="name" value="<%= name != null ? name : "Usuario" %>"><br><br>

        <div class="vulnerable">
            <strong>Contexto Atributo:</strong> Campo biografía
        </div>
        <label>Biografía:</label><br>
        <textarea name="bio" placeholder="<%= bio != null ? bio : "Escribe tu biografía..." %>"></textarea><br><br>

        <div class="vulnerable">
            <strong>Contexto URL:</strong> Campo website
        </div>
        <label>Sitio Web:</label><br>
        <input type="text" name="website" value="<%= website != null ? website : "https://" %>"><br><br>

        <div class="vulnerable">
            <strong>Contexto JavaScript:</strong> Campo tema
        </div>
        <label>Tema preferido:</label><br>
        <input type="text" name="theme" value="<%= theme != null ? theme : "light" %>"><br><br>

        <button type="submit">Actualizar Perfil</button>
    </form>

    <%
    if (name != null || bio != null || website != null || theme != null) {
    %>
        <hr>
        <h2>Perfil Actual:</h2>
        
        <div class="vulnerable">
            <strong>VULNERABLE:</strong> Nombre sin escapado
        </div>
        <p><strong>Nombre:</strong> <%= name != null ? name : "No definido" %></p>

        <div class="vulnerable">
            <strong>VULNERABLE:</strong> Biografía en atributo
        </div>
        <p><strong>Biografía:</strong> 
            <span title="<%= bio != null ? bio : "Sin biografía" %>">(pasa el mouse)</span>
        </p>

        <div class="vulnerable">
            <strong>VULNERABLE:</strong> Website en enlace
        </div>
        <p><strong>Sitio Web:</strong> 
            <a href="<%= website != null ? website : "#" %>">Visitar sitio</a>
        </p>

        <div class="vulnerable">
            <strong>VULNERABLE:</strong> Tema en JavaScript
        </div>
        <script>
            var userTheme = "<%= theme != null ? theme : "light" %>";
            document.write('<p><strong>Tema configurado:</strong> ' + userTheme + '</p>');
        </script>
    <%
    }
    %>

    <hr>
    <h3>🎯 Payloads por Contexto:</h3>
    <ul>
        <li><strong>HTML:</strong> <code>&lt;script&gt;alert(1)&lt;/script&gt;</code></li>
        <li><strong>Atributo:</strong> <code>" onmouseover="alert(1)</code></li>
        <li><strong>URL:</strong> <code>javascript:alert(1)</code></li>
        <li><strong>JavaScript:</strong> <code>"; alert(1); //</code></li>
    </ul>

    <p><a href="index.jsp">← Volver al inicio</a></p>
</body>
</html>