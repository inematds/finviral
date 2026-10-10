| data | o que quebrou | menor correção | prompt \| infra |
|---|---|---|---|
| 2026-10-10 | piloto longo: frase "O Brasil mudou…" de pé sem risco (statement com strike_at sem ~~) e cabeçalho v2 sobre a capa | gerar_cena_longo risca a frase toda e antecipa o risco; cena da capa com cabeçalho vazio | prompt |
| 2026-10-10 | voz baixava no fim ("no inema.club"): afade de 1,4 s na mistura toda e o HeyGen corta logo após a última palavra | fade só na música | prompt |
| 2026-10-10 | legenda cortada na borda (bloco fixo de 3 palavras: "INTELIGÊNCIA ARTIFICIAL CURSO") + "-feira" solto + "Ambima" do Whisper | bloco ≤18 letras, fonte encolhe até caber, cola "-feira", grafia do roteiro na legenda | prompt |
| 2026-10-09 | semanal com avatar saiu com voz baixa (HeyGen entrega a −26 dB, mix sem normalizar) | loudnorm −14 LUFS no compor_avatar.sh | infra |
| 2026-10-09 | base.md do piloto com citação parafraseada ("Se o Lula ganhar") | auto/checar.py confere trecho literal no transcript | prompt |
| 2026-10-09 | heygen-studio: "modal de geração sem botão Enviar" (HeyGen pediu voice engine na voz INEMA TIME) | erro mostra o texto do aviso + espera 20 s pelo modal; Nei ajustou a voz | infra |
| 09/10/2026 | palco.html em recursão (window.render sobrescreveu render) | renomear para desenhar | prompt |
| 09/10/2026 | gerar_cena: âncora por extenso não casa com transcrição em algarismos | âncora em algarismo | prompt |
