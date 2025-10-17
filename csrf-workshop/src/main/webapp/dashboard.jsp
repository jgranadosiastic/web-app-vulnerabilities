<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Verificar autenticación
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}

String balance = (String) session.getAttribute("balance");
String userId = (String) session.getAttribute("userId");
%>
<html>
<head>
    <title>Dashboard - Banco Vulnerable</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f8f9fa; }
        .dashboard { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .user-info { background: #e7f3ff; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .menu { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .menu-item { background: #f8f9fa; padding: 20px; border-radius: 5px; text-align: center; border: 1px solid #dee2e6; }
        .menu-item a { text-decoration: none; color: #007bff; font-weight: bold; }
        .danger-zone { background: #f8d7da; padding: 20px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div style="max-width: 800px; margin: 0 auto;">
        <h1>🏦 Dashboard - Banco Vulnerable</h1>
        
        <div class="user-info">
            <h2>Bienvenido, <%= username %>!</h2>
            <p><strong>ID de Usuario:</strong> <%= userId %></p>
            <p><strong>Saldo Actual:</strong> $<%= balance %></p>
            <p><strong>Estado de Sesión:</strong> <span style="color: green;">✅ Activa</span></p>
        </div>

        <div class="menu">
            <div class="menu-item">
                <h3>💸 Transferencias</h3>
                <p>Realizar transferencias de dinero</p>
                <a href="transfer.jsp">Acceder →</a>
            </div>
            
            <div class="menu-item">
                <h3>👤 Perfil</h3>
                <p>Actualizar información personal</p>
                <a href="profile.jsp">Acceder →</a>
            </div>
            
            <div class="menu-item">
                <h3>🎯 Práctica CSRF</h3>
                <p>Páginas de ataque para practicar</p>
                <a href="csrf-attacker.jsp">Acceder →</a>
            </div>
            
            <div class="menu-item">
                <h3>🛡️ Versión Segura</h3>
                <p>Comparar con implementación segura</p>
                <a href="secure-transfer.jsp">Acceder →</a>
            </div>
        </div>

        <div class="danger-zone">
            <h3>⚠️ Zona de Práctica CSRF</h3>
            <p>Esta aplicación es vulnerable a CSRF. Practica con estas páginas de ataque:</p>
            <ul>
                <li><a href="csrf-attacker.jsp" style="color: #dc3545;">🔗 Página de Ataque Básico</a> - Formularios automáticos</li>
                <li><a href="csrf-advanced.jsp" style="color: #dc3545;">🔗 Ataque Avanzado</a> - Múltiples técnicas</li>
            </ul>
            <p><strong>Instrucción:</strong> Mantén esta sesión activa y visita las páginas de ataque.</p>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <a href="index.jsp" style="margin-right: 15px;">🏠 Inicio</a>
            <a href="logout.jsp" style="color: #dc3545;">🚪 Cerrar Sesión</a>
        </div>
    </div>
</body>
</html>