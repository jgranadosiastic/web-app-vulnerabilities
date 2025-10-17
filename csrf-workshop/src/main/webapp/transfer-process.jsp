<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Verificar autenticación
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}

// ⚠️ DELIBERADAMENTE VULNERABLE - Sin verificación CSRF
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String toAccount = request.getParameter("toAccount");
    String amount = request.getParameter("amount");
    String description = request.getParameter("description");
    
    // Simular procesamiento de transferencia
    String currentBalance = (String) session.getAttribute("balance");
    double balance = Double.parseDouble(currentBalance);
    double transferAmount = Double.parseDouble(amount);
    
    if (transferAmount <= balance) {
        balance -= transferAmount;
        session.setAttribute("balance", String.format("%.2f", balance));
        
        // Registrar transferencia
        String transferLog = String.format(
            "Transferencia: $%s a cuenta %s - %s", 
            amount, toAccount, description
        );
        session.setAttribute("lastTransfer", transferLog);
%>
<html>
<head>
    <title>Transferencia Exitosa</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f8f9fa; }
        .success { background: #d4edda; padding: 30px; border-radius: 8px; text-align: center; }
        .warning { background: #fff3cd; padding: 20px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div style="max-width: 600px; margin: 0 auto;">
        <div class="success">
            <h1>✅ Transferencia Exitosa</h1>
            <p><strong>Monto:</strong> $<%= amount %></p>
            <p><strong>Cuenta Destino:</strong> <%= toAccount %></p>
            <p><strong>Descripción:</strong> <%= description %></p>
            <p><strong>Nuevo Saldo:</strong> $<%= String.format("%.2f", balance) %></p>
        </div>
        
        <div class="warning">
            <h3>⚠️ Esta transferencia fue vulnerable a CSRF</h3>
            <p>No se verificó si esta solicitud fue intencional por parte del usuario.</p>
            <p>Cualquier sitio web podría haber iniciado esta transferencia sin tu conocimiento.</p>
        </div>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="transfer.jsp" style="margin-right: 15px;">💸 Otra Transferencia</a>
            <a href="dashboard.jsp">🏠 Dashboard</a>
        </div>
    </div>
</body>
</html>
<%
    } else {
        response.sendRedirect("transfer.jsp?error=Saldo insuficiente");
    }
} else {
    response.sendRedirect("transfer.jsp");
}
%>