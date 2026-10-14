# CLAUDE.md — finviral

Conta/autor: `inematds <inematds@gmail.com>`, repo `inematds/finviral`. Fluxo e agenda: README.md. Base de cada edição: `edicoes/<ed>/base.md`.

- Agenda (systemd usuário, `systemd/`): diário seg–sex 02:00, semanal sáb 02:00, domingo dom 02:00 → `auto/rodar.sh <modo>`. Desde 10/10/2026 (Nei: "pode sempre criar direto com o avatar … publicar … e sempre manda para o bot também"): sai SEMPRE com o avatar HeyGen, é PUBLICADO no YouTube INEMA TIA (lives2) por `auto/publicar.sh` (yt-pubx) e vai SEMPRE ao bot v3 com o link. Versão com foto (avatar falhou) só vai ao bot. Avulso: o Nei pode pedir a qualquer hora (`auto/rodar.sh <modo> <data>` ou edição à mão).
- Influenciadores em `canais.json`; o Nei inclui/exclui. Eu posso SUGERIR (no bot) nome em destaque, consolidado e confiável — nunca emergente; só entra com ok dele.
- Coleta só por yt-dlp (metadados) + inemavox (áudio e Whisper local). Roteiro por `claude -p` (assinatura). Sem API paga.
- Avatar: HeyGen pelo ESTÚDIO (assinatura, `motor/avatar_heygen.sh`), autorizado pelo Nei para a rotina (09/10/2026), inclusive o longo (10/10). O estúdio aceita até 4500 caracteres por vídeo: o script divide em blocos de ≤4000 e emenda. Oferta de troca de plano do HeyGen: SEMPRE recusar, nunca aceitar.
- Canal: TODO conteúdo do finviral vai para o **INEMA TIA (lives2)** no YouTube (Nei, 10/10/2026).
- Sábado e domingo: além do curto 9:16, o LONGO 16:9 "A semana explicada" (5–7 min, um capítulo por influenciador): `auto/roteiro-longo.md` → `auto/checar.py --longo` → `motor/gerar_cena_longo.py` → `motor/compor_longo.sh` (palco `motor/longo.html` = cenas do explicavideo v2 copiadas em `motor/v2/` + peças de finanças `motor/v2/finviral-v2.js`).
- Todo número precisa de trecho literal no base.md (`auto/checar.py`); política relatada e atribuída, sem tomar lado; "não é recomendação de investimento".

## Self-learning

When I correct you, or you catch yourself making a mistake: before continuing, add the lesson as a one-line rule under ## Lessons, so it never happens again.

## Lessons

- Curto = RESUMO DOS DEZ com pelo menos 5 assuntos (um por influenciador sempre que der), 2–3 min, 14–20 falas, até 420 palavras; cada assunto continua inteiro (contexto, o que ele disse, o que muda pra quem assiste) e termo técnico explicado na fala. Substitui o "no máximo 3 assuntos" de 10/10: o Nei pediu em 13/10/2026; o portão conta os vídeos distintos do base.md (MIN_ASSUNTOS).
- Viradas (Nei, 14/10/2026): 1 s de cartão "ASSUNTO n DE N" antes de cada assunto e antes da pergunta, com a voz parada (gerar_cena.py abre o buraco e grava respiros.json; motor/respiros.py faz o mesmo no áudio/avatar). Fala sem ficha nem número leva manchete no topo; sem caixa, o lado do avatar mostra o índice do radar.
- Quadro 0: o rosto do Nei ocupa toda a parte de baixo (1080x720 em y=1200, sem moldura) até o fim da 1ª fala; depois o quadro padrão (palco.html + compor_avatar.sh). (13/10/2026)
- gov.br na fala = "gov bê érre", sem "ponto" ("consumidor gov bê érre"); o checar.py reprova "ponto gov". O avatar leu "consumidor ponto gov ponto bê erre" no advviral de 13/10 e o Nei reprovou. (13/10/2026)
- Tratar por "você" (nunca "tu/teu/ti/te prepara") e CTA SEMPRE só o inema.club — nada de "segue o canal", vídeo longo ou canal do YouTube; o portão (checar.py / rodar.sh) reprova. (Nei, 11/10/2026)
- Motor do curto: f1 com hero não leva numero/ficha/caixa (ficava número sobre número); o numero entra no início da fala e fica até o próximo visual (senão a parte de cima fica vazia); legenda cola número partido pelo Whisper ("7 ,7 %" → "7,7%"). (11/10/2026)
- Cadeia longa (HeyGen + render + publicação) disparada à mão vai por `systemd-run --user --unit …` (sobrevive ao terminal; linger ligado), nunca como background da sessão: em 10/10 o piloto rodava preso à sessão e o Nei quis sair. O `avatar_heygen.sh` retoma sem reenviar (reaproveita `video_id-bN.txt`). (10/10/2026)

- Legenda palavra a palavra: bloco por TAMANHO (≤18 letras), não por contagem de palavras, e conferir o maior bloco num frame antes de entregar; palavra da legenda vem do roteiro, o Whisper erra nome próprio ("Ambima"). (10/10/2026)

- No palco.html, função global não pode se chamar `render`: `window.render=` sobrescreve a declaração e entra em recursão infinita (usar `desenhar`). (09/10/2026)
- Âncora `"em"` do roteiro casa com a transcrição do Whisper, que escreve números em algarismos ("7 ,7", "750", ".360"): ancorar em algarismo ou em palavra comum. (09/10/2026)
- O conferidor de voz do cardshorts reprova "dois e meio por cento" (ouve "2,5%"): escrever "dois vírgula cinco". "XP" sai "Xipe": escrever "xis pê". (09/10/2026)
- HeyGen passou a exigir "voice engine" na voz INEMA TIME (09/10, ~21h): o "Gerar" não abria o modal e o script dizia só "sem Enviar". O heygen-studio.mjs agora mostra o texto do aviso no erro; o Nei ajusta a voz no estúdio. (09/10/2026)
- Citação no quadro e no base.md = literal do transcript ("se, por exemplo, Lula ganhar", não "Se o Lula ganhar"); o `auto/checar.py` reprova paráfrase. (09/10/2026)
- Não editar `auto/rodar.sh` (ou qualquer .sh) enquanto uma rodada está em execução: o bash lê o script por offset e executa pedaço deslocado. Editar uma cópia e trocar com `mv` (novo inode) ou esperar acabar. (09/10/2026)
- A voz do HeyGen chega ~-26 dB (7 dB abaixo da chatterbox): mixar SEMPRE com loudnorm -14 LUFS e medir (`ebur128`) antes de enviar. O semanal 09/10 saiu baixo e o Nei notou. (09/10/2026)
