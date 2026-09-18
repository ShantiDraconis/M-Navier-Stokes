#!/usr/bin/env python3
import hashlib, json, os, pathlib, subprocess

ROOT = pathlib.Path.cwd()
S1 = ROOT / "_s1_locked"
FROZEN = "c56d9632facf96e0a5d834b987b30df5fe2563a1"
SUCCESSOR = "cf4e2553ff2234a80dc7f88b7d433a9b1eafc4c0"

def sha256(path):
    h=hashlib.sha256()
    with open(path,"rb") as f:
        for b in iter(lambda:f.read(1024*1024),b""): h.update(b)
    return h.hexdigest()

def git(*args, cwd=ROOT):
    return subprocess.check_output(["git",*args],cwd=cwd,text=True).strip()

def blob(path):
    return git("rev-parse",f"{SUCCESSOR}:{path}",cwd=S1)

artifact_ids=[]
repo=os.environ.get("GITHUB_REPOSITORY","")
run_id=os.environ.get("GITHUB_RUN_ID","")
if repo and run_id:
    try:
        raw=subprocess.check_output(["gh","api",f"repos/{repo}/actions/runs/{run_id}/artifacts","--paginate"],text=True)
        data=json.loads(raw)
        artifact_ids=[{"id":a["id"],"name":a["name"],"expired":a["expired"]} for a in data.get("artifacts",[])]
    except Exception as e:
        artifact_ids=[{"status":"UNAVAILABLE_AT_GENERATION","reason":type(e).__name__}]

audit_state=ROOT/"audit/8x5/NS_8x5_STATE.json"
sigma=json.loads(audit_state.read_text()) if audit_state.exists() else None

manifest={
  "schema":"ns.s1.certificate.v1",
  "classification":"INFRASTRUCTURE_CERTIFICATE_ONLY",
  "mathematical_promotion":False,
  "HEAD_SHA":os.environ.get("GITHUB_SHA",git("rev-parse","HEAD")),
  "PARENT_SHA":git("rev-parse","HEAD^"),
  "TREE_SHA":git("rev-parse","HEAD^{tree}"),
  "frozen_source":{"sha":FROZEN,"tree":git("rev-parse",f"{FROZEN}^{{tree}}",cwd=S1)},
  "locked_successor":{"sha":SUCCESSOR,"parent":git("rev-parse",f"{SUCCESSOR}^",cwd=S1),"tree":git("rev-parse",f"{SUCCESSOR}^{{tree}}",cwd=S1)},
  "hashes":{
    "lean-toolchain":"sha256:"+sha256(S1/"lean-toolchain"),
    "lakefile.lean":"sha256:"+sha256(S1/"lakefile.lean"),
    "lake-manifest.json":"sha256:"+sha256(S1/"lake-manifest.json"),
    "workflow":"sha256:"+sha256(ROOT/".github/workflows/audit-8x5.yml")
  },
  "action_shas":{
    "actions/checkout":"11d5960a326750d5838078e36cf38b85af677262",
    "leanprover/lean-action":"50fcf42d2e460296f1a34b402e990d1b24f8b596",
    "actions/upload-artifact":"ea165f8d65b6e75b540449e92b4886f43607fa02"
  },
  "run":{"run_id":run_id,"job":os.environ.get("GITHUB_JOB"),"run_attempt":os.environ.get("GITHUB_RUN_ATTEMPT")},
  "artifact_ids":artifact_ids,
  "theorem_blob_shas":{
    "MaximalFrontier.lean":blob("Core/G1/MaximalFrontier.lean"),
    "ClosedClosedClosedTarget.lean":blob("Core/G1/ClosedClosedClosedTarget.lean"),
    "G1.lean":blob("Core/G1.lean")
  },
  "footprints":{
    "status":"NOT_CERTIFIED_BY_THIS_SCRIPT",
    "reason":"Axiom footprints must come from explicit #print axioms gates; never inferred as empty."
  },
  "HC_Q_S_K_A_N_B_X":{
    "HC":"BLOCKING",
    "Q":"BLOCKING",
    "S":"REVIEWED",
    "K":"BLOCKING",
    "A":"PENDING_L8_AXIOM_GATE",
    "N":"PENDING_NEGATIVE_CONTROL",
    "B":"PENDING_CURRENT_RUN",
    "X":"NO_MATHEMATICAL_PROMOTION"
  },
  "audit_state":sigma,
  "endpoint":{"emit_closed_closed_closed":False,"FECHADO_FECHADO_FECHADO":"NO"},
}
out=ROOT/"audit/CERTIFICATE_S1.json"
out.write_text(json.dumps(manifest,indent=2,sort_keys=True)+"\n")
print(out)
print("sha256:"+sha256(out))
