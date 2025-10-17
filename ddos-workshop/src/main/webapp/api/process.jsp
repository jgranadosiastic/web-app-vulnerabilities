<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
String type = request.getParameter("type");
if (type == null) type = "default";

response.setContentType("application/json");
long startTime = System.currentTimeMillis();

Map<String, Object> result = new HashMap<>();
result.put("operation_type", type);
result.put("start_time", new Date(startTime).toString());

try {
    switch (type.toLowerCase()) {
        case "fibonacci":
            // Cálculo de Fibonacci (intensivo en CPU)
            String numberParam = request.getParameter("number");
            int n = numberParam != null ? Integer.parseInt(numberParam) : 35;
            
            long fibStart = System.currentTimeMillis();
            long fibonacciResult = fibonacci(n);
            long fibTime = System.currentTimeMillis() - fibStart;
            
            result.put("input_number", n);
            result.put("fibonacci_result", fibonacciResult);
            result.put("calculation_time_ms", fibTime);
            result.put("complexity", "very_high");
            break;
            
        case "string":
            // Procesamiento intensivo de strings
            String lengthParam = request.getParameter("length");
            int length = lengthParam != null ? Integer.parseInt(lengthParam) : 1000000;
            
            String operationsParam = request.getParameter("operations");
            int operations = operationsParam != null ? Integer.parseInt(operationsParam) : 1000;
            
            StringBuilder sb = new StringBuilder();
            Random random = new Random();
            
            for (int i = 0; i < length; i++) {
                sb.append((char) (random.nextInt(26) + 'a'));
            }
            
            String largeString = sb.toString();
            int processedCount = 0;
            
            for (int i = 0; i < operations; i++) {
                largeString = largeString.replace("a", "b");
                largeString = largeString.toUpperCase();
                largeString = largeString.toLowerCase();
                processedCount += largeString.length();
            }
            
            result.put("string_length", length);
            result.put("operations_performed", operations);
            result.put("total_characters_processed", processedCount);
            result.put("memory_used_mb", (largeString.length() * 2) / 1024.0 / 1024.0);
            break;
            
        case "slow":
            // Procesamiento lento con delays
            String delayParam = request.getParameter("delay");
            int delaySeconds = delayParam != null ? Integer.parseInt(delayParam) : 5;
            
            String stepsParam = request.getParameter("steps");
            int steps = stepsParam != null ? Integer.parseInt(stepsParam) : 10;
            
            List<String> progress = new ArrayList<>();
            
            for (int i = 1; i <= steps; i++) {
                Thread.sleep(delaySeconds * 1000L / steps);
                progress.add("Step " + i + " completed at " + new Date());
            }
            
            result.put("total_delay_seconds", delaySeconds);
            result.put("steps_completed", steps);
            result.put("progress", progress);
            break;
            
        default:
            // Operación por defecto
            result.put("status", "default_operation");
            result.put("message", "No specific operation type specified");
            Thread.sleep(1000); // Small delay for default
            break;
    }
    
    result.put("status", "success");
    
} catch (Exception e) {
    result.put("status", "error");
    result.put("error_message", e.getMessage());
}

long totalTime = System.currentTimeMillis() - startTime;
result.put("total_execution_time_ms", totalTime);
result.put("end_time", new Date().toString());

// Convertir a JSON manualmente
%>
{
  "process_result": {
    <% int count = 0; %>
    <% for (Map.Entry<String, Object> entry : result.entrySet()) { %>
      "<%= entry.getKey() %>": 
      <% if (entry.getValue() instanceof String) { %>
        "<%= entry.getValue().toString().replace("\"", "\\\"") %>"
      <% } else if (entry.getValue() instanceof List) { %>
        [<%= String.join(", ", ((List<?>)entry.getValue()).stream()
            .map(item -> "\"" + item.toString().replace("\"", "\\\"") + "\"")
            .toArray(String[]::new)) %>]
      <% } else { %>
        <%= entry.getValue() %>
      <% } %>
      <%= ++count < result.size() ? "," : "" %>
    <% } %>
  }
}

<%!
// Función recursiva de Fibonacci (muy intensiva para números grandes)
private long fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}
%>