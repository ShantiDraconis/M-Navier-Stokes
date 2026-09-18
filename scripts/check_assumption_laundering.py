#!/usr/bin/env python3
"""Conservative static pre-audit for target-as-input laundering.

This tripwire compares premise-like structure fields against theorem/lemma
STATEMENTS only. Proof bodies are deliberately excluded.

A field whose type is merely a predicate family such as `State -> Prop` is
data naming a proposition-valued observable, not itself a proof premise.
Those fields are excluded from intersection testing. Proof-carrying fields,
quantified implications and relational propositions remain audited.

Known upstream scientific debt is reported, never silently erased.
"""
from __future__ import annotations
import pathlib, re, sys

ROOTS=[pathlib.Path('Core'), pathlib.Path('A2')]
RESULT_STRUCTURES={'A2DerivedContraction'}
PROVENANCE_DEPTH_LIMIT=10
FIELD_RE=re.compile(r'^\s*([A-Za-z_][\w\']*)\s*:\s*(.+?)\s*$')
STRUCT_RE=re.compile(r'^\s*structure\s+([A-Za-z_][\w\']*)')
THM_RE=re.compile(r'^\s*(?:theorem|lemma)\s+([A-Za-z_][\w\']*)')
KNOWN_UPSTREAM_OPEN={
  ('WeightedDualityInterface','greenIdentity','weightedIBP_component'):
    'A2.1 OPEN_BRIDGE: Green identity is still stored in the frozen upstream interface'
}

def norm(s):
  return re.sub(r'\s+','',re.sub(r'--.*','',s)).replace('(1:ℝ)/2','1/2')

def predicate_family_type(s):
  n=norm(s)
  return '∀' not in n and n.endswith('→Prop') and not re.search(r'[≤<=>≠∧∨]', n.replace('→Prop',''))

def statement_prefix(s):
  return s.split(':=',1)[0]

fields=[]; thms=[]
for root in ROOTS:
  if not root.exists():
    continue
  for p in root.rglob('*.lean'):
    lines=p.read_text(encoding='utf-8').splitlines()
    ins=False; sname=None
    collecting=False; tname=None; tbuf=[]
    for line in lines:
      sm=STRUCT_RE.match(line)
      if sm:
        ins=True; sname=sm.group(1)
      elif ins and re.match(r'^\s*(?:def|theorem|lemma|structure|end|namespace)\b',line):
        ins=False; sname=None

      if ins and sname not in RESULT_STRUCTURES:
        m=FIELD_RE.match(line)
        if m:
          raw=m.group(2)
          if predicate_family_type(raw):
            pass
          elif re.search(r'(?:<|≤|=|≠|∧|∨|→)',raw):
            fields.append((p.as_posix(),sname,m.group(1),raw,norm(raw)))

      if not collecting:
        tm=THM_RE.match(line)
        if tm:
          collecting=True; tname=tm.group(1); tbuf=[line]
          if ':=' in line:
            thms.append((p.as_posix(),tname,norm(statement_prefix(' '.join(tbuf)))))
            collecting=False; tname=None; tbuf=[]
      else:
        tbuf.append(line)
        if ':=' in line:
          thms.append((p.as_posix(),tname,norm(statement_prefix(' '.join(tbuf)))))
          collecting=False; tname=None; tbuf=[]

hits=[]; known=[]
for fp,sn,fn,raw,nf in fields:
  for tp,tn,nt in thms:
    if len(nf)>=8 and nf in nt:
      rec=(fp,sn,fn,raw,tp,tn)
      if (sn,fn,tn) in KNOWN_UPSTREAM_OPEN:
        known.append(rec)
      else:
        hits.append(rec)

print(f'PROVENANCE_DEPTH_LIMIT={PROVENANCE_DEPTH_LIMIT}')
print(f'premise-like fields={len(fields)} theorem-statements={len(thms)}')
for h in known:
  reason=KNOWN_UPSTREAM_OPEN[(h[1],h[2],h[5])]
  print(f'KNOWN_UPSTREAM_OPEN field={h[0]}::{h[1]}.{h[2]} theorem={h[4]}::{h[5]} reason={reason}')
for h in hits:
  print(f'SUSPICIOUS_INTERSECTION field={h[0]}::{h[1]}.{h[2]} [{h[3]}] theorem={h[4]}::{h[5]}')
if hits:
  print('FAIL: new premise/result intersection requires semantic review.')
  sys.exit(2)
print(f'PASS_STATIC: no new exact normalized premise/result intersection; known_upstream_open={len(known)}; semantic DAG still required.')
