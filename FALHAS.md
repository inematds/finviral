| data | o que quebrou | menor correção | prompt \| infra |
|---|---|---|---|
| 2026-10-11 | domingo LONGO não saiu: "fala f22 não achada na transcrição do avatar" (o avatar falou, o Whisper pulou 7,6 s de áudio) | retempo.py interpola fala sem palavra na lacuna entre as vizinhas (aborta só com >3) | infra |
| 2026-10-11 | domingo curto: número sobre o hero no início, topo vazio até a âncora, legenda "7 ,7 %", fala com "tu" e CTA para o canal INEMA TIA | gerar_cena.py (f1 limpo, número do início da fala até o próximo visual, cola número) + checar.py reprova tu/CTA fora do inema.club + prompts | prompt + infra |
| 2026-10-10 | semanal das 02:00 saiu calado ("outra rodada em andamento": teste manual segurava o flock) e nada foi ao lives2 | rodar.sh: `flock -w` (esperar) + avisar no bot em vez de `exit 0` mudo — pendente | infra |
| 2026-10-10 | (no saudeviral, motor igual) fundo de miniatura cortado, título do hero estourando, HeyGen "ProcessSingleton" com o perfil aberto por outra sessão | palco.html: fundo desfocado + caber() com fonte carregada; avatar_heygen.sh: nova tentativa a cada 2 min até 1 h | infra |
| 2026-10-10 | piloto longo: frase "O Brasil mudou…" de pé sem risco (statement com strike_at sem ~~) e cabeçalho v2 sobre a capa | gerar_cena_longo risca a frase toda e antecipa o risco; cena da capa com cabeçalho vazio | prompt |
| 2026-10-10 | voz baixava no fim ("no inema.club"): afade de 1,4 s na mistura toda e o HeyGen corta logo após a última palavra | fade só na música | prompt |
| 2026-10-10 | legenda cortada na borda (bloco fixo de 3 palavras: "INTELIGÊNCIA ARTIFICIAL CURSO") + "-feira" solto + "Ambima" do Whisper | bloco ≤18 letras, fonte encolhe até caber, cola "-feira", grafia do roteiro na legenda | prompt |
| 2026-10-09 | semanal com avatar saiu com voz baixa (HeyGen entrega a −26 dB, mix sem normalizar) | loudnorm −14 LUFS no compor_avatar.sh | infra |
| 2026-10-09 | base.md do piloto com citação parafraseada ("Se o Lula ganhar") | auto/checar.py confere trecho literal no transcript | prompt |
| 2026-10-09 | heygen-studio: "modal de geração sem botão Enviar" (HeyGen pediu voice engine na voz INEMA TIME) | erro mostra o texto do aviso + espera 20 s pelo modal; Nei ajustou a voz | infra |
| 09/10/2026 | palco.html em recursão (window.render sobrescreveu render) | renomear para desenhar | prompt |
| 09/10/2026 | gerar_cena: âncora por extenso não casa com transcrição em algarismos | âncora em algarismo | prompt |
