# finviral

[![finviral — Radar Financeiro](guia/assets/banner.jpg)](https://inematds.github.io/finviral/guia/)

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

## O que é

O finviral é um sistema que faz, sozinho, vídeos curtos (9:16) sobre o que os maiores influenciadores de finanças do Brasil disseram nos vídeos deles. Ele assiste aos vídeos do YouTube por transcrição, separa os números, os fatos e as polêmicas, e monta um vídeo com números grandes animados, a fonte de cada dado na tela e o Nei comentando (avatar). Serve para quem quer acompanhar o mercado em um minuto, sem recomendação de investimento. Roda num computador com GPU, com a assinatura do Claude Code e do HeyGen.

## 📖 Guia de uso

Guia completo (landing + passo a passo): **https://inematds.github.io/finviral/guia/**

## Como funciona

1. **Coleta:** lista os vídeos dos canais de `canais.json` (só metadados, yt-dlp), baixa o áudio e transcreve localmente (inemavox, Whisper large-v3).
2. **Roteiro:** o `claude -p` (assinatura, sem API) lê as transcrições e grava três arquivos:
   - `base.md`: cada número, quem disse, o vídeo e o trecho literal;
   - `roteiro.json`: falas e visuais;
   - `legenda.txt`: o texto para aprovação.
3. **Conferência (`auto/checar.py`):** confere se cada trecho do `base.md` está de fato na transcrição. Também confere se os números da fala estão por extenso, se as imagens existem, se o CTA está presente e se aparece "não é recomendação". Se reprovar, o roteiro volta uma vez para correção. Se reprovar de novo, o vídeo não é feito.
4. **Avatar:** o HeyGen gera o avatar do Nei pelo estúdio (assinatura, sem API de geração).
   - O `motor/retempo.py` alinha a arte à fala do avatar.
   - Se o HeyGen falhar, sai a versão com a foto e a voz do Nei (Chatterbox).
5. **Vídeo:**
   - O `motor/palco.html` é renderizado quadro a quadro pelo Playwright, com contadores, gráfico, carimbo de polêmica, legenda palavra a palavra e fonte em toda cena.
   - O avatar fica no canto, com trilha.
6. **Publicação:** o vídeo é publicado no YouTube INEMA TIA (lives2) pelo `yt-pubx` (`auto/publicar.sh`) e vai sempre ao bot v3 no Telegram, com o link. Se o avatar falhar, a versão com foto só vai ao bot.
7. **Sábado e domingo — o longo 16:9:** depois do curto, sai "A semana explicada" (5 a 7 min, um capítulo por influenciador), com as cenas animadas do explicavideo v2 e peças de finanças (`motor/longo.html`, `auto/roteiro-longo.md`, `auto/checar.py --longo`, `auto/longo.sh`). O curto avisa no fim que a explicação completa está no INEMA TIA.

## Agenda (systemd, usuário)

| Quando | Rodada | O que sai |
|---|---|---|
| Segunda a sexta, 02:00 | `diario` | 40–60 s com o que eles publicaram ontem e anteontem |
| Sábado, 02:00 | `semanal` | 90 s a 2 min: balanço da semana + longo 16:9 "A semana explicada" (5–7 min) |
| Domingo, 02:00 | `domingo` | ~90 s: o que eles esperam para a semana que vem + longo 16:9 explicado |

O bot v3 sempre recebe uma de três coisas: o vídeo (com o link do lives2), "sem pauta" (dia fraco não vira vídeo) ou "falhou em X".

```bash
cp systemd/finviral-* ~/.config/systemd/user/ && systemctl --user daemon-reload
systemctl --user enable --now finviral-diario.timer finviral-semanal.timer finviral-domingo.timer
systemctl --user list-timers 'finviral-*'
```

## Avulso (fora da agenda)

```bash
auto/rodar.sh diario 2026-10-09          # rodada de um dia específico
SEM_AVATAR=1 SEM_BOT=1 auto/rodar.sh semanal   # teste: sem HeyGen e sem enviar
echo "2026-10-17 diario" >> auto/pular.txt     # pular uma rodada
```

Para uma edição feita à mão (como `edicoes/2026-10-09-semana`):

```bash
E=edicoes/<data>-<slug>
python3 motor/narrar.py $E 1.12 && python3 motor/gerar_cena.py $E && motor/montar.sh $E $E/video.mp4   # voz do Nei + foto
motor/avatar_heygen.sh $E FINVIRAL-<titulo> && python3 motor/gerar_cena.py $E --avatar && motor/compor_avatar.sh $E $E/video.mp4   # avatar
```

## Influenciadores

A lista fica em `canais.json`, com `"ativo": false` para pausar. Hoje são os 5 primeiros do ranking Anbima FInfluence (10ª edição): Bruno Perini, Economista Sincero, Ricardo Amorim, O Primo Rico e Os Economistas.

Se aparecer em destaque outro nome consolidado e confiável, o sistema sugere a inclusão na mensagem do bot. Nome emergente nunca entra, e a inclusão só acontece com o ok do Nei.

## Regras de cada vídeo

- Quadro 0 cheio: data dd/mm/aaaa e o número mais forte.
- Só entra número que está na transcrição, com a fonte (canal, data, título) na tela. Não é recomendação de investimento.
- Eleição e política: o vídeo relata o que cada um disse, sempre atribuído, sem tomar lado.
- Fala no tom do Nei ("tu"), com números e anos por extenso.
- Fim: gancho de comentário e CTA de gestão de agentes de IA no inema.club.
- HeyGen só pelo estúdio da assinatura. A oferta de troca de plano é sempre recusada.

## Requisitos

- yt-dlp
- inemavox (`~/projetos/inemavox`)
- cardshorts (voz Chatterbox `nei`)
- Node com Playwright (`motor/node_modules` → link para o do eventosextremospub)
- ffmpeg
- `claude` (Claude Code logado na assinatura)
- Xvfb `:99` e o perfil do HeyGen do explicavideos
- bot v3 (`refazvideo/ferramentas/enviar_bot_v3.mjs`)

Licença MIT. O conteúdo citado pertence aos canais de origem, sempre creditados na tela.
