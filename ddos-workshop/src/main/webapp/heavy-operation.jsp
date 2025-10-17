<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
// Parámetros configurables
String iterationsParam = request.getParameter("iterations");
int iterations = iterationsParam != null ? Integer.parseInt(iterationsParam) : 1000000;

String complexityParam = request.getParameter("complexity");
int complexity = complexityParam != null ? Integer.parseInt(complexityParam) : 1000;

long startTime = System.currentTimeMillis();

// Operación intensiva de CPU - Cálculos matemáticos pesados
double result = 0;
Random random = new Random();

for (int i = 0; i < iterations; i++) {
    for (int j = 0; j < complexity; j++) {
        // Cálculos matemáticos intensivos
        result += Math.sin(random.nextDouble()) * Math.cos(random.nextDouble());
        result += Math.sqrt(Math.abs(random.nextDouble()));
        result += Math.pow(random.nextDouble(), 2.5);
    }
}

long endTime = System.currentTimeMillis();
long duration = endTime - startTime;

// Estadísticas
Integer heavyOps = (Integer) application.getAttribute("heavyOperations");
if (heavyOps == null) heavyOps = 0;
heavyOps++;
application.setAttribute("heavyOperations", heavyOps);
application.setAttribute("lastHeavyOp", new Date());
%>
<html>
<head>
    <title>CPU Intensive Operation</title>
    <style>
        body { font-family: monospace; margin: 20px; background: #0f0f23; color: #00ff00; }
        .result { background: #1a1a2e; padding: 20px; border-radius: 8px; margin: 10px 0; }
        .stats { background: #162447; padding: 15px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>⚡ CPU Intensive Operation Complete</h1>
    
    <div class="result">
        <h3>📊 Resultados de la Operación:</h3>
        <p><strong>Iteraciones:</strong> <%= String.format("%,d", iterations) %></p>
        <p><strong>Complejidad:</strong> <%= String.format("%,d", complexity) %></p>
        <p><strong>Resultado Calculado:</strong> <%= String.format("%.4f", result) %></p>
        <p><strong>Tiempo de Ejecución:</strong> <%= duration %> ms</p>
        <p><strong>Operaciones/ms:</strong> <%= String.format("%,.0f", (iterations * complexity) / (double)duration) %></p>
    </div>

    <div class="stats">
        <h3>📈 Estadísticas del Sistema:</h3>
        <p><strong>Total Operaciones Pesadas:</strong> <%= heavyOps %></p>
        <p><strong>Última Operación:</strong> <%= application.getAttribute("lastHeavyOp") %></p>
        <p><strong>Memoria Libre:</strong> <%= Runtime.getRuntime().freeMemory() / 1024 / 1024 %> MB</p>
    </div>

    <div style="margin-top: 20px;">
        <h3>🔧 Ejemplos de Uso:</h3>
        <pre>
# Operación básica
curl "http://192.168.0.100:8080/ddos-workshop/heavy-operation.jsp"

# Más iteraciones (más carga CPU)
curl "http://192.168.0.100:8080/ddos-workshop/heavy-operation.jsp?iterations=5000000"

# Mayor complejidad
curl "http://192.168.0.100:8080/ddos-workshop/heavy-operation.jsp?complexity=5000"

# Combinación extrema
curl "http://192.168.0.100:8080/ddos-workshop/heavy-operation.jsp?iterations=10000000&complexity=10000"
        </pre>
    </div>

    <p><a href="index.jsp" style="color: #4cc9f0;">← Volver al Inicio</a></p>
</body>
</html>