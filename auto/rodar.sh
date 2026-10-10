#!/usr/bin/env bash
# Rodada automática do finviral: coleta → transcrição → roteiro (claude -p, assinatura) → conferência → avatar → vídeo → bot v3.
# uso: auto/rodar.sh <diario|semanal|domingo> [AAAA-MM-DD da rodada, padrão hoje]
#   diario  = vídeos de ontem e anteontem ainda não usados (40–60 s)
#   semanal = balanço da semana (7 dias até ontem), 90 s a 2 min   [sábado]
# Teste: SEM_AVATAR=1 pula o HeyGen; SEM_BOT=1 só simula o envio.
#   domingo = a semana que passou + o que eles esperam para a próxima, ~90 s   [domingo]
# Sempre manda algo ao bot v3: o vídeo, "sem pauta" ou "falhou em X". O Nei aprova e publica.
set -uo pipefail
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
MODO="${1:?modo: diario|semanal|domingo}"; DIA="${2:-$(date +%F)}"
TX="${TX:-$HOME/projetos/output/finviral/coleta/tx}"
MAXDUR="${MAXDUR:-4500}"   # não transcreve vídeo/live acima de 75 min
BOT="$HOME/projetos/refazvideo/ferramentas/enviar_bot_v3.mjs"
DRY=""; [ "${SEM_BOT:-}" = 1 ] && DRY=--dry-run
ED="$RAIZ/edicoes/$DIA-$MODO"; mkdir -p "$ED/img"
LOG="$ED/rodada.log"; exec >>"$LOG" 2>&1
exec 8>"$RAIZ/auto/.rodando"; flock -n 8 || { echo "outra rodada em andamento"; exit 0; }
echo "=== $(date '+%F %T') $MODO $DIA"
grep -qx "$DIA $MODO" "$RAIZ/auto/pular.txt" 2>/dev/null && { echo "pulado (auto/pular.txt)"; exit 0; }
d() { date -d "$DIA $1 day" +%Y%m%d; }
DATA_BR=$(date -d "$DIA" +%d/%m/%Y)

avisar() {  # manda texto ao bot (como arquivo .txt com legenda) e sai
  echo "$1" > "$ED/aviso.txt"; rm -f "$ED/aviso.txt.envio-v3.json"
  node "$BOT" $DRY "$ED/aviso.txt" "finviral · $MODO · $DATA_BR
$1" || echo "falhou o envio do aviso"
  echo "AVISO: $1"; exit "${2:-1}"
}

case "$MODO" in
  diario)  DE=$(d -2); ATE=$(d -1); MAXV=6
    INSTR="DIÁRIO de $DATA_BR: o que eles publicaram ontem e anteontem. Vídeo de 40 a 60 s, de 5 a 7 falas, de 110 a 150 palavras no total. UMA história principal (o número ou a polêmica mais forte) e no máximo mais um ou dois números. Se só um influenciador publicou algo forte, o vídeo é sobre ele." ;;
  semanal) DE=$(d -7); ATE=$(d -1); MAXV=12
    INSTR="SEMANAL (sábado, $DATA_BR): balanço da semana de $(date -d "$DIA -7 day" +%d/%m) a $(date -d "$DIA -1 day" +%d/%m). Vídeo de 90 s a 2 min, de 9 a 12 falas, de 230 a 300 palavras. Placar da semana: o maior número, quem acertou ou errou, a polêmica, um número de cada influenciador relevante." ;;
  domingo) DE=$(d -7); ATE=$(d -1); MAXV=12
    INSTR="DOMINGO ($DATA_BR): o que esperar da semana que vem, segundo eles. Vídeo de uns 90 s, de 8 a 10 falas, de 190 a 240 palavras. Comece pelo número mais forte da semana que passou e foque nas apostas, nas datas e nos riscos que ELES apontaram para os próximos dias, sempre atribuídos." ;;
  *) echo "modo inválido"; exit 2 ;;
esac

# 1. coleta (metadados) e escolha dos vídeos
python3 "$RAIZ/coleta/listar.py" "$DE" "$ATE" "$ED/todos.tsv" || avisar "falhou a listagem dos canais (yt-dlp)"
USADOS="$RAIZ/auto/usados-diario.txt"; touch "$USADOS"
python3 - "$ED/todos.tsv" "$ED/videos.tsv" "$MODO" "$USADOS" "$MAXDUR" "$MAXV" <<'EOF'
import sys
todos, saida, modo, usados, maxdur, maxv = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], int(sys.argv[5]), int(sys.argv[6])
ja = set(open(usados).read().split()) if modo == "diario" else set()
ls = [l.rstrip("\n").split("\t") for l in open(todos) if l.count("\t") >= 6]
ok = [c for c in ls if c[2] not in ja and c[3].isdigit() and 120 <= int(c[3]) <= maxdur]
ok.sort(key=lambda c: -int(c[4]) if c[4].isdigit() else 0)
por, esc = {}, []
for c in ok:  # até 3 por canal, os mais vistos primeiro
    if por.get(c[0], 0) < 3 and len(esc) < maxv:
        esc.append(c); por[c[0]] = por.get(c[0], 0) + 1
open(saida, "w").write("".join("\t".join(c) + "\n" for c in esc))
print(len(ls), "listados ·", len(esc), "escolhidos")
EOF
[ -s "$ED/videos.tsv" ] || avisar "sem vídeo novo dos canais entre $(date -d "$DE" +%d/%m) e $(date -d "$ATE" +%d/%m)" 0

# 2. transcrição local (inemavox / Whisper) + miniaturas
IDS=$(cut -f3 "$ED/videos.tsv" | tr '\n' ' ')
TX="$TX" systemd-run --user --scope -q -p MemoryMax=40G timeout 7200 bash "$RAIZ/coleta/transcrever.sh" $IDS
: > "$ED/transcritos.txt"
for id in $IDS; do
  [ -s "$TX/$id/transcript.txt" ] && echo "$id" >> "$ED/transcritos.txt"
  [ -s "$ED/img/$id.jpg" ] || curl -sf -m 30 -o "$ED/img/$id.jpg" "https://i.ytimg.com/vi/$id/maxresdefault.jpg" \
    || curl -sf -m 30 -o "$ED/img/$id.jpg" "https://i.ytimg.com/vi/$id/hqdefault.jpg" || true
done
[ -s "$ED/transcritos.txt" ] || avisar "nenhuma transcrição saiu (download ou Whisper falhou)"
cp "$RAIZ/motor/assets/cta.jpg" "$RAIZ/motor/assets/avatar-teste.jpg" "$ED/img/"

# 3. roteiro pelo Claude (assinatura, claude -p) + portão de fatos, com uma correção
PROMPT=$(python3 - "$RAIZ/auto/roteiro.md" "$ED" "$TX" "$RAIZ" "$MODO" "$DATA_BR" "$INSTR" <<'EOF'
import sys
t = open(sys.argv[1]).read()
for k, v in {"{ED}": sys.argv[2], "{TX}": sys.argv[3], "{RAIZ}": sys.argv[4], "{MODO}": sys.argv[5],
             "{DATA}": sys.argv[6], "{DATA_BR}": sys.argv[6], "{INSTRUCAO_MODO}": sys.argv[7]}.items():
    t = t.replace(k, v)
print(t)
EOF
)
roteirizar() {
  ( cd "$ED" && timeout 2400 env -u ANTHROPIC_API_KEY claude -p "$1" --allowedTools "Read,Write,Edit,Glob,Grep" \
      --add-dir "$RAIZ" --add-dir "$TX" --permission-mode acceptEdits > "$ED/claude.log" 2>&1 )
}
rm -f "$ED/SEM_PAUTA.txt" "$ED/roteiro.json" "$ED/base.md"
roteirizar "$PROMPT" || avisar "o claude -p falhou ao escrever o roteiro ($(tail -c 200 "$ED/claude.log"))"
[ -f "$ED/SEM_PAUTA.txt" ] && avisar "sem pauta: $(cat "$ED/SEM_PAUTA.txt")" 0
if ! python3 "$RAIZ/auto/checar.py" "$ED" "$TX" > "$ED/checar.log"; then
  roteirizar "$PROMPT

## CORREÇÃO
A conferência automática reprovou os arquivos que você gravou. Corrija só o que está abaixo, reescrevendo base.md e roteiro.json. Trecho é cópia literal do transcript; número na fala vai por extenso.
$(cat "$ED/checar.log")" || true
  python3 "$RAIZ/auto/checar.py" "$ED" "$TX" > "$ED/checar.log" || avisar "roteiro reprovado na conferência de fatos:
$(grep PROBLEMA "$ED/checar.log" | head -5)"
fi
cat "$ED/checar.log"

# 4. avatar do Nei (HeyGen estúdio); se falhar, versão com a foto e a voz do Nei (chatterbox)
NOTA=""
if [ "${SEM_AVATAR:-}" != 1 ] && bash "$RAIZ/motor/avatar_heygen.sh" "$ED" "FINVIRAL-$DIA-$MODO" > "$ED/avatar.log" 2>&1 \
   && python3 "$RAIZ/motor/gerar_cena.py" "$ED" --avatar && bash "$RAIZ/motor/compor_avatar.sh" "$ED" "$ED/video.mp4"; then
  echo "vídeo com avatar ok"
else
  if [ "${SEM_AVATAR:-}" = 1 ]; then NOTA="(teste sem avatar)"; else NOTA="(sem avatar: $(grep -h ERRO "$ED/avatar.log" 2>/dev/null | tail -1 | cut -c1-150); versão com foto)"; fi
  echo "avatar falhou $NOTA"
  python3 "$RAIZ/motor/narrar.py" "$ED" 1.12 && python3 "$RAIZ/motor/gerar_cena.py" "$ED" --livre \
    && bash "$RAIZ/motor/montar.sh" "$ED" "$ED/video.mp4" || avisar "falhou também a versão com foto (ver $LOG)"
fi

# 5. envio ao bot v3 (o Nei aprova e publica)
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$ED/video.mp4" | cut -d. -f1)
SUG=""; [ -s "$ED/sugestao.txt" ] && SUG="
Sugestão de influenciador: $(head -c 300 "$ED/sugestao.txt")"
node "$BOT" $DRY "$ED/video.mp4" "finviral · $MODO · $DATA_BR · ${DUR}s $NOTA
$(head -c 700 "$ED/legenda.txt")$SUG" || avisar "vídeo pronto em $ED/video.mp4 mas o envio ao bot falhou"
[ "$MODO" = diario ] && [ -z "$DRY" ] && cut -f3 "$ED/videos.tsv" >> "$USADOS"
echo "=== fim $(date '+%F %T')"
