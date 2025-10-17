<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
// Contador global de requests
Integer totalRequests = (Integer) application.getAttribute("totalRequests");
if (totalRequests == null) {
    totalRequests = 0;
    application.setAttribute("totalRequests", totalRequests);
}

// Registrar este request
totalRequests++;
application.setAttribute("totalRequests", totalRequests);
application.setAttribute("lastRequestTime", new Date());
%>
<html>
<head>
    <title>Vulnerable Endpoints - DDoS Test Lab</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #0f0f23; color: #cccccc; }
        .container { max-width: 1200px; margin: 0 auto; }
        .endpoint-list { background: #1a1a2e; padding: 30px; border-radius: 8px; margin: 20px 0; }
        .endpoint-item { background: #162447; padding: 20px; margin: 15px 0; border-radius: 5px; border-left: 4px solid #dc3545; }
        .code-block { background: #2d3748; padding: 15px; border-radius: 5px; font-family: monospace; margin: 10px 0; }
        .stats { background: rgba(220,53,69,0.2); padding: 20px; border-radius: 8px; margin: 20px 0; }
        .btn { display: inline-block; padding: 10px 20px; background: #dc3545; color: white; text-decoration: none; border-radius: 5px; margin: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎯 Endpoints Vulnerables - DDoS Test Lab</h1>
        
        <div class="stats">
            <h3>📊 Estadísticas Globales</h3>
            <p><strong>Total Requests:</strong> <%= totalRequests %></p>
            <p><strong>Último Request:</strong> <%= application.getAttribute("lastRequestTime") %></p>
            <p><strong>Endpoints Activos:</strong> 6</p>
        </div>

        <div class="endpoint-list">
            <h2>⚡ Endpoints de Consumo de CPU</h2>
            
            <!-- Endpoint 1 -->
            <div class="endpoint-item">
                <h3>1. Heavy CPU Operation</h3>
                <p><strong>URL:</strong> <code>/heavy-operation.jsp</code></p>
                <p><strong>Propósito:</strong> Consumir CPU con cálculos matemáticos intensivos</p>
                <p><strong>Parámetros:</strong></p>
                <ul>
                    <li><code>iterations</code> - Número de iteraciones (default: 1,000,000)</li>
                    <li><code>complexity</code> - Complejidad por iteración (default: 1,000)</li>
                </ul>
                <div class="code-block">
                    # Ejemplo básico<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/heavy-operation.jsp"<br><br>
                    
                    # Alto consumo de CPU<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/heavy-operation.jsp?iterations=5000000&complexity=5000"
                </div>
                <a href="heavy-operation.jsp" class="btn">🔗 Probar Endpoint</a>
            </div>

            <!-- Endpoint 2 -->
            <div class="endpoint-item">
                <h3>2. Fibonacci Calculator</h3>
                <p><strong>URL:</strong> <code>/api/process.jsp?type=fibonacci</code></p>
                <p><strong>Propósito:</strong> Cálculo recursivo de Fibonacci (muy intensivo en CPU)</p>
                <p><strong>Parámetros:</strong></p>
                <ul>
                    <li><code>number</code> - Número para calcular Fibonacci (default: 35)</li>
                </ul>
                <div class="code-block">
                    # Fibonacci intensivo<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/api/process.jsp?type=fibonacci&number=40"<br><br>
                    
                    # Múltiples cálculos<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/api/process.jsp?type=fibonacci&number=45"
                </div>
                <a href="api/process.jsp?type=fibonacci&number=35" class="btn">🔗 Probar Endpoint</a>
            </div>

            <h2>💾 Endpoints de Consumo de Memoria</h2>
            
            <!-- Endpoint 3 -->
            <div class="endpoint-item">
                <h3>3. Memory Allocation</h3>
                <p><strong>URL:</strong> <code>/api/data.jsp</code></p>
                <p><strong>Propósito:</strong> Asignar grandes bloques de memoria</p>
                <p><strong>Parámetros:</strong></p>
                <ul>
                    <li><code>size</code> - Tamaño en MB por objeto (default: 10)</li>
                    <li><code>count</code> - Número de objetos (default: 100)</li>
                </ul>
                <div class="code-block">
                    # Consumo moderado de memoria<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/api/data.jsp?size=50&count=20"<br><br>
                    
                    # Alto consumo de memoria<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/api/data.jsp?size=100&count=50"
                </div>
                <a href="api/data.jsp?size=10&count=5" class="btn">🔗 Probar Endpoint</a>
            </div>

            <!-- Endpoint 4 -->
            <div class="endpoint-item">
                <h3>4. String Processing</h3>
                <p><strong>URL:</strong> <code>/api/process.jsp?type=string</code></p>
                <p><strong>Propósito:</strong> Procesamiento intensivo de strings en memoria</p>
                <p><strong>Parámetros:</strong></p>
                <ul>
                    <li><code>length</code> - Longitud del string (default: 1000000)</li>
                    <li><code>operations</code> - Operaciones a realizar (default: 1000)</li>
                </ul>
                <div class="code-block">
                    # Procesamiento de strings grande<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/api/process.jsp?type=string&length=5000000"<br><br>
                    
                    # Múltiples operaciones<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/api/process.jsp?type=string&operations=10000"
                </div>
                <a href="api/process.jsp?type=string&length=1000000" class="btn">🔗 Probar Endpoint</a>
            </div>

            <h2>🐌 Endpoints de Procesamiento Lento</h2>
            
            <!-- Endpoint 5 -->
            <div class="endpoint-item">
                <h3>5. Slow Processing</h3>
                <p><strong>URL:</strong> <code>/api/process.jsp?type=slow</code></p>
                <p><strong>Propósito:</strong> Simular procesamiento lento con delays</p>
                <p><strong>Parámetros:</strong></p>
                <ul>
                    <li><code>delay</code> - Delay en segundos (default: 5)</li>
                    <li><code>steps</code> - Número de pasos (default: 10)</li>
                </ul>
                <div class="code-block">
                    # Procesamiento muy lento<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/api/process.jsp?type=slow&delay=10&steps=20"<br><br>
                    
                    # Múltiples delays<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/api/process.jsp?type=slow&delay=30"
                </div>
                <a href="api/process.jsp?type=slow&delay=3" class="btn">🔗 Probar Endpoint</a>
            </div>

            <!-- Endpoint 6 -->
            <div class="endpoint-item">
                <h3>6. Load Testing Endpoint</h3>
                <p><strong>URL:</strong> <code>/load-test.jsp</code></p>
                <p><strong>Propósito:</strong> Endpoint configurable para testing de carga</p>
                <p><strong>Parámetros:</strong></p>
                <ul>
                    <li><code>requests</code> - Número de requests internos (default: 100)</li>
                    <li><code>complexity</code> - Complejidad del procesamiento (default: medium)</li>
                    <li><code>delay</code> - Delay entre requests (default: 0)</li>
                </ul>
                <div class="code-block">
                    # Test de carga básico<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/load-test.jsp?requests=1000"<br><br>
                    
                    # Test complejo con delays<br>
                    curl "http://192.168.0.100:8080/ddos-workshop/load-test.jsp?requests=500&complexity=high&delay=100"
                </div>
                <a href="load-test.jsp?requests=100" class="btn">🔗 Probar Endpoint</a>
            </div>
        </div>

        <div style="background: rgba(255,193,7,0.2); padding: 20px; border-radius: 8px; margin: 20px 0;">
            <h3>🎯 Scripts de Prueba Disponibles</h3>
            <div class="code-block">
                # HTTP Flood Attack<br>
                ./scripts/http-flood.sh<br><br>
                
                # DDoS Simulation Completa<br>
                ./scripts/ddos-simulation.sh<br><br>
                
                # Resource Monitoring<br>
                ./scripts/resource-monitor.sh<br><br>
                
                # Slowloris Attack<br>
                python3 ./scripts/slowloris.py
            </div>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <a href="index.jsp" class="btn" style="background: #007bff;">🏠 Volver al Inicio</a>
            <a href="resource-monitor.jsp" class="btn" style="background: #28a745;">📊 Monitor en Tiempo Real</a>
        </div>
    </div>
</body>
</html>