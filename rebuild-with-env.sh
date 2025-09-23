#!/bin/bash



# Script para rebuild com novas variáveis de ambiente# Script para rebuild com novas variáveis de ambiente

# Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]# Uso: ./rebuild-with-envecho ""

echo "✅ Rebuild concluído!"

set -eecho "🌐 Aplicação rodando em: http://$EC2_IP:3000"

echo "🔗 API configurada para: $API_BASE"

EC2_IP=${1}echo ""IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]

API_PORT=${2:-"8080"}

DOMAIN=${3}  # Novo parâmetro opcionalset -e



if [ -z "$EC2_IP" ]; thenEC2_IP=${1}

    echo "❌ Erro: IP do EC2 é obrigatório"API_PORT=${2:-"8080"}

    echo "Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]"DOMAIN=${3}  # Novo parâmetro opcional

    echo "Exemplo: ./rebuild-with-env.sh 54.123.456.789 8080"

    echo "Exemplo com domínio: ./rebuild-with-env.sh 54.123.456.789 8080 planningpoker.digital"if [ -z "$EC2_IP" ]; then

    exit 1    echo "❌ Erro: IP do EC2 é obrigatório"

fi    echo "Uso: ./rebuild-with-env.sh [IP_DO_EC2] [PORTA_API] [DOMAIN_OPCIONAL]"

    echo "Exemplo: ./rebuild-with-env.sh 54.123.456.789 8080"

echo "🔄 Rebuild com novas variáveis de ambiente"    echo "Exemplo com domínio: ./rebuild-with-env.sh 54.123.456.789 8080 meudominio.com"

echo "📍 EC2 IP: $EC2_IP"    exit 1

echo "🔌 API Port: $API_PORT"fi

if [ -n "$DOMAIN" ]; then

    echo "🌐 Domain: $DOMAIN"echo "🔄 Rebuild com novas variáveis de ambiente"

fiecho "📍 EC2 IP: $EC2_IP"

echo "🔌 API Port: $API_PORT"

# Parar PM2if [ -n "$DOMAIN" ]; then

echo "🛑 Parando PM2 e liberando porta 3000..."    echo "🌐 Domain: $DOMAIN"

pm2 stop planning-truco-frontend 2>/dev/null || echo "App não estava rodando no PM2"fi

pm2 delete planning-truco-frontend 2>/dev/null || echo "App removido do PM2"

# Parar PM2

# Matar qualquer processo na porta 3000echo "🛑 Parando PM2 e liberando porta 3000..."

echo "💀 Liberando porta 3000..."pm2 stop planning-truco-frontend 2>/dev/null || echo "App não estava rodando no PM2"

PIDS=$(lsof -ti :3000 2>/dev/null || echo "")pm2 delete planning-truco-frontend 2>/dev/null || echo "App removido do PM2"

if [ -n "$PIDS" ]; then

    echo "Matando processos na porta 3000: $PIDS"# Matar qualquer processo na porta 3000

    kill -9 $PIDS 2>/dev/null || echo "Alguns processos já estavam mortos"echo "💀 Liberando porta 3000..."

fiPIDS=$(lsof -ti :3000 2>/dev/null || echo "")

if [ -n "$PIDS" ]; then

# Configurar variáveis de ambiente para BUILD TIME    echo "Matando processos na porta 3000: $PIDS"

echo "📝 Configurando variáveis de ambiente para build..."    kill -9 $PIDS 2>/dev/null || echo "Alguns processos já estavam mortos"

fi

# Usar domínio se fornecido, senão usar IP

if [ -n "$DOMAIN" ]; then# Configurar variáveis de ambiente para BUILD TIME

    API_BASE="http://$DOMAIN:$API_PORT"echo "📝 Configurando variáveis de ambiente para build..."

    WS_BASE="ws://$DOMAIN:$API_PORT"

    echo "🌐 Usando domínio para API: $DOMAIN"# Usar domínio se fornecido, senão usar IP

elseif [ -n "$DOMAIN" ]; then

    API_BASE="http://$EC2_IP:$API_PORT"    API_BASE="http://$DOMAIN:$API_PORT"

    WS_BASE="ws://$EC2_IP:$API_PORT"    WS_BASE="ws://$DOMAIN:$API_PORT"

    echo "📍 Usando IP para API: $EC2_IP"    echo "🌐 Usando domínio para API: $DOMAIN"

fielse

    API_BASE="http://$EC2_IP:$API_PORT"

export NUXT_API_BASE=$API_BASE    WS_BASE="ws://$EC2_IP:$API_PORT"

export NUXT_WS_BASE=$WS_BASE    echo "📍 Usando IP para API: $EC2_IP"

fi

# Criar arquivo .env

cat > .env << EOFexport NUXT_API_BASE=$API_BASE

NUXT_API_BASE=$API_BASEexport NUXT_WS_BASE=$WS_BASE

NUXT_WS_BASE=$WS_BASE

NODE_ENV=production# Criar arquivo .env

HOST=0.0.0.0cat > .env << EOF

PORT=3000NUXT_API_BASE=$API_BASE

EOFNUXT_WS_BASE=$WS_BASE

NODE_ENV=production

echo "✅ Arquivo .env atualizado:"HOST=0.0.0.0

cat .envPORT=3000

EOF

# Limpar build anterior

echo "🧹 Limpando build anterior..."echo "✅ Arquivo .env atualizado:"

rm -rf .output .nuxtcat .env



# Rebuild com as novas variáveis# Limpar build anterior

echo "🔨 Fazendo rebuild com novas variáveis..."echo "🧹 Limpando build anterior..."

npm run buildrm -rf .output .nuxt



# Verificar se build foi bem-sucedido# Rebuild com as novas variáveis

if [ ! -d ".output" ]; thenecho "🔨 Fazendo rebuild com novas variáveis..."

    echo "❌ Build falhou!"npm run build

    exit 1

fi# Verificar se build foi bem-sucedido

if [ ! -d ".output" ]; then

# Reiniciar com PM2    echo "❌ Build falhou!"

echo "🚀 Reiniciando com PM2..."    exit 1

pm2 start npm --name "planning-truco-frontend" -- run previewfi



# Salvar configuração# Reiniciar com PM2

pm2 saveecho "🚀 Reiniciando com PM2..."

pm2 start npm --name "planning-truco-frontend" -- run preview

echo "📊 Status:"

pm2 status planning-truco-frontend# Salvar configuração

pm2 save

echo ""

echo "✅ Rebuild concluído!"echo "📊 Status:"

echo "🌐 Aplicação rodando em: http://$EC2_IP:3000"pm2 status planning-truco-frontend

echo "🔗 API configurada para: $API_BASE"

echo ""echo ""

echo "🧪 Teste no navegador para confirmar que as URLs estão corretas!"echo "✅ Rebuild concluído!"

echo ""echo "🌐 Aplicação rodando em: http://$EC2_IP:3000"

echo "💡 Para usar com o domínio planningpoker.digital:"echo "🔗 API configurada para: http://$EC2_IP:$API_PORT"

echo "   ./rebuild-with-env.sh $EC2_IP $API_PORT planningpoker.digital"echo ""

echo ""echo "🧪 Teste no navegador para confirmar que as URLs estão corretas!"
echo ""