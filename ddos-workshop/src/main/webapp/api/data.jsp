<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
// Parámetros para controlar el uso de memoria
String sizeParam = request.getParameter("size");
int sizeMB = sizeParam != null ? Integer.parseInt(sizeParam) : 10; // MB por defecto

String countParam = request.getParameter("count");
int objectCount = countParam != null ? Integer.parseInt(countParam) : 100;

response.setContentType("application/json");

long startTime = System.currentTimeMillis();

// Crear objetos grandes para consumir memoria
List<byte[]> memoryBlocks = new ArrayList<>();
long totalMemoryUsed = 0;

for (int i = 0; i < objectCount; i++) {
    // Crear bloque de memoria (1MB = 1024*1024 bytes)
    byte[] block = new byte[sizeMB * 1024 * 1024];
    // Llenar con datos para asegurar que se asigne memoria
    Arrays.fill(block, (byte) (i % 256));
    memoryBlocks.add(block);
    totalMemoryUsed += block.length;
}

// Mantener referencia para evitar GC (simular memory leak)
List<byte[]> storedBlocks = (List<byte[]>) application.getAttribute("memoryBlocks");
if (storedBlocks == null) {
    storedBlocks = new ArrayList<>();
}
storedBlocks.addAll(memoryBlocks);
application.setAttribute("memoryBlocks", storedBlocks);

long endTime = System.currentTimeMillis();
long duration = endTime - startTime;

// Estadísticas
Integer memoryOps = (Integer) application.getAttribute("memoryOperations");
if (memoryOps == null) memoryOps = 0;
memoryOps++;
application.setAttribute("memoryOperations", memoryOps);
%>
{
  "status": "success",
  "operation": "memory_allocation",
  "parameters": {
    "size_mb": <%= sizeMB %>,
    "object_count": <%= objectCount %>
  },
  "results": {
    "total_memory_allocated_mb": <%= totalMemoryUsed / 1024 / 1024 %>,
    "total_objects_created": <%= memoryBlocks.size() %>,
    "execution_time_ms": <%= duration %>,
    "memory_per_second_mb": <%= String.format("%.1f", (totalMemoryUsed / 1024.0 / 1024.0) / (duration / 1000.0)) %>
  },
  "system_stats": {
    "total_memory_operations": <%= memoryOps %>,
    "free_memory_mb": <%= Runtime.getRuntime().freeMemory() / 1024 / 1024 %>,
    "max_memory_mb": <%= Runtime.getRuntime().maxMemory() / 1024 / 1024 %>,
    "total_memory_mb": <%= Runtime.getRuntime().totalMemory() / 1024 / 1024 %>
  },
  "timestamp": "<%= new Date() %>"
}