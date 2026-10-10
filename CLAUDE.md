# CLAUDE.md — finviral

Conta/autor: `inematds <inematds@gmail.com>`, repo `inematds/finviral`. Fluxo e agenda: README.md. Base de cada edição: `edicoes/<ed>/base.md`.

- Agenda (systemd usuário, `systemd/`): diário seg–sex 02:00, semanal sáb 02:00, domingo dom 02:00 → `auto/rodar.sh <modo>`; entrega SEMPRE no bot v3 (vídeo, "sem pauta" ou "falhou"); o Nei aprova e publica. Avulso: o Nei pode pedir a qualquer hora (`auto/rodar.sh <modo> <data>` ou edição à mão).
- Influenciadores em `canais.json`; o Nei inclui/exclui. Eu posso SUGERIR (no bot) nome em destaque, consolidado e confiável — nunca emergente; só entra com ok dele.
- Coleta só por yt-dlp (metadados) + inemavox (áudio e Whisper local). Roteiro por `claude -p` (assinatura). Sem API paga.
- Avatar: HeyGen pelo ESTÚDIO (assinatura, `motor/avatar_heygen.sh`), autorizado pelo Nei para a rotina (09/10/2026). Oferta de troca de plano do HeyGen: SEMPRE recusar, nunca aceitar.
- Todo número precisa de trecho literal no base.md (`auto/checar.py`); política relatada e atribuída, sem tomar lado; "não é recomendação de investimento".

## Self-learning

When I correct you, or you catch yourself making a mistake: before continuing, add the lesson as a one-line rule under ## Lessons, so it never happens again.

## Lessons

- No palco.html, função global não pode se chamar `render`: `window.render=` sobrescreve a declaração e entra em recursão infinita (usar `desenhar`). (09/10/2026)
- Âncora `"em"` do roteiro casa com a transcrição do Whisper, que escreve números em algarismos ("7 ,7", "750", ".360"): ancorar em algarismo ou em palavra comum. (09/10/2026)
- O conferidor de voz do cardshorts reprova "dois e meio por cento" (ouve "2,5%"): escrever "dois vírgula cinco". "XP" sai "Xipe": escrever "xis pê". (09/10/2026)
- HeyGen passou a exigir "voice engine" na voz INEMA TIME (09/10, ~21h): o "Gerar" não abria o modal e o script dizia só "sem Enviar". O heygen-studio.mjs agora mostra o texto do aviso no erro; o Nei ajusta a voz no estúdio. (09/10/2026)
- Citação no quadro e no base.md = literal do transcript ("se, por exemplo, Lula ganhar", não "Se o Lula ganhar"); o `auto/checar.py` reprova paráfrase. (09/10/2026)
