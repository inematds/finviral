#!/usr/bin/env python3
"""Portão antes do render: confere roteiro.json e base.md de uma edição gerada pela automação.
uso: auto/checar.py <pasta-da-edicao> [pasta-tx]
Sai 0 se ok; 1 com a lista de problemas (o vídeo não é feito nem enviado)."""
import json, re, sys, unicodedata
from pathlib import Path

E = Path(sys.argv[1]).resolve()
TX = Path(sys.argv[2] if len(sys.argv) > 2 else Path.home() / "projetos/output/finviral/coleta/tx")
erros = []


def n(s):
    s = unicodedata.normalize("NFD", s.lower()).encode("ascii", "ignore").decode()
    return re.sub(r"\s+", " ", re.sub(r"[^a-z0-9%]+", " ", s)).strip()


ids = {l.split("\t")[2] for l in (E / "videos.tsv").read_text().splitlines() if l.count("\t") >= 6}

# base.md: cada trecho é cópia literal do transcript do vídeo citado
linhas = [l for l in (E / "base.md").read_text().splitlines() if l.startswith("|") and not re.match(r"^\|[\s:|-]+\|?$", l)]
linhas = [l for l in linhas if "Trecho" not in l]
if len(linhas) < 3:
    erros.append(f"base.md com {len(linhas)} linhas (mínimo 3)")
for l in linhas:
    cols = [c.strip() for c in l.strip("|").split("|")]
    vid = next((c for c in cols if c.strip("` ") in ids), None)
    if not vid:
        erros.append(f"base.md: linha sem id do videos.tsv: {l[:90]}")
        continue
    vid = vid.strip("` ")
    trechos = re.findall(r'"([^"]{20,})"', cols[-1])  # trecho = última coluna
    if not trechos:
        erros.append(f"base.md: linha sem trecho entre aspas: {l[:90]}")
        continue
    t = TX / vid / "transcript.txt"
    if not t.exists():
        erros.append(f"base.md: {vid} sem transcrição")
        continue
    alvo = n(t.read_text())
    for tr in trechos:
        partes = [p for p in re.split(r"\.\.\.|…", tr) if len(p.strip()) > 8]
        if not all(n(p) in alvo for p in partes):
            erros.append(f"base.md: trecho NÃO está no transcript de {vid}: \"{tr[:80]}\"")

# roteiro.json
try:
    R = json.loads((E / "roteiro.json").read_text())
except Exception as ex:
    sys.exit(f"roteiro.json inválido: {ex}")
F = R.get("falas", [])
if not 4 <= len(F) <= 14:
    erros.append(f"{len(F)} falas (esperado 4 a 14)")
if not R.get("hero"):
    erros.append("sem hero (quadro 0)")
vistos = set()
for f in F:
    fid = f.get("id")
    if not fid or fid in vistos:
        erros.append(f"id de fala vazio ou repetido: {fid}")
    vistos.add(fid)
    fala = f.get("fala", "")
    if len(fala.split()) < 4:
        erros.append(f"{fid}: fala curta demais")
    if re.search(r"(?<![A-Za-z])\d", fala):
        erros.append(f"{fid}: número em algarismo na fala (escrever por extenso): {fala[:80]}")
    for k in ("numero", "grafico", "carimbo", "caixa", "ficha"):
        a = (f.get(k) or {}).get("em")
        if a and re.search(r"\d", a):
            erros.append(f"{fid}: âncora '{a}' com número")
    for img in re.findall(r"img/[\w.-]+", json.dumps(f)):
        if not (E / img).exists():
            erros.append(f"{fid}: imagem ausente {img}")
if F and "inema" not in F[-1].get("fala", "").lower():
    erros.append("última fala sem CTA do inema")
if "recomendação de investimento" not in json.dumps(R, ensure_ascii=False):
    erros.append("falta 'Não é recomendação de investimento'")
palavras = sum(len(f.get("fala", "").split()) for f in F)
print(f"{len(F)} falas · {palavras} palavras · {len(linhas)} fatos no base.md")
if erros:
    print("\n".join("PROBLEMA " + e for e in erros))
    sys.exit(1)
print("ok")
