<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>CSRF Lab - Laboratorio de Ataques</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f8f9fa; }
        .container { max-width: 1000px; margin: 0 auto; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; border-radius: 10px; margin-bottom: 30px; }
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin: 30px 0; }
        .card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-left: 5px solid #007bff; }
        .card.vulnerable { border-left-color: #dc3545; }
        .card.secure { border-left-color: #28a745; }
        .card.education { border-left-color: #ffc107; }
        .btn { display: inline-block; padding: 12px 24px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; margin: 10px 5px; transition: background 0.3s; }
        .btn:hover { background: #0056b3; }
        .btn.danger { background: #dc3545; }
        .btn.danger:hover { background: #c82333; }
        .btn.success { background: #28a745; }
        .btn.success:hover { background: #218838; }
        .warning { background: #fff3cd; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #ffc107; }
        .danger { background: #f8d7da; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #dc3545; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>🔄 CSRF Lab - Laboratorio de Cross-Site Request Forgery</h1>
            <p><strong>Aprende sobre CSRF mediante práctica hands-on en aplicaciones vulnerables y seguras</strong></p>
        </div>

        <!-- Advertencia -->
        <div class="danger">
            <h3>⚠️ APLICACIÓN DELIBERADAMENTE VULNERABLE</h3>
            <p>Esta aplicación contiene vulnerabilidades CSRF intencionales para fines educativos.</p>
            <p><strong>NO usar en producción. Solo para entorno de laboratorio controlado.</strong></p>
        </div>

        <!-- Menú Principal -->
        <div class="menu-grid">
            <!-- Aplicación Bancaria Vulnerable -->
            <div class="card vulnerable">
                <h2>🏦 Aplicación Bancaria (Vulnerable)</h2>
                <p><strong>Simulación de banco con CSRF en transferencias y perfiles</strong></p>
                <p>Practica ataques CSRF en una aplicación bancaria realista.</p>
                <a href="login.jsp" class="btn danger">🚀 Acceder al Banco Vulnerable</a>
                <div style="margin-top: 15px;">
                    <strong>Vulnerabilidades:</strong>
                    <ul>
                        <li>Transferencias sin tokens CSRF</li>
                        <li>Actualización de perfil sin protección</li>
                        <li>Cookies sin flags Secure/HttpOnly</li>
                    </ul>
                </div>
            </div>

            <!-- Páginas de Ataque -->
            <div class="card vulnerable">
                <h2>🎯 Páginas de Ataque CSRF</h2>
                <p><strong>Simulación de sitios maliciosos</strong></p>
                <p>Páginas que los atacantes usarían para lanzar ataques CSRF.</p>
                <a href="csrf-attacker.jsp" class="btn danger">🕵️ Página de Ataque Básico</a>
                <a href="csrf-advanced.jsp" class="btn danger">🔬 Ataque Avanzado</a>
                <div style="margin-top: 15px;">
                    <strong>Técnicas incluidas:</strong>
                    <ul>
                        <li>Formularios ocultos automáticos</li>
                        <li>Ataques con imágenes</li>
                        <li>JavaScript automático</li>
                    </ul>
                </div>
            </div>

            <!-- Aplicación Segura -->
            <div class="card secure">
                <h2>🛡️ Aplicación Segura</h2>
                <p><strong>Misma funcionalidad pero con protecciones CSRF</strong></p>
                <p>Compara las diferencias entre código vulnerable y seguro.</p>
                <a href="secure-transfer.jsp" class="btn success">🔒 Ver Versión Segura</a>
                <div style="margin-top: 15px;">
                    <strong>Protecciones implementadas:</strong>
                    <ul>
                        <li>Tokens CSRF únicos</li>
                        <li>Validación de origen</li>
                        <li>SameSite cookies</li>
                    </ul>
                </div>
            </div>

            <!-- Educación -->
            <div class="card education">
                <h2>📚 Educación CSRF</h2>
                <p><strong>Aprende la teoría y técnicas de prevención</strong></p>
                <p>Explicaciones detalladas y guías de prevención.</p>
                <a href="csrf-education.jsp" class="btn">🎓 Teoría CSRF</a>
                <div style="margin-top: 15px;">
                    <strong>Contenido:</strong>
                    <ul>
                        <li>Flujo completo de ataque</li>
                        <li>Técnicas de prevención</li>
                        <li>Ejemplos del mundo real</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Guía Rápida -->
        <div class="warning">
            <h3>🎯 Flujo de Práctica Recomendado:</h3>
            <ol>
                <li><strong>Paso 1:</strong> Accede al <a href="login.jsp">banco vulnerable</a> e inicia sesión</li>
                <li><strong>Paso 2:</strong> Visita las <a href="csrf-attacker.jsp">páginas de ataque</a> mientras estás autenticado</li>
                <li><strong>Paso 3:</strong> Observa cómo se ejecutan acciones sin tu consentimiento</li>
                <li><strong>Paso 4:</strong> Compara con la <a href="secure-transfer.jsp">versión segura</a></li>
                <li><strong>Paso 5:</strong> Estudia la <a href="csrf-education.jsp">teoría</a> para entender la prevención</li>
            </ol>
        </div>

        <!-- Información de Sesión -->
        <div style="background: #e7f3ff; padding: 15px; border-radius: 8px; margin: 20px 0;">
            <h3>🔍 Estado Actual de la Sesión:</h3>
            <%
            String username = (String) session.getAttribute("username");
            if (username != null) {
            %>
                <p><strong>✅ Sesión activa:</strong> <code><%= username %></code></p>
                <p><a href="dashboard.jsp" class="btn">Ir al Dashboard</a></p>
            <%
            } else {
            %>
                <p><strong>❌ No hay sesión activa</strong></p>
                <p>Inicia sesión en el banco vulnerable para practicar ataques CSRF.</p>
            <%
            }
            %>
        </div>
    </div>
</body>
</html>