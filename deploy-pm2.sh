#!/bin/bash

# Deploy Planning Truco Frontend com PM2
# Uso: ./deploy-pm2.sh [IP_DO_EC2] [PORTA_API]

set -e

EC2_IP=${1}
API_PORT=${2:-"8080"}

if [ -z "$EC2_IP" ]; then
    echo "❌ Erro: IP do EC2 é obrigatório"
    echo "Uso: ./deploy-pm2.sh [IP_DO_EC2] [PORTA_API]"
    echo "Exemplo: ./deploy-pm2.sh 54.123.456.789 8080"
    exit 1
fi

echo "🚀 Deploy Planning Truco com PM2"
echo "📍 EC2 IP: $EC2_IP"
echo "🔌 API Port: $API_PORT"

# Verificar se PM2 está instalado
if ! command -v pm2 &> /dev/null; then
    echo "📦 PM2 não encontrado. Instalando..."
    npm install -g pm2
fi

# Parar aplicação se estiver rodando
echo "🛑 Parando aplicação existente..."
pm2 stop planning-truco-frontend 2>/dev/null || echo "Aplicação não estava rodando"
pm2 delete planning-truco-frontend 2>/dev/null || echo "Aplicação removida"

# Atualizar código (se em produção)
if [ -d ".git" ]; then
    echo "📥 Atualizando código..."
    git pull origin main
fi

# Configurar variáveis de ambiente
echo "📝 Configurando variáveis de ambiente..."
cat > .env << EOF
# Configuração para EC2 com PM2
NUXT_API_BASE=http://$EC2_IP:$API_PORT
NUXT_WS_BASE=ws://$EC2_IP:$API_PORT
NODE_ENV=production
HOST=0.0.0.0
PORT=3000

# Google Analytics (opcional)
NUXT_GTAG_ID=
EOF

# Instalar/atualizar dependências
echo "📦 Instalando dependências..."
npm ci

# Build para produção
echo "🔨 Fazendo build para produção..."
npm run build

# Verificar se build foi bem-sucedido
if [ ! -d ".output" ]; then
    echo "❌ Build falhou!"
    exit 1
fi

# Iniciar com PM2
echo "🚀 Iniciando aplicação com PM2..."

# Opção 1: Usar ecosystem.config.json
if [ -f "ecosystem.config.json" ]; then
    # Atualizar path no ecosystem.config.json
    sed -i "s|/home/ubuntu/planning-truco|$(pwd)|g" ecosystem.config.json
    pm2 start ecosystem.config.json --env production
else
    # Opção 2: Comando direto
    pm2 start npm --name "planning-truco-frontend" -- run preview
fi

# Salvar configuração PM2
pm2 save

# Configurar auto-start no boot (só precisa fazer uma vez)
echo "⚙️  Configurando auto-start..."
pm2 startup || echo "Auto-start já configurado ou erro na configuração"

# Mostrar status
echo "📊 Status da aplicação:"
pm2 status

echo ""
echo "✅ Deploy concluído com sucesso!"
echo ""
echo "📋 Informações importantes:"
echo "   🌐 URL: http://$EC2_IP:3000"
echo "   📱 API: http://$EC2_IP:$API_PORT"
echo ""
echo "🔧 Comandos úteis do PM2:"
echo "   pm2 status                    # Ver status de todos os processos"
echo "   pm2 logs planning-truco-frontend  # Ver logs em tempo real"
echo "   pm2 restart planning-truco-frontend # Reiniciar aplicação"
echo "   pm2 stop planning-truco-frontend    # Parar aplicação"
echo "   pm2 delete planning-truco-frontend  # Remover do PM2"
echo "   pm2 monit                     # Monitor interativo"
echo ""
echo "📊 Para monitorar:"
echo "   pm2 logs --lines 50           # Últimas 50 linhas de log"
echo "   pm2 show planning-truco-frontend  # Detalhes do processo"
echo ""