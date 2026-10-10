#!/usr/bin/env bash
# Avatar do Nei pelo ESTÚDIO do HeyGen (assinatura, sem API de geração): envia a fala, espera, baixa e retemporiza.
# uso: motor/avatar_heygen.sh <pasta-da-edicao> <titulo>   -> <ed>/avatar/avatar.mp4 + avatar/tempos.json
# Trava (flock) no perfil do estúdio: outras sessões (explicavideos, eventosextremos) usam o mesmo perfil.
# O script do estúdio recusa oferta de troca de plano (o Nei NUNCA troca de plano).
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"
E="$(cd "$1" && pwd)"; TITULO="$2"
A="$E/avatar"; mkdir -p "$A"
PERFIL="$HOME/.cache/inemaccbot/perfil-heygen"
ENG="$HOME/projetos/explicavideos/engine"
export DISPLAY=:99
python3 -c "import json,sys;print(' '.join(f['fala'] for f in json.load(open(sys.argv[1]))['falas']))" "$E/roteiro.json" > "$A/fala.txt"
{
  flock -w 1800 9 || { echo "ERRO: perfil do HeyGen ocupado há 30 min"; exit 5; }
  cd "$HOME/projetos/explicavideos"
  timeout 900 node "$ENG/heygen-studio.mjs" --titulo "$TITULO" --fala-arquivo "$A/fala.txt" --perfil "$PERFIL" --template TEMPLATE-AVATAR16 > "$A/studio.log" 2>&1 \
    || { echo "ERRO no estúdio: $(grep -h ERRO "$A/studio.log" | tail -1)"; exit 3; }
  ID=$(grep -o 'create-v4/[0-9a-f]\{32\}' "$A/studio.log" | tail -1 | cut -d/ -f2)
  [ -n "$ID" ] || { echo "ERRO: id do vídeo não achado no studio.log"; exit 3; }
  echo "$ID" > "$A/video_id.txt"
  sleep 60
  timeout 9500 node "$ENG/heygen-estudio-baixar.mjs" --id "$ID" --saida "$A/avatar.mp4" --perfil "$PERFIL" --minutos 150 --intervalo 120 > "$A/baixar.log" 2>&1 \
    || { echo "ERRO ao baixar: $(tail -1 "$A/baixar.log")"; exit 4; }
} 9>"$HOME/.cache/inemaccbot/heygen-estudio.lock"
python3 "$AQUI/retempo.py" "$E"
