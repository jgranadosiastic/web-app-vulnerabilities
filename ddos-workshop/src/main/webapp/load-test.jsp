<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
// Parámetros configurables
String requestsParam = request.getParameter("requests");
int numRequests = requestsParam != null ? Integer.parseInt(requestsParam) : 100;

String complexityParam = request.getParameter("complexity");
String complexity = complexityParam != null ? complexityParam : "medium";

String delayParam = request.getParameter("delay");
int delayMs = delayParam != null ? Integer.parseInt(delayParam) : 0;

response.setContentType("application/json");

long startTime = System.currentTimeMillis();
Random random = new Random();
List<Map<String, Object>> results = new ArrayList<>();

// Ejecutar los requests según la complejidad
for (int i = 0; i < numRequests; i++) {
    Map<String, Object> requestResult = new HashMap<>();
    requestResult.put("request_id", i + 1);
    requestResult.put("start_time", System.currentTimeMillis());
    
    // Simular procesamiento según complejidad
    switch (complexity.toLowerCase()) {
        case "high":
            // Alta complejidad - cálculos intensivos
            double result = 0;
            for (int j = 0; j < 10000; j++) {
                result += Math.sin(random.nextDouble()) * Math.cos(random.nextDouble());
            }
            requestResult.put("complexity", "high");
            requestResult.put("calculation_result", result);
            break;
            
        case "medium":
            // Complejidad media
            StringBuilder sb = new StringBuilder();
            for (int j = 0; j < 1000; j++) {
                sb.append((char) (random.nextInt(26) + 'a'));
            }
            requestResult.put("complexity", "medium");
            requestResult.put("string_processed", sb.toString().length());
            break;
            
        default:
            // Baja complejidad
            requestResult.put("complexity", "low");
            requestResult.put("random_value", random.nextDouble());
            break;
    }
    
    // Aplicar delay si se especifica
    if (delayMs > 0) {
        try {
            Thread.sleep(delayMs);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
    
    requestResult.put("end_time", System.currentTimeMillis());
    requestResult.put("duration_ms", System.currentTimeMillis() - (Long)requestResult.get("start_time"));
    
    results.add(requestResult);
}

long totalDuration = System.currentTimeMillis() - startTime;

// Estadísticas
Integer loadTests = (Integer) application.getAttribute("loadTests");
if (loadTests == null) loadTests = 0;
loadTests++;
application.setAttribute("loadTests", loadTests);
%>
{
  "load_test": {
    "parameters": {
      "total_requests": <%= numRequests %>,
      "complexity_level": "<%= complexity %>",
      "delay_per_request_ms": <%= delayMs %>,
      "timestamp": "<%= new Date() %>"
    },
    "results": {
      "total_duration_ms": <%= totalDuration %>,
      "requests_per_second": <%= String.format("%.2f", numRequests / (totalDuration / 1000.0)) %>,
      "average_request_time_ms": <%= String.format("%.2f", totalDuration / (double)numRequests) %>,
      "total_requests_processed": <%= results.size() %>
    },
    "system_metrics": {
      "free_memory_mb": <%= Runtime.getRuntime().freeMemory() / 1024 / 1024 %>,
      "total_load_tests": <%= loadTests %>,
      "active_threads": <%= Thread.activeCount() %>
    },
    "request_details": [
      <% for (int i = 0; i < Math.min(results.size(), 10); i++) { %>
        {
          "request_id": <%= results.get(i).get("request_id") %>,
          "duration_ms": <%= results.get(i).get("duration_ms") %>,
          "complexity": "<%= results.get(i).get("complexity") %>"
        }<%= i < Math.min(results.size() - 1, 9) ? "," : "" %>
      <% } %>
    ]
  }
}