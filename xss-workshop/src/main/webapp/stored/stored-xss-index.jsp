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
%>
<html>
    <head>
        <title>XSS Stored - Laboratorio</title>
        <style>
            body {
                font-family: Arial;
                margin: 40px;
            }
            .menu {
                background: #f5f5f5;
                padding: 20px;
                margin: 20px 0;
                border-radius: 5px;
            }
            .module {
                background: #fff;
                padding: 15px;
                margin: 10px 0;
                border-left: 4px solid #007bff;
            }
            .stats {
                background: #e7f3ff;
                padding: 15px;
                margin: 10px 0;
            }
        </style>
    </head>
    <body>
        <h1>💾 XSS Stored - Laboratorio de Ataques Persistentes</h1>

        <div class="stats">
            <h3>📊 Estado Actual del Sistema:</h3>
            <p><strong>Comentarios almacenados:</strong> <%= database.getCommentsDB() != null ? database.getCommentsDB().size() : 0%></p>
            <p><strong>Mensajes en el sistema:</strong> <%= database.getMessagesDB() != null ? database.getMessagesDB().size() : 0%></p>
            <p><strong>Perfiles de usuario:</strong> <%= database.getUserProfilesDB() != null ? database.getUserProfilesDB().size() : 0%></p>
        </div>

        <div class="menu">
            <h2>🔧 Módulos de XSS Stored:</h2>

            <div class="module">
                <h3>💬 Sistema de Comentarios</h3>
                <p><strong>Vulnerabilidad:</strong> Comentarios se almacenan y muestran sin sanitización</p>
                <p><strong>Impacto:</strong> Todos los usuarios ven el payload malicioso</p>
                <p><a href="stored-comments.jsp">🚀 Practicar en Comentarios</a></p>
            </div>

            <div class="module">
                <h3>📨 Sistema de Mensajes</h3>
                <p><strong>Vulnerabilidad:</strong> Mensajes privados con XSS almacenado</p>
                <p><strong>Impacto:</strong> Solo usuarios específicos ven el payload</p>
                <p><a href="stored-messages.jsp">🚀 Practicar en Mensajes</a></p>
            </div>

            <div class="module">
                <h3>👤 Perfiles de Usuario</h3>
                <p><strong>Vulnerabilidad:</strong> Biografías y datos de perfil sin sanitizar</p>
                <p><strong>Impacto:</strong> Todos los visitantes del perfil son afectados</p>
                <p><a href="stored-profiles.jsp">🚀 Practicar en Perfiles</a></p>
            </div>

            <div class="module">
                <h3>📋 Panel de Administración</h3>
                <p><strong>Vulnerabilidad:</strong> Múltiples vectores en panel admin</p>
                <p><strong>Impacto:</strong> Acceso a funcionalidades privilegiadas</p>
                <p><a href="stored-admin.jsp">🚀 Practicar en Panel Admin</a></p>
            </div>
        </div>

        <div style="background: #fff3cd; padding: 15px; margin: 10px 0;">
            <h3>🎯 Características de XSS Stored:</h3>
            <ul>
                <li><strong>Persistente:</strong> El payload se almacena en la base de datos</li>
                <li><strong>Automático:</strong> Se ejecuta para cada usuario que visita la página</li>
                <li><strong>Escalable:</strong> Afecta a múltiples usuarios sin acción adicional</li>
                <li><strong>Peligroso:</strong> Puede robar cookies, redirigir, etc. automáticamente</li>
            </ul>
        </div>

        <p><a href="database-simulator.jsp">🗄️ Gestionar Base de Datos</a> | 
            <a href="${pageContext.request.contextPath}/index.jsp">← Volver al inicio</a></p>
    </body>
</html>