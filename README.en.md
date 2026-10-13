# finviral

[![finviral — Finance Radar](guia/assets/banner-en.jpg)](https://inematds.github.io/finviral/guia/en/)

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

## What it is

finviral is a system that makes, on its own, short videos (9:16) about what Brazil's biggest finance influencers said in their videos. It watches the YouTube videos through transcription, picks out the numbers, the facts and the controversies, and builds a video with big animated numbers, the source of every figure on screen and Nei commenting (avatar). It is for anyone who wants to follow the market in one minute, with no investment advice. It runs on a computer with a GPU, with the Claude Code and HeyGen subscriptions.

## 📖 Usage guide

Full guide (landing + step by step): **https://inematds.github.io/finviral/guia/en/**

## How it works

1. **Collection:** lists the videos from the channels in `canais.json` (metadata only, yt-dlp), downloads the audio and transcribes it locally (inemavox, Whisper large-v3).
2. **Script:** `claude -p` (subscription, no API) reads the transcripts and writes three files:
   - `base.md`: every number, who said it, the video and the literal excerpt;
   - `roteiro.json`: lines and visuals;
   - `legenda.txt`: the text for approval.
3. **Fact-check (`auto/checar.py`):** checks that every excerpt in `base.md` is really in the transcript. It also checks that the numbers in the speech are spelled out, that the images exist, that the CTA is there and that "not investment advice" appears. If it fails, the script goes back once for correction. If it fails again, the video is not made.
4. **Avatar:** HeyGen generates Nei's avatar through the studio (subscription, no generation API).
   - `motor/retempo.py` aligns the art to the avatar's speech.
   - If HeyGen fails, the version with Nei's photo and voice (Chatterbox) is produced.
5. **Video:**
   - `motor/palco.html` is rendered frame by frame by Playwright, with counters, a chart, a controversy stamp, word-by-word captions and the source in every scene.
   - The avatar sits in the corner, with a soundtrack.
6. **Publishing:** the video is published on YouTube INEMA TIA (lives2) by `yt-pubx` (`auto/publicar.sh`) and always goes to bot v3 on Telegram, with the link. If the avatar fails, the photo version only goes to the bot.
7. **Saturday and Sunday — the long 16:9:** after the short, "The week explained" (5 to 7 min, one chapter per influencer), with the animated scenes of explicavideo v2 and finance pieces (`motor/longo.html`, `auto/roteiro-longo.md`, `auto/checar.py --longo`, `auto/longo.sh`). The short says at the end that the full explanation is on INEMA TIA.

## Schedule (systemd, user)

| When | Run | What comes out |
|---|---|---|
| Monday to Friday, 02:00 | `diario` | 40–60 s with what they published yesterday and the day before |
| Saturday, 02:00 | `semanal` | 90 s to 2 min: the week in review + long 16:9 "The week explained" (5–7 min) |
| Sunday, 02:00 | `domingo` | ~90 s: what they expect for the coming week + long 16:9 explained |

Bot v3 always receives one of three things: the video (with the lives2 link), "no story" (a weak day does not become a video) or "failed at X".

```bash
cp systemd/finviral-* ~/.config/systemd/user/ && systemctl --user daemon-reload
systemctl --user enable --now finviral-diario.timer finviral-semanal.timer finviral-domingo.timer
systemctl --user list-timers 'finviral-*'
```

## One-off (outside the schedule)

```bash
auto/rodar.sh diario 2026-10-09          # run for a specific day
SEM_AVATAR=1 SEM_BOT=1 auto/rodar.sh semanal   # test: no HeyGen and no sending
echo "2026-10-17 diario" >> auto/pular.txt     # skip a run
```

For an edition made by hand (like `edicoes/2026-10-09-semana`):

```bash
E=edicoes/<data>-<slug>
python3 motor/narrar.py $E 1.12 && python3 motor/gerar_cena.py $E && motor/montar.sh $E $E/video.mp4   # Nei's voice + photo
motor/avatar_heygen.sh $E FINVIRAL-<titulo> && python3 motor/gerar_cena.py $E --avatar && motor/compor_avatar.sh $E $E/video.mp4   # avatar
```

## Influencers

The list lives in `canais.json`, with `"ativo": false` to pause someone. Today it is the top 10 of the Anbima FInfluence ranking (10th edition): Bruno Perini, Economista Sincero, Ricardo Amorim, O Primo Rico, Hermann Greb, Café com Ferri, Pablo Spyer, Primo Pobre, Nathalia Arcuri (Me Poupe!) and Tiago Reis.

If another established, trustworthy name shows up in the spotlight, the system suggests adding it in the bot message. Emerging names never get in, and a name is only added with Nei's ok.

## Rules for every video

- Frame 0 full: date dd/mm/yyyy and the strongest number.
- Only numbers that are in the transcript get in, with the source (channel, date, title) on screen. Not investment advice.
- Elections and politics: the video reports what each one said, always attributed, without taking sides.
- Speech in Nei's tone (informal "tu"), with numbers and years spelled out.
- End: a comment hook and a CTA for AI agent management at inema.club.
- HeyGen only through the subscription studio. The plan change offer is always declined.

## Requirements

- yt-dlp
- inemavox (`~/projetos/inemavox`)
- cardshorts (Chatterbox voice `nei`)
- Node with Playwright (`motor/node_modules` → link to the one in eventosextremospub)
- ffmpeg
- `claude` (Claude Code logged in with the subscription)
- Xvfb `:99` and the explicavideos HeyGen profile
- bot v3 (`refazvideo/ferramentas/enviar_bot_v3.mjs`)

MIT license. The quoted content belongs to the source channels, always credited on screen.
