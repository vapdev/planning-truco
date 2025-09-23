#!/bin/bash

# Script para rebuild com novas variáveis de ambiente
# Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API]

set -e

EC2_IP=${1}
API_PORT=${2:-"8080"}

if [ -z "$EC2_IP" ]; then
    echo "❌ Erro: IP do EC2 é obrigatório"
    echo "Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API]"
    echo "Exemplo: ./rebuild-with-env.sh 54.123.456.789 8080"
    exit 1
fi

echo "🔄 Rebuild com novas variáveis de ambiente"
echo "📍 EC2 IP: $EC2_IP"
echo "🔌 API Port: $API_PORT"

# Parar PM2
echo "🛑 Parando PM2 e liberando porta 3000..."
pm2 stop planning-truco-frontend 2>/dev/null || echo "App não estava rodando no PM2"
pm2 delete planning-truco-frontend 2>/dev/null || echo "App removido do PM2"

# Matar qualquer processo na porta 3000
echo "💀 Liberando porta 3000..."
PIDS=$(lsof -ti :3000 2>/dev/null || echo "")
if [ -n "$PIDS" ]; then
    echo "Matando processos na porta 3000: $PIDS"
    kill -9 $PIDS 2>/dev/null || echo "Alguns processos já estavam mortos"
fi

# Configurar variáveis de ambiente para BUILD TIME
echo "📝 Configurando variáveis de ambiente para build..."
export NUXT_API_BASE=http://$EC2_IP:$API_PORT
export NUXT_WS_BASE=ws://$EC2_IP:$API_PORT

# Criar arquivo .env
cat > .env << EOF
NUXT_API_BASE=http://$EC2_IP:$API_PORT
NUXT_WS_BASE=ws://$EC2_IP:$API_PORT
NODE_ENV=production
HOST=0.0.0.0
PORT=3000
EOF

echo "✅ Arquivo .env atualizado:"
cat .env

# Limpar build anterior
echo "🧹 Limpando build anterior..."
rm -rf .output .nuxt

# Rebuild com as novas variáveis
echo "🔨 Fazendo rebuild com novas variáveis..."
npm run build

# Verificar se build foi bem-sucedido
if [ ! -d ".output" ]; then
    echo "❌ Build falhou!"
    exit 1
fi

# Reiniciar com PM2
echo "🚀 Reiniciando com PM2..."
pm2 start npm --name "planning-truco-frontend" -- run preview

# Salvar configuração
pm2 save

echo "📊 Status:"
pm2 status planning-truco-frontend

echo ""
echo "✅ Rebuild concluído!"
echo "🌐 Aplicação rodando em: http://$EC2_IP:3000"
echo "🔗 API configurada para: http://$EC2_IP:$API_PORT"
echo ""
echo "🧪 Teste no navegador para confirmar que as URLs estão corretas!"
echo ""