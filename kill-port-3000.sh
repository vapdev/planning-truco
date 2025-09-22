#!/bin/bash

# Script para matar processos na porta 3000
# Uso: ./kill-port-3000.sh

set -e

PORT=3000

echo "🔍 Verificando processos na porta $PORT..."

# Encontrar PIDs usando a porta
PIDS=$(lsof -ti :$PORT 2>/dev/null || echo "")

if [ -z "$PIDS" ]; then
    echo "✅ Nenhum processo encontrado na porta $PORT"
else
    echo "📋 Processos encontrados na porta $PORT:"
    lsof -i :$PORT 2>/dev/null || echo "Erro ao listar processos detalhados"
    
    echo ""
    echo "💀 Matando processos..."
    
    # Tentar matar gentilmente primeiro (SIGTERM)
    for pid in $PIDS; do
        echo "🔫 Enviando SIGTERM para PID $pid..."
        kill $pid 2>/dev/null || echo "⚠️  Não foi possível enviar SIGTERM para PID $pid"
    done
    
    # Aguardar um pouco
    sleep 2
    
    # Verificar se ainda há processos
    REMAINING_PIDS=$(lsof -ti :$PORT 2>/dev/null || echo "")
    
    if [ -n "$REMAINING_PIDS" ]; then
        echo "⚡ Alguns processos ainda estão rodando. Forçando com SIGKILL..."
        for pid in $REMAINING_PIDS; do
            echo "💥 Enviando SIGKILL para PID $pid..."
            kill -9 $pid 2>/dev/null || echo "⚠️  Não foi possível enviar SIGKILL para PID $pid"
        done
    fi
    
    # Verificação final
    sleep 1
    FINAL_CHECK=$(lsof -ti :$PORT 2>/dev/null || echo "")
    
    if [ -z "$FINAL_CHECK" ]; then
        echo "✅ Porta $PORT liberada com sucesso!"
    else
        echo "❌ Alguns processos ainda estão na porta $PORT:"
        lsof -i :$PORT 2>/dev/null || echo "Erro na verificação final"
    fi
fi

echo ""
echo "🔍 Status final da porta $PORT:"
netstat -tulpn 2>/dev/null | grep :$PORT || echo "Porta $PORT está livre"
echo ""