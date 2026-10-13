# finviral

[![finviral — Radar Financiero](guia/assets/banner-es.jpg)](https://inematds.github.io/finviral/guia/es/)

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

## Qué es

finviral es un sistema que hace, por sí solo, videos cortos (9:16) sobre lo que dijeron en sus videos los mayores influencers de finanzas de Brasil. Mira los videos de YouTube a través de la transcripción, separa los números, los hechos y las polémicas, y arma un video con números grandes animados, la fuente de cada dato en pantalla y Nei comentando (avatar). Sirve para quien quiere seguir el mercado en un minuto, sin recomendación de inversión. Funciona en una computadora con GPU, con la suscripción de Claude Code y de HeyGen.

## 📖 Guía de uso

Guía completa (landing + paso a paso): **https://inematds.github.io/finviral/guia/es/**

## Cómo funciona

1. **Recolección:** lista los videos de los canales de `canais.json` (solo metadatos, yt-dlp), descarga el audio y lo transcribe localmente (inemavox, Whisper large-v3).
2. **Guion:** `claude -p` (suscripción, sin API) lee las transcripciones y graba tres archivos:
   - `base.md`: cada número, quién lo dijo, el video y el fragmento literal;
   - `roteiro.json`: parlamentos y visuales;
   - `legenda.txt`: el texto para aprobación.
3. **Verificación (`auto/checar.py`):** verifica que cada fragmento de `base.md` esté de verdad en la transcripción. También verifica que los números del parlamento estén escritos en letras, que las imágenes existan, que el CTA esté presente y que aparezca "no es recomendación". Si falla, el guion vuelve una vez para corrección. Si falla de nuevo, el video no se hace.
4. **Avatar:** HeyGen genera el avatar de Nei por el estudio (suscripción, sin API de generación).
   - `motor/retempo.py` alinea el arte con el habla del avatar.
   - Si HeyGen falla, sale la versión con la foto y la voz de Nei (Chatterbox).
5. **Video:**
   - `motor/palco.html` se renderiza cuadro a cuadro con Playwright, con contadores, gráfico, sello de polémica, subtítulos palabra por palabra y la fuente en cada escena.
   - El avatar queda en la esquina, con música de fondo.
6. **Publicación:** el video se publica en YouTube INEMA TIA (lives2) con `yt-pubx` (`auto/publicar.sh`) y siempre va al bot v3 en Telegram, con el enlace. Si el avatar falla, la versión con foto solo va al bot.
7. **Sábado y domingo — el largo 16:9:** después del corto, "La semana explicada" (5 a 7 min, un capítulo por influencer), con las escenas animadas del explicavideo v2 y piezas de finanzas (`motor/longo.html`, `auto/roteiro-longo.md`, `auto/checar.py --longo`, `auto/longo.sh`). El corto avisa al final que la explicación completa está en INEMA TIA.

## Agenda (systemd, usuario)

| Cuándo | Ronda | Qué sale |
|---|---|---|
| Lunes a viernes, 02:00 | `diario` | 40–60 s con lo que publicaron ayer y anteayer |
| Sábado, 02:00 | `semanal` | 90 s a 2 min: balance de la semana + largo 16:9 "La semana explicada" (5–7 min) |
| Domingo, 02:00 | `domingo` | ~90 s: lo que esperan para la próxima semana + largo 16:9 explicado |

El bot v3 siempre recibe una de tres cosas: el video (con el enlace de lives2), "sin pauta" (un día flojo no se convierte en video) o "falló en X".

```bash
cp systemd/finviral-* ~/.config/systemd/user/ && systemctl --user daemon-reload
systemctl --user enable --now finviral-diario.timer finviral-semanal.timer finviral-domingo.timer
systemctl --user list-timers 'finviral-*'
```

## Fuera de la agenda

```bash
auto/rodar.sh diario 2026-10-09          # ronda de un día específico
SEM_AVATAR=1 SEM_BOT=1 auto/rodar.sh semanal   # prueba: sin HeyGen y sin enviar
echo "2026-10-17 diario" >> auto/pular.txt     # saltar una ronda
```

Para una edición hecha a mano (como `edicoes/2026-10-09-semana`):

```bash
E=edicoes/<data>-<slug>
python3 motor/narrar.py $E 1.12 && python3 motor/gerar_cena.py $E && motor/montar.sh $E $E/video.mp4   # voz de Nei + foto
motor/avatar_heygen.sh $E FINVIRAL-<titulo> && python3 motor/gerar_cena.py $E --avatar && motor/compor_avatar.sh $E $E/video.mp4   # avatar
```

## Influencers

La lista está en `canais.json`, con `"ativo": false` para pausar. Hoy es el Top 10 del ranking Anbima FInfluence (10.ª edición): Bruno Perini, Economista Sincero, Ricardo Amorim, O Primo Rico, Hermann Greb, Café com Ferri, Pablo Spyer, Primo Pobre, Nathalia Arcuri (Me Poupe!) y Tiago Reis.

Si aparece en destaque otro nombre consolidado y confiable, el sistema sugiere incluirlo en el mensaje del bot. Un nombre emergente nunca entra, y la inclusión solo ocurre con el ok de Nei.

## Reglas de cada video

- Cuadro 0 lleno: fecha dd/mm/aaaa y el número más fuerte.
- Solo entra un número que está en la transcripción, con la fuente (canal, fecha, título) en pantalla. No es recomendación de inversión.
- Elecciones y política: el video relata lo que dijo cada uno, siempre atribuido, sin tomar partido.
- Habla en el tono de Nei ("tu" informal del portugués), con números y años escritos en letras.
- Final: gancho de comentario y CTA de gestión de agentes de IA en inema.club.
- HeyGen solo por el estudio de la suscripción. La oferta de cambio de plan siempre se rechaza.

## Requisitos

- yt-dlp
- inemavox (`~/projetos/inemavox`)
- cardshorts (voz Chatterbox `nei`)
- Node con Playwright (`motor/node_modules` → enlace al de eventosextremospub)
- ffmpeg
- `claude` (Claude Code con sesión iniciada en la suscripción)
- Xvfb `:99` y el perfil de HeyGen de explicavideos
- bot v3 (`refazvideo/ferramentas/enviar_bot_v3.mjs`)

Licencia MIT. El contenido citado pertenece a los canales de origen, siempre acreditados en pantalla.
