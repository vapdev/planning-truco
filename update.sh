#!/bin/bash

# Script para atualização rápida da aplicação
# Usa as configurações já existentes, apenas atualiza o código e reinicia

set -e

echo "🔄 Atualizando Planning Truco..."

# Verificar se PM2 está instalado
if ! command -v pm2 &> /dev/null; then
    echo "❌ PM2 não encontrado. Execute deploy-pm2.sh primeiro."
    exit 1
fi

# Verificar se a aplicação está rodando
if ! pm2 describe planning-truco-frontend > /dev/null 2>&1; then
    echo "❌ Aplicação não encontrada no PM2. Execute deploy-pm2.sh primeiro."
    exit 1
fi

# Atualizar código
if [ -d ".git" ]; then
    echo "📥 Atualizando código do repositório..."
    git pull origin main
else
    echo "⚠️  Não é um repositório Git. Pulando atualização do código."
fi

# Verificar se houve mudanças no package.json
if git diff HEAD~1 --name-only | grep -q "package.json\|package-lock.json"; then
    echo "📦 Detectadas mudanças nas dependências. Atualizando..."
    npm ci
fi

# Build
echo "🔨 Fazendo novo build..."
npm run build

# Verificar se build foi bem-sucedido  
if [ ! -d ".output" ]; then
    echo "❌ Build falhou!"
    exit 1
fi

# Restart com PM2 (zero-downtime)
echo "🔄 Reiniciando aplicação..."
pm2 reload planning-truco-frontend

# Mostrar status
echo "📊 Status após atualização:"
pm2 status planning-truco-frontend

echo ""
echo "✅ Atualização concluída!"
echo "📊 Para monitorar: pm2 logs planning-truco-frontend"
echo ""