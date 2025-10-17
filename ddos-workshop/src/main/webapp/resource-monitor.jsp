<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.lang.management.*" %>
<%
// Métricas en tiempo real
Runtime runtime = Runtime.getRuntime();
long maxMemory = runtime.maxMemory();
long totalMemory = runtime.totalMemory();
long freeMemory = runtime.freeMemory();
long usedMemory = totalMemory - freeMemory;
double memoryUsage = (usedMemory / (double)maxMemory) * 100;

// Simular métricas de sistema (en entorno real usaría MXBeans)
Random random = new Random();
double cpuUsage = random.nextDouble() * 40 + 10; // 10-50%
int activeConnections = random.nextInt(500) + 100;
int requestsPerSecond = random.nextInt(1000) + 500;

// Historial para gráficos
List<Double> cpuHistory = (List<Double>) application.getAttribute("cpuHistory");
List<Double> memoryHistory = (List<Double>) application.getAttribute("memoryHistory");
List<Integer> connectionHistory = (List<Integer>) application.getAttribute("connectionHistory");

if (cpuHistory == null) {
    cpuHistory = new ArrayList<>();
    memoryHistory = new ArrayList<>();
    connectionHistory = new ArrayList<>();
    
    // Inicializar con datos de ejemplo
    for (int i = 0; i < 20; i++) {
        cpuHistory.add(random.nextDouble() * 30 + 10);
        memoryHistory.add(random.nextDouble() * 20 + 30);
        connectionHistory.add(random.nextInt(400) + 100);
    }
    
    application.setAttribute("cpuHistory", cpuHistory);
    application.setAttribute("memoryHistory", memoryHistory);
    application.setAttribute("connectionHistory", connectionHistory);
}

// Actualizar historial (rotar)
cpuHistory.add(cpuUsage);
memoryHistory.add(memoryUsage);
connectionHistory.add(activeConnections);

if (cpuHistory.size() > 30) {
    cpuHistory.remove(0);
    memoryHistory.remove(0);
    connectionHistory.remove(0);
}

// Timestamp
String currentTime = new Date().toString();
%>
<html>
<head>
    <title>Resource Monitor - DDoS Test Lab</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #0f0f23; color: #cccccc; }
        .container { max-width: 1200px; margin: 0 auto; }
        .metrics-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0; }
        .metric-card { background: #1a1a2e; padding: 20px; border-radius: 8px; text-align: center; }
        .metric-value { font-size: 2.5em; font-weight: bold; margin: 10px 0; }
        .metric-cpu { color: #ff6b6b; }
        .metric-memory { color: #4cc9f0; }
        .metric-network { color: #51cf66; }
        .metric-connections { color: #ffd43b; }
        .chart-container { background: #1a1a2e; padding: 20px; border-radius: 8px; margin: 20px 0; }
        .progress-bar { background: #2d3748; border-radius: 10px; overflow: hidden; margin: 10px 0; height: 20px; }
        .progress-fill { height: 100%; border-radius: 10px; }
        .status-normal { color: #51cf66; }
        .status-warning { color: #ffd43b; }
        .status-critical { color: #ff6b6b; }
        .btn { display: inline-block; padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; margin: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Resource Monitor - Tiempo Real</h1>
        <p>Última actualización: <span id="currentTime"><%= currentTime %></span></p>

        <!-- Métricas Principales -->
        <div class="metrics-grid">
            <!-- CPU -->
            <div class="metric-card">
                <h3>⚡ Uso de CPU</h3>
                <div class="metric-value metric-cpu" id="cpuValue"><%= String.format("%.1f", cpuUsage) %>%</div>
                <div class="progress-bar">
                    <div class="progress-fill" id="cpuBar" style="width: <%= cpuUsage %>%; background: linear-gradient(90deg, #ff6b6b, #ff8e8e);"></div>
                </div>
                <div id="cpuStatus" class="status-<%= cpuUsage > 80 ? "critical" : cpuUsage > 60 ? "warning" : "normal" %>">
                    <%= cpuUsage > 80 ? "❌ CRÍTICO" : cpuUsage > 60 ? "⚠️ ALTO" : "✅ NORMAL" %>
                </div>
            </div>

            <!-- Memoria -->
            <div class="metric-card">
                <h3>💾 Memoria JVM</h3>
                <div class="metric-value metric-memory" id="memoryValue"><%= String.format("%.1f", memoryUsage) %>%</div>
                <div class="progress-bar">
                    <div class="progress-fill" id="memoryBar" style="width: <%= memoryUsage %>%; background: linear-gradient(90deg, #4cc9f0, #6dd5fa);"></div>
                </div>
                <div>
                    <span id="memoryUsed"><%= String.format("%.1f", usedMemory / 1024.0 / 1024.0) %></span> MB / 
                    <span id="memoryMax"><%= String.format("%.1f", maxMemory / 1024.0 / 1024.0) %></span> MB
                </div>
            </div>

            <!-- Conexiones -->
            <div class="metric-card">
                <h3>🔗 Conexiones Activas</h3>
                <div class="metric-value metric-connections" id="connectionsValue"><%= activeConnections %></div>
                <div class="progress-bar">
                    <div class="progress-fill" id="connectionsBar" style="width: <%= (activeConnections / 1000.0) * 100 %>%; background: linear-gradient(90deg, #ffd43b, #ffe066);"></div>
                </div>
                <div id="connectionsStatus" class="status-<%= activeConnections > 800 ? "critical" : activeConnections > 600 ? "warning" : "normal" %>">
                    <%= activeConnections > 800 ? "❌ SATURADO" : activeConnections > 600 ? "⚠️ ALTO" : "✅ NORMAL" %>
                </div>
            </div>

            <!-- Requests -->
            <div class="metric-card">
                <h3>📨 Requests/Segundo</h3>
                <div class="metric-value metric-network" id="requestsValue"><%= requestsPerSecond %></div>
                <div class="progress-bar">
                    <div class="progress-fill" id="requestsBar" style="width: <%= (requestsPerSecond / 1500.0) * 100 %>%; background: linear-gradient(90deg, #51cf66, #69db7c);"></div>
                </div>
                <div id="requestsStatus" class="status-<%= requestsPerSecond > 1200 ? "critical" : requestsPerSecond > 800 ? "warning" : "normal" %>">
                    <%= requestsPerSecond > 1200 ? "❌ ALTA CARGA" : requestsPerSecond > 800 ? "⚠️ MODERADA" : "✅ NORMAL" %>
                </div>
            </div>
        </div>

        <!-- Gráficos -->
        <div class="chart-container">
            <h3>📈 Tendencias del Sistema (Últimos 30 puntos)</h3>
            <canvas id="systemChart" width="400" height="200"></canvas>
        </div>

        <!-- Logs de Actividad -->
        <div class="chart-container">
            <h3>📝 Logs de Actividad Reciente</h3>
            <div style="background: #162447; padding: 15px; border-radius: 5px; font-family: monospace; height: 200px; overflow-y: auto;" id="activityLogs">
                <div>[<%= currentTime.substring(11, 19) %>] ✅ Sistema operando normalmente</div>
                <div>[<%= currentTime.substring(11, 19) %>] 🔄 <%= requestsPerSecond %> requests procesados</div>
                <div>[<%= currentTime.substring(11, 19) %>] 💾 Memoria: <%= String.format("%.1f", memoryUsage) %>% utilizada</div>
                <div>[<%= currentTime.substring(11, 19) %>] 🔗 <%= activeConnections %> conexiones activas</div>
                <div>[<%= currentTime.substring(11, 19) %>] ⚡ CPU: <%= String.format("%.1f", cpuUsage) %>% de uso</div>
            </div>
        </div>

        <!-- Controles -->
        <div style="text-align: center; margin-top: 30px;">
            <button onclick="refreshMetrics()" class="btn">🔄 Actualizar Métricas</button>
            <button onclick="startAutoRefresh()" class="btn" style="background: #28a745;">▶️ Auto-Refresh (5s)</button>
            <button onclick="stopAutoRefresh()" class="btn" style="background: #dc3545;">⏹️ Parar Auto-Refresh</button>
            <a href="vulnerable-endpoints.jsp" class="btn">🎯 Endpoints de Prueba</a>
        </div>
    </div>

    <script>
        // Datos para gráficos
        const cpuData = [<%= String.join(", ", cpuHistory.stream().map(d -> String.format("%.1f", d)).toArray(String[]::new)) %>];
        const memoryData = [<%= String.join(", ", memoryHistory.stream().map(d -> String.format("%.1f", d)).toArray(String[]::new)) %>];
        const connectionData = [<%= String.join(", ", connectionHistory.stream().map(d -> d.toString()).toArray(String[]::new)) %>];
        
        let autoRefreshInterval;
        
        // Inicializar gráficos
        const ctx = document.getElementById('systemChart').getContext('2d');
        const systemChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: Array.from({length: cpuData.length}, (_, i) => i + 1),
                datasets: [
                    {
                        label: 'CPU %',
                        data: cpuData,
                        borderColor: '#ff6b6b',
                        backgroundColor: 'rgba(255, 107, 107, 0.1)',
                        tension: 0.4,
                        yAxisID: 'y'
                    },
                    {
                        label: 'Memoria %',
                        data: memoryData,
                        borderColor: '#4cc9f0',
                        backgroundColor: 'rgba(76, 201, 240, 0.1)',
                        tension: 0.4,
                        yAxisID: 'y'
                    },
                    {
                        label: 'Conexiones',
                        data: connectionData,
                        borderColor: '#ffd43b',
                        backgroundColor: 'rgba(255, 212, 59, 0.1)',
                        tension: 0.4,
                        yAxisID: 'y1'
                    }
                ]
            },
            options: {
                responsive: true,
                interaction: {
                    mode: 'index',
                    intersect: false,
                },
                scales: {
                    y: {
                        type: 'linear',
                        display: true,
                        position: 'left',
                        title: {
                            display: true,
                            text: 'Porcentaje (%)'
                        },
                        min: 0,
                        max: 100
                    },
                    y1: {
                        type: 'linear',
                        display: true,
                        position: 'right',
                        title: {
                            display: true,
                            text: 'Conexiones'
                        },
                        min: 0,
                        grid: {
                            drawOnChartArea: false,
                        },
                    }
                }
            }
        });
        
        function refreshMetrics() {
            location.reload();
        }
        
        function startAutoRefresh() {
            autoRefreshInterval = setInterval(refreshMetrics, 5000);
            document.getElementById('activityLogs').innerHTML += '<div>[' + new Date().toLocaleTimeString() + '] 🔄 Auto-refresh activado</div>';
        }
        
        function stopAutoRefresh() {
            if (autoRefreshInterval) {
                clearInterval(autoRefreshInterval);
                document.getElementById('activityLogs').innerHTML += '<div>[' + new Date().toLocaleTimeString() + '] ⏹️ Auto-refresh detenido</div>';
            }
        }
        
        // Actualizar timestamp cada segundo
        setInterval(() => {
            document.getElementById('currentTime').textContent = new Date().toString();
        }, 1000);
    </script>
</body>
</html>