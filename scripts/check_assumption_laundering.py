#!/usr/bin/env python3
"""Conservative static pre-audit for suspicious Prop fields vs theorem conclusions.
Tripwire only: semantic equivalence and circularity still require directed audit.
"""
from __future__ import annotations
import pathlib, re, sys
ROOTS=[pathlib.Path('Core'),pathlib.Path('A2')]
FIELD_RE=re.compile(r'^\s*([A-Za-z_][\w\']*)\s*:\s*(.+?)\s*$')
THM_RE=re.compile(r'^\s*(?:theorem|lemma)\s+([A-Za-z_][\w\']*)')
def norm(s): return re.sub(r'\s+','',re.sub(r'--.*','',s)).replace('(1:ℝ)/2','1/2')
fields=[]; thms=[]
for root in ROOTS:
  if not root.exists(): continue
  for p in root.rglob('*.lean'):
    lines=p.read_text(encoding='utf-8').splitlines(); ins=False; name=None; buf=[]
    for line in lines:
      if re.match(r'^\s*structure\s+',line): ins=True
      elif ins and re.match(r'^\s*(?:def|theorem|lemma|structure|end|namespace)\b',line): ins=False
      if ins:
        m=FIELD_RE.match(line)
        if m and re.search(r'(?:<|≤|=|≠|∧|∨|→)',m.group(2)): fields.append((p.as_posix(),m.group(1),m.group(2),norm(m.group(2))))
      tm=THM_RE.match(line)
      if tm:
        if name and buf: thms.append((p.as_posix(),name,norm(' '.join(buf))))
        name=tm.group(1); buf=[line]
      elif name:
        buf.append(line)
        if ':= by' in line or ':=by' in norm(line): thms.append((p.as_posix(),name,norm(' '.join(buf)))); name=None; buf=[]
hits=[]
for fp,fn,raw,nf in fields:
  for tp,tn,nt in thms:
    if len(nf)>=8 and nf in nt: hits.append((fp,fn,raw,tp,tn))
print(f'prop-like fields={len(fields)} theorem-blocks={len(thms)}')
for h in hits: print(f'SUSPICIOUS_INTERSECTION field={h[0]}::{h[1]} [{h[2]}] theorem={h[3]}::{h[4]}')
if hits:
  print('FAIL: semantic review required; static match is not itself proof of laundering.'); sys.exit(2)
print('PASS_STATIC: no exact normalized intersection; semantic/circularity audit still required.')
