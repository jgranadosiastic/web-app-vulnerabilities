<%@page import="com.jgranados.xss.workshop.db.DB"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.io.*" %>
<%
    
    DB database = new DB(application);

// Aplicación

application.setAttribute("DB", database);
%>

<%!
    

// Guardar datos en archivo

    %>
<html>
<head>
    <title>Database Simulator - XSS Lab</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .info { background: #e7f3ff; padding: 15px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>🗄️ Simulador de Base de Datos</h1>
    
    <div class="info">
        <h3>📊 Datos Actuales en la "Base de Datos":</h3>
        <p><strong>Comentarios:</strong> <%= database.getCommentsDB().size() %> registros</p>
        <p><strong>Mensajes:</strong> <%= database.getMessagesDB().size() %> registros</p>
        <p><strong>Perfiles:</strong> <%= database.getUserProfilesDB().size() %> registros</p>
        
        <form method="POST">
            <button type="submit" name="clear" value="true">🗑️ Limpiar Base de Datos</button>
            <button type="submit" name="addSample" value="true">📝 Agregar Datos de Ejemplo</button>
        </form>
    </div>

    <%
    if ("true".equals(request.getParameter("clear"))) {
        database.clear();
        response.sendRedirect("database-simulator.jsp");
    }
    
    if ("true".equals(request.getParameter("addSample"))) {
        // Agregar datos de ejemplo
        Map<String, String> comment1 = new HashMap<>();
        comment1.put("id", "1");
        comment1.put("user", "Usuario Ejemplo");
        comment1.put("content", "¡Este es un comentario normal!");
        comment1.put("timestamp", "2024-01-15 10:30:00");
        database.getCommentsDB().add(comment1);
        
        Map<String, String> profile1 = new HashMap<>();
        profile1.put("id", "1");
        profile1.put("username", "juan_perez");
        profile1.put("bio", "Desarrollador de software");
        database.getUserProfilesDB().add(profile1);
        
        database.saveToFile();
        response.sendRedirect("database-simulator.jsp");
    }
    %>
    
    <p><a href="stored-xss-index.jsp">🚀 Ir al Laboratorio XSS Stored</a> | 
       <a href="${pageContext.request.contextPath}/index.jsp">← Volver al inicio</a></p>
</body>
</html>