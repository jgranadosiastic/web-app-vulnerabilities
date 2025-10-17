<%-- 
    Document   : index
    Created on : Oct 15, 2025, 8:27:06 AM
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
        <p><strong>Objetivo:</strong> Practicar ataques XSS en diferentes contextos</p>
        
        <div class="vulnerability">
            <h3>⚠️ ADVERTENCIA</h3>
            <p>Esta aplicación es <strong>deliberadamente vulnerable</strong> para fines educativos.</p>
            <p>NO usar en producción. Solo para entorno de laboratorio controlado.</p>
        </div>

        <div class="menu">
            <h2>Módulos de Práctica:</h2>
            <ul>
                <li><a href="reflected/index.jsp">Ejemplos de XSS Refleced</a></li>
                <li><a href="stored/stored-xss-index.jsp">Ejemplos de XSS Stored</a></li>
            </ul>
        </div>
    </div>
</body>
</html>