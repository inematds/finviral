# Canal — modelo-longo-16x9 (só acrescentar; nunca reescrever)

Conhecimento do projeto que a compactação perde: fatos descobertos, aprendizados, glossário, armadilhas, onde estão as coisas.
Não é estado da tarefa (isso vai em state/plan/progress). Preencha cedo — o hook avisa na faixa 1 (~50% do contexto).

Formato: `- AAAA-MM-DD HH:MM · fato|aprendizado|glossário|armadilha · texto`


## 10/10 ~04:10 — saudeviral (projeto irmão)
- `~/projetos/saudeviral` = rsync do finviral adaptado para saúde (repo inematds/saudeviral, guia no ar, portal ac6eb88). Canal lives12 (Inema Pro), timers 05:00 (finviral 02:00), títulos HeyGen `SAUDEVIRAL-`. JS do longo renomeado `motor/v2/saudeviral-v2.js`.
- Piloto diario 10/10 (SEM_AVATAR/SEM_BOT) passou na 1ª conferência; o longo do saudeviral ainda não rodou (1ª vez: semanal 10/10 05:00).
- Armadilha: `handle` em canais.json pode ser `channel/UC...` (o listar.py monta `youtube.com/{handle}/videos`). Canais com ~2 vídeos/dia → semanal lista 16 por canal (NLISTA).
