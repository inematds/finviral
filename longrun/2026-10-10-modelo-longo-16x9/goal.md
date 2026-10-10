# Goal — modelo longo 16:9 do finviral (10/10/2026)

Pedido do Nei: sábado e domingo, além do short 9:16, um vídeo LONGO 16:9 (5–7 min) explicando cada influenciador,
para o canal INEMA TIA (lives2). Modelo próprio dentro do finviral, adaptando explicavideo v2 + eventosextremospub,
que sirva para 16:9 e (depois) 9:16 diário. Todo conteúdo finviral → lives2. Entrega continua no bot v3 (Nei publica).

## Pronto quando (nível 3)

1. `python3 motor/gerar_cena_longo.py <ed>` → `cena-longo.js` sem erro; deixa não achada só como aviso.
2. `node motor/render.mjs <ed> --quadros 0,... --palco longo` → quadro 0 cheio (capa com texto), capítulos com tela de nome,
   avatar no canto, legenda numa linha, fonte na tela — conferido olhando a folha.
3. `auto/checar.py <ed> <tx> --longo` passa (trecho literal, números por extenso, "recomendação", CTA).
4. Piloto da semana 03–08/10 com voz chatterbox: 5–7 min, enviado ao bot v3 com o roteiro, ANTES de qualquer HeyGen.
5. Regressão: short semanal/diário continuam gerando igual (`gerar_cena.py` + `palco.html` intocados no comportamento).
6. Só depois do "pode fazer" do Nei: HeyGen do longo + ligar no rodar.sh (sáb/dom), passo não-fatal após o short.
