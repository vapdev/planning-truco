#!/bin/bash
# Script para rebuild com novas variáveis de ambiente
# Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]

set -e

EC2_IP=${1}
API_PORT=${2:-"8080"}
DOMAIN=${3}

if [ -z "$EC2_IP" ]; then
    echo "❌ Erro: IP do EC2 é obrigatório"
    echo "Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]"
    echo "Exemplo: ./rebuild-with-env.sh 54.123.456.789 8080"
    echo "Exemplo com domínio: ./rebuild-with-env.sh 54.123.456.789 8080 planningpoker.digital"
    echo "  (O script adicionará automaticamente 'www.' se necessário)"
    exit 1
fi

echo "🔄 Rebuild com novas variáveis de ambiente"
echo "📍 EC2 IP: $EC2_IP"
echo "🔌 API Port: $API_PORT"

# Se tiver domínio, usa ele com https; senão, usa o IP com http
if [ -n "$DOMAIN" ]; then
    # Verificar se o domínio já tem www, se não tiver, adicionar
    if [[ "$DOMAIN" == www.* ]]; then
        # Já tem www, usar como está
        API_DOMAIN="$DOMAIN"
    else
        # Não tem www, adicionar
        API_DOMAIN="www.$DOMAIN"
    fi
    
    API_BASE="https://$API_DOMAIN/api"
    WS_BASE="wss://$API_DOMAIN"
    echo "🌐 Usando domínio para API: $API_DOMAIN"
else
    API_BASE="http://$EC2_IP:$API_PORT"
    WS_BASE="ws://$EC2_IP:$API_PORT"
    echo "📍 Usando IP para API: $EC2_IP"
fi

echo "🔗 API configurada para: $API_BASE"

# Parar PM2
echo "🛑 Parando PM2 e liberando porta 3000..."
pm2 stop planning-truco-frontend 2>/dev/null || echo "App não estava rodando no PM2"
pm2 delete planning-truco-frontend 2>/dev/null || echo "App removido do PM2"

# Matar qualquer processo na porta 3000
PIDS=$(lsof -ti :3000 2>/dev/null || echo "")
if [ -n "$PIDS" ]; then
    echo "💀 Matando processos na porta 3000: $PIDS"
    kill -9 $PIDS 2>/dev/null || echo "Alguns processos já estavam mortos"
fi

# Criar arquivo .env
cat > .env << EOF
NUXT_API_BASE=$API_BASE
NUXT_WS_BASE=$WS_BASE
NODE_ENV=production
HOST=0.0.0.0
PORT=3000
NUXT_GTAG_ID=G-VZ3TCRZBPL
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
pm2 save

echo "📊 Status:"
pm2 status planning-truco-frontend

echo ""
echo "✅ Rebuild concluído!"
if [ -n "$DOMAIN" ]; then
    echo "🌐 Aplicação rodando em: https://$API_DOMAIN"
else
    echo "🌐 Aplicação rodando em: http://$EC2_IP:3000"
fi
echo "🔗 API configurada para: $API_BASE"

