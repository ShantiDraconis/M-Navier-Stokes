#!/usr/bin/env python3
"""Conservative static pre-audit for target-as-input laundering.

Result/certificate structures are not treated as premises. This remains a
tripwire, not a semantic equivalence prover. Semantic provenance is a separate
gate. The declared traversal ceiling for that gate is 10 definition edges;
exceeding it must fail closed rather than time out silently.
"""
from __future__ import annotations
import pathlib, re, sys
ROOTS=[pathlib.Path('Core'), pathlib.Path('A2')]
RESULT_STRUCTURES={'A2DerivedContraction'}
PROVENANCE_DEPTH_LIMIT=10
FIELD_RE=re.compile(r'^\s*([A-Za-z_][\w\']*)\s*:\s*(.+?)\s*$')
STRUCT_RE=re.compile(r'^\s*structure\s+([A-Za-z_][\w\']*)')
THM_RE=re.compile(r'^\s*(?:theorem|lemma)\s+([A-Za-z_][\w\']*)')
def norm(s): return re.sub(r'\s+','',re.sub(r'--.*','',s)).replace('(1:ℝ)/2','1/2')
fields=[]; thms=[]
for root in ROOTS:
  if not root.exists(): continue
  for p in root.rglob('*.lean'):
    lines=p.read_text(encoding='utf-8').splitlines(); ins=False; sname=None; name=None; buf=[]
    for line in lines:
      sm=STRUCT_RE.match(line)
      if sm:
        ins=True; sname=sm.group(1)
      elif ins and re.match(r'^\s*(?:def|theorem|lemma|structure|end|namespace)\b',line):
        ins=False; sname=None
      if ins and sname not in RESULT_STRUCTURES:
        m=FIELD_RE.match(line)
        if m and re.search(r'(?:<|≤|=|≠|∧|∨|→)',m.group(2)):
          fields.append((p.as_posix(),sname,m.group(1),m.group(2),norm(m.group(2))))
      tm=THM_RE.match(line)
      if tm:
        if name and buf: thms.append((p.as_posix(),name,norm(' '.join(buf))))
        name=tm.group(1); buf=[line]
      elif name:
        buf.append(line)
        if ':= by' in line or ':=by' in norm(line):
          thms.append((p.as_posix(),name,norm(' '.join(buf)))); name=None; buf=[]
hits=[]
for fp,sn,fn,raw,nf in fields:
  for tp,tn,nt in thms:
    if len(nf)>=8 and nf in nt: hits.append((fp,sn,fn,raw,tp,tn))
print(f'PROVENANCE_DEPTH_LIMIT={PROVENANCE_DEPTH_LIMIT}')
print(f'premise-like fields={len(fields)} theorem-blocks={len(thms)}')
for h in hits:
  print(f'SUSPICIOUS_INTERSECTION field={h[0]}::{h[1]}.{h[2]} [{h[3]}] theorem={h[4]}::{h[5]}')
if hits:
  print('FAIL: premise/result intersection requires semantic review.'); sys.exit(2)
print('PASS_STATIC: no exact normalized premise/result intersection; semantic DAG still required.')
