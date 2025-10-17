#!/bin/bash

# Resource Monitor for DDoS Testing

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
INTERVAL=2
DURATION=300  # 5 minutos por defecto

show_metrics() {
    clear
    echo -e "${BLUE}📊 DDoS Test Lab - Resource Monitor${NC}"
    echo "=========================================="
    
    # CPU Usage
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    echo -e "⚡ CPU Usage: $(printf "%-6s" "$cpu_usage")% | $(progress_bar $cpu_usage)"
    
    # Memory Usage
    local mem_info=$(free -m | grep Mem)
    local mem_total=$(echo $mem_info | awk '{print $2}')
    local mem_used=$(echo $mem_info | awk '{print $3}')
    local mem_percent=$((mem_used * 100 / mem_total))
    echo -e "💾 Memory:    $(printf "%-6s" "$mem_percent")% | $(progress_bar $mem_percent) [${mem_used}M/${mem_total}M]"
    
    # Disk I/O
    local disk_io=$(iostat -d 1 1 | grep -A1 Device | tail -1 | awk '{print $2}')
    echo -e "💽 Disk I/O:  $(printf "%-6s" "$disk_io") tps"
    
    # Network Connections
    local connections=$(netstat -an | grep -c ESTABLISHED)
    echo -e "🔗 Connections: $connections establecidas"
    
    # Tomcat-specific metrics (si está disponible)
    if pgrep -f tomcat > /dev/null; then
        local tomcat_threads=$(ps -L -p $(pgrep -f tomcat) | wc -l)
        echo -e "🐈 Tomcat Threads: $((tomcat_threads - 1))"
    fi
    
    # Java Memory (si es aplicación Java)
    if pgrep -f java > /dev/null; then
        local java_pid=$(pgrep -f java | head -1)
        if [ ! -z "$java_pid" ]; then
            local java_mem=$(ps -o rss= -p $java_pid | awk '{printf "%.1f", $1/1024}')
            echo -e "☕ Java RSS: ${java_mem}M"
        fi
    fi
    
    # Requests en curso
    local curl_processes=$(pgrep -c curl 2>/dev/null || echo 0)
    echo -e "📨 Active Requests: $curl_processes"
    
    echo "=========================================="
    echo -e "${YELLOW}Monitoreando cada ${INTERVAL}s | Ctrl+C para salir${NC}"
}

progress_bar() {
    local percent=$1
    local bars=$((percent / 2))
    local spaces=$((50 - bars))
    
    local color=$GREEN
    if [ $percent -gt 80 ]; then
        color=$RED
    elif [ $percent -gt 60 ]; then
        color=$YELLOW
    fi
    
    printf "${color}["
    printf "%0.s#” $(seq 1 $bars)
    printf "%0.s " $(seq 1 $spaces)
    printf "]${NC}"
}

log_metrics() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local mem_info=$(free -m | grep Mem)
    local mem_total=$(echo $mem_info | awk '{print $2}')
    local mem_used=$(echo $mem_info | awk '{print $3}')
    local mem_percent=$((mem_used * 100 / mem_total))
    local connections=$(netstat -an | grep -c ESTABLISHED)
    
    echo "$timestamp,$cpu_usage,$mem_percent,$connections" >> ddos_metrics.csv
}

setup_monitoring() {
    echo -e "${GREEN}🔄 Iniciando DDoS Resource Monitor${NC}"
    echo "Tiempo,CPU%,Memoria%,Conexiones" > ddos_metrics.csv
    echo -e "${YELLOW}Los datos se guardan en: ddos_metrics.csv${NC}"
    echo -e "${YELLOW}Presiona Ctrl+C para detener el monitoreo${NC}"
    echo
}

main() {
    setup_monitoring
    
    local start_time=$(date +%s)
    
    # Trap para limpiar al salir
    trap 'echo -e "\n${GREEN}📈 Monitoreo detenido. Datos en: ddos_metrics.csv${NC}"; exit 0' INT
    
    while true; do
        show_metrics
        log_metrics
        
        # Verificar si ha pasado el tiempo máximo
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        if [ $elapsed -ge $DURATION ]; then
            echo -e "\n${YELLOW}⏰ Tiempo máximo de monitoreo alcanzado${NC}"
            break
        fi
        
        sleep $INTERVAL
    done
    
    echo -e "${GREEN}📊 Resumen final guardado en: ddos_metrics.csv${NC}"
}

# Ejecutar
main