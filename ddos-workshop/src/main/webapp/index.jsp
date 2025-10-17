<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.lang.management.*" %>
<%
// Métricas del sistema para monitoreo
Runtime runtime = Runtime.getRuntime();
long maxMemory = runtime.maxMemory();
long totalMemory = runtime.totalMemory();
long freeMemory = runtime.freeMemory();
long usedMemory = totalMemory - freeMemory;

// Contador de requests (simulado)
Integer requestCount = (Integer) application.getAttribute("requestCount");
if (requestCount == null) {
    requestCount = 0;
}
requestCount++;
application.setAttribute("requestCount", requestCount);

// Timestamp del último request
application.setAttribute("lastRequest", new Date());
%>
<html>
<head>
    <title>DDoS Test Lab - Laboratorio Educativo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #0f0f23; color: #cccccc; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); color: white; padding: 40px; border-radius: 10px; margin-bottom: 30px; }
        .endpoint-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin: 30px 0; }
        .endpoint-card { background: #1a1a2e; padding: 25px; border-radius: 8px; border-left: 5px solid #dc3545; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-item { background: #162447; padding: 20px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #4cc9f0; }
        .btn { display: inline-block; padding: 12px 24px; background: #dc3545; color: white; text-decoration: none; border-radius: 5px; margin: 10px 5px; transition: all 0.3s; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(220,53,69,0.3); }
        .warning { background: rgba(220,53,69,0.2); padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #dc3545; }
        .code-block { background: #2d3748; padding: 15px; border-radius: 5px; font-family: monospace; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>🌐 DDoS Test Lab - Laboratorio de Pruebas Controladas</h1>
            <p><strong>Endpoint vulnerables diseñados para practicar ataques DDoS en entorno controlado</strong></p>
        </div>

        <!-- Advertencia de Seguridad -->
        <div class="warning">
            <h3>⚠️ USO EXCLUSIVO EN ENTORNO LOCAL</h3>
            <p>Esta aplicación está diseñada específicamente para <strong>pruebas educativas en localhost</strong>.</p>
            <p><strong>NUNCA despliegues esta aplicación en servidores accesibles desde Internet.</strong></p>
        </div>

        <!-- Métricas del Sistema -->
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-number"><%= requestCount %></div>
                <div>Total Requests</div>
            </div>
            <div class="stat-item">
                <div class="stat-number"><%= String.format("%.1f", usedMemory / 1024.0 / 1024.0) %> MB</div>
                <div>Memoria Usada</div>
            </div>
            <div class="stat-item">
                <div class="stat-number"><%= application.getAttribute("lastRequest") != null ? 
                    ((Date)application.getAttribute("lastRequest")).toString().substring(11, 19) : "N/A" %></div>
                <div>Último Request</div>
            </div>
        </div>

        <!-- Endpoints para Testing -->
        <div class="endpoint-grid">
            <!-- Endpoint 1: Operación Pesada -->
            <div class="endpoint-card">
                <h3>⚡ CPU Intensive Endpoint</h3>
                <p><strong>URL:</strong> <code>/heavy-operation.jsp</code></p>
                <p>Realiza cálculos matemáticos intensivos para consumir CPU.</p>
                <a href="heavy-operation.jsp" class="btn">🔗 Probar Endpoint</a>
                <div class="code-block">
                    curl http://192.168.0.100:8080/ddos-workshop/heavy-operation.jsp
                </div>
            </div>

            <!-- Endpoint 2: Memory Intensive -->
            <div class="endpoint-card">
                <h3>💾 Memory Intensive Endpoint</h3>
                <p><strong>URL:</strong> <code>/api/data.jsp</code></p>
                <p>Almacena grandes cantidades de datos en memoria.</p>
                <a href="api/data.jsp" class="btn">🔗 Probar Endpoint</a>
                <div class="code-block">
                    curl http://192.168.0.100:8080/ddos-workshop/api/data.jsp
                </div>
            </div>

            <!-- Endpoint 3: Procesamiento Lento -->
            <div class="endpoint-card">
                <h3>🐌 Slow Processing Endpoint</h3>
                <p><strong>URL:</strong> <code>/api/process.jsp</code></p>
                <p>Simula procesamiento lento con delays artificiales.</p>
                <a href="api/process.jsp" class="btn">🔗 Probar Endpoint</a>
                <div class="code-block">
                    curl http://192.168.0.100:8080/ddos-workshop/api/process.jsp
                </div>
            </div>

            <!-- Endpoint 4: Multiple Requests -->
            <div class="endpoint-card">
                <h3>📊 Load Test Endpoint</h3>
                <p><strong>URL:</strong> <code>/load-test.jsp</code></p>
                <p>Endpoint para testing de carga con parámetros configurables.</p>
                <a href="load-test.jsp" class="btn">🔗 Probar Endpoint</a>
                <div class="code-block">
                    curl "http://192.168.0.100:8080/ddos-workshop/load-test.jsp?requests=100"
                </div>
            </div>
        </div>

        <!-- Scripts de Prueba -->
        <div style="background: rgba(255,193,7,0.2); padding: 20px; border-radius: 8px; margin: 30px 0;">
            <h3>🎯 Scripts de Prueba DDoS</h3>
            <p>Usa estos scripts para simular ataques DDoS controlados:</p>
            
            <div class="code-block">
                # HTTP Flood Attack<br>
                ./scripts/http-flood.sh<br><br>
                
                # DDoS Simulation<br>
                ./scripts/ddos-simulation.sh<br><br>
                
                # Resource Monitoring<br>
                ./scripts/resource-monitor.sh<br><br>
                
                # Stress Testing<br>
                ./scripts/stress-test.sh
            </div>
            
            <p><strong>Ubicación:</strong> <code>/scripts/</code> en el directorio del proyecto</p>
        </div>

        <!-- Monitor en Tiempo Real -->
        <div style="text-align: center; margin-top: 30px;">
            <a href="resource-monitor.jsp" class="btn" style="background: #28a745;">📊 Monitor en Tiempo Real</a>
            <a href="vulnerable-endpoints.jsp" class="btn" style="background: #007bff;">🔧 Todos los Endpoints</a>
        </div>
    </div>
</body>
</html>