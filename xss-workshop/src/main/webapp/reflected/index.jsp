<%-- 
    Document   : index
    Created on : Oct 14, 2025, 5:49:20 PM
    Author     : jose
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>XSS - Aplicación Vulnerable</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .menu { background: #f5f5f5; padding: 20px; border-radius: 5px; margin: 20px 0; }
        .vulnerability { background: #fff3cd; padding: 15px; margin: 10px 0; border-left: 4px solid #ffc107; }
        .payloads { background: #d1ecf1; padding: 15px; margin: 10px 0; border-radius: 5px; }
        code { background: #eee; padding: 2px 5px; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚨 XSS - Aplicación Vulnerable</h1>
        <p><strong>Objetivo:</strong> Practicar ataques XSS Reflected en diferentes contextos</p>
        
        <div class="vulnerability">
            <h3>⚠️ ADVERTENCIA</h3>
            <p>Esta aplicación es <strong>deliberadamente vulnerable</strong> para fines educativos.</p>
            <p>NO usar en producción. Solo para entorno de laboratorio controlado.</p>
        </div>

        <div class="menu">
            <h2>Módulos de Práctica:</h2>
            <ul>
                <li><a href="search.jsp">🔍 Búsqueda (Vulnerabilidad Básica)</a></li>
                <li><a href="profile.jsp">👤 Perfil (Contextos Múltiples)</a></li>
                <li><a href="contact.jsp">📧 Contacto (Formularios POST)</a></li>
                <li><a href="login.jsp">🔐 Login (Mensajes de Error)</a></li>
                <li><a href="results.jsp">📊 Resultados (Múltiples Vectores)</a></li>
            </ul>
        </div>

        <div class="payloads">
            <h3>🎯 Payloads Básicos para Probar:</h3>
            <code>&lt;script&gt;alert('XSS')&lt;/script&gt;</code><br>
            <code>&lt;img src=x onerror=alert(1)&gt;</code><br>
            <code>&lt;svg onload=alert(document.domain)&gt;</code><br>
            <code&gt;"&gt;&lt;script&gt;alert(1)&lt;/script&gt;</code><br>
            <code&gt;'; alert(1); //</code>
        </div>

        <div class="vulnerability">
            <h3>📝 Ejercicios para Estudiantes:</h3>
            <ol>
                <li>Encontrar todos los parámetros vulnerables en cada página</li>
                <li>Ejecutar un alert simple en cada módulo</li>
                <li>Crear un payload que robe la cookie de sesión</li>
                <li>Intentar bypass de filtros básicos</li>
                <li>Comparar con las versiones seguras</li>
            </ol>
        </div>
    </div>
    <hr>
   

    <p><a href="${pageContext.request.contextPath}/index.jsp">← Volver al inicio</a></p>
</body>
</html>
