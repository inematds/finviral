# Tarefa: roteiro do finviral ({MODO}, {DATA})

Você monta o roteiro de um vídeo 9:16 do **finviral**: o que os maiores influenciadores de finanças do Brasil (ranking Anbima FInfluence) disseram, com números grandes, fonte na tela, o Nei comentando e CTA do inema.club no fim. Trabalhe só com os arquivos abaixo. Não use a internet nem outra API.

## Entrada
- Pasta da edição: `{ED}`. Escreva nela apenas os arquivos pedidos.
- Vídeos do período: `{ED}/videos.tsv`, com as colunas handle, data, id, duração em segundos, views, canal e título.
- Transcrições: `{TX}/<id>/transcript.txt`. Só existem as dos ids listados em `{ED}/transcritos.txt`.
- Canais e ranking: `{RAIZ}/canais.json`.
- Edição de referência, aprovada pelo Nei. Copie o formato dela:
  - `{RAIZ}/edicoes/2026-10-09-semana/roteiro.json`
  - `{RAIZ}/edicoes/2026-10-09-semana/base.md`
- Esquema do roteiro: docstring de `{RAIZ}/motor/gerar_cena.py`.

## Modo
{INSTRUCAO_MODO}

## Saída
Grave TODOS estes arquivos, ou só o `SEM_PAUTA.txt`.

### 1. `{ED}/base.md`
Uma tabela com as colunas `| Número usado | Quem disse | Vídeo | Data | Trecho da transcrição |`. Regras:
- Uma linha por número ou fato que aparece no vídeo.
- **Vídeo** é o id do YouTube, exatamente como está no videos.tsv.
- **Trecho** fica entre aspas retas `"..."` e é cópia LITERAL de um pedaço contínuo do transcript.txt desse id: de 6 a 30 palavras, sem editar nem juntar pedaços.
- Um script confere cada trecho. Se algum não estiver no transcript, o vídeo é descartado.

### 2. `{ED}/roteiro.json`
Mesmo formato da edição de referência:
- `marca`: "INEMA · RADAR FINANCEIRO".
- `selo`: período, por exemplo "YOUTUBE · 09/10" ou "YOUTUBE · 03 A 08/10".
- `avatar`: `{"img": "img/avatar-teste.jpg", "tag": "<b>NEI MALDANER</b> · INEMA"}`.
- `hero` é o quadro 0. Leva:
  - a data `{DATA_BR}` com o dia da semana;
  - o tema;
  - o número mais forte, em `t2`;
  - uma linha `t3`;
  - um `t4` curto;
  - os rostos (miniaturas `img/<id>.jpg` dos vídeos citados, no máximo cinco).

Regras das `falas`:
- **Abertura (f1):** a frase-choque com o número mais forte. O número já está no `hero`: f1 NÃO leva `numero`, `ficha`, `caixa` nem `carimbo`. Nunca abrir com "Neste vídeo", "Imagine" ou "Olá".
- **Resumo dos dez, com pelo menos CINCO assuntos (Nei, 13/10/2026; vale para todo modo do curto).** O vídeo é o resumo do que os dez influenciadores do `canais.json` publicaram no período: no mínimo cinco assuntos (o mínimo exato vem no Modo), de influenciadores diferentes sempre que der, o mais forte primeiro. Logo depois de f1, uma fala-sumário com `caixa` de `itens` (k "Hoje no radar", ou "Na semana") listando os assuntos que vêm, um item curto por assunto, cada item com `em` numa palavra da fala. Cada assunto tem pelo menos uma linha no base.md com o id do vídeo dele: a conferência conta os vídeos distintos do base.md. Cada assunto continua contado inteiro, em duas ou três falas seguidas (contexto, o que ele disse, o que muda pra quem assiste): cinco assuntos não podem virar cinco fragmentos.
- **Viradas e manchete (Nei, 14/10/2026).** A 1ª fala de cada assunto leva `"assunto": "<NOME CURTO>"` (até 24 letras, ex.: "CELULAR FURTADO", "GARANTIA"): o vídeo abre 1 s de cartão de virada ("ASSUNTO 2 DE 5") antes dela, e outro antes da pergunta. A fala-sumário leva `"manchete": "HOJE NO RADAR"` (ou "NA SEMANA"). Cada assunto marcado precisa de pelo menos duas falas. A conferência conta as marcas de `assunto`.
- **Uma ideia por fala.** Cada influenciador citado ganha `ficha` (nome, canal com "dd/mm · N mil views", `rk` do canais.json, foto `img/<id>.jpg`) e `fundo` `img/<id>.jpg`.
- **Números:**
  - Usar `numero` (contador grande), `grafico` (só se houver série real dita no vídeo), `caixa` com citação literal ou itens, e `carimbo` ("POLÊMICA", "APOSTA", "ALERTA") quando couber.
  - Todo número mostrado está no base.md.
- **`fonte`:** "<b>Fonte:</b> Canal, YouTube, dd/mm/aaaa · “título curto”".
- **Texto falado (`fala`), no tom do Nei:**
  - Tratar por "você" (você, seu, sua, para você), NUNCA "tu", "teu", "tua", "ti" ou "te prepara" — a edição de referência ainda usa "tu": não copie isso. Frases curtas.
  - Escrever TODOS os números e anos por extenso, sem algarismo: "sete vírgula sete por cento", "dois mil e vinte e oito".
  - Siglas lidas como se fala ("xis pê"). Endereço do governo se fala sem "ponto": "consumidor gov bê érre", "gov bê érre" (nunca "consumidor ponto gov ponto bê erre"; o Nei reprovou em 13/10/2026). Na tela (`caixa`, `fonte`) continua "consumidor.gov.br". O CTA "inema ponto club" não muda. Sem emoji.
- **`em` (âncora):** uma palavra comum que está na fala, nunca um número.
- **Penúltima fala:** gancho de comentário. É uma pergunta que chama a pessoa a contar onde ela está e como é aí (Nei, 13/10/2026): "De onde você está assistindo? O que você acha desse caso? Como é a situação aí na sua cidade? Comente aqui" (adapte ao tema: o caso, o preço, o atendimento, o golpe que mais aparece na região); caixa "Comente: de onde você é e o que acha", com `"limpa": true`. A `fonte` dela é "<b>Não é recomendação de investimento.</b> Resumo do que os influenciadores disseram, com a fonte de cada número".
- **Última fala:** CTA com `fundo` "img/cta.jpg" e `"limpa": true`.
  - Fala: uma ponte curta do tema para a IA, mais "Você pode aprender isso no inema ponto club, com cursos gratuitos." (Nei, 13/10/2026: o CTA diz que dá pra APRENDER no inema.club)
  - O CTA é SEMPRE só o inema.club: não citar canal do YouTube, INEMA TIA, "vídeo longo", "se inscreva" nem outro destino.
  - `hero` igual ao da referência (GESTÃO DE / AGENTES DE IA / img/cta.jpg).
  - `caixa` tipo cta com "INEMA.CLUB".
- **Eleição e política:** relatar o que cada um disse, sempre atribuído ("segundo ele", "ele aposta"), sem tomar lado e sem opinião do Nei sobre candidato.
- **Ética:** nada de promessa de ganho nem recomendação. Polêmica é o que ELES disseram.

### 3. `{ED}/legenda.txt`
Até 6 linhas para o Nei aprovar no Telegram:
- linha 1: título sugerido para o YouTube, até 70 caracteres, com gancho;
- linhas 2 a 4: os números principais com quem disse;
- linha 5: "Não é recomendação de investimento."

### 4. `{ED}/sugestao.txt` (opcional)
Se, nos títulos ou transcrições, outro influenciador de finanças CONSOLIDADO e confiável aparecer em destaque, escreva uma linha com nome, canal e motivo. Consolidado quer dizer ranking Anbima ou equivalente, anos de canal, grande audiência; nunca emergente nem promessa de enriquecimento. É só sugestão: não inclua essa pessoa no vídeo.

### Sem pauta
Se não houver nada relevante (nenhum número ou fato forte, só repetição ou conteúdo publicitário), grave apenas `{ED}/SEM_PAUTA.txt` com uma linha explicando o motivo. Melhor não publicar do que publicar morno.
