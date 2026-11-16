#!/usr/bin/env bash
# 把当前插件打包成 <id>-v<version>.zip，包内根目录为插件 id。
# 用法：在本目录执行 ./pack.sh
set -euo pipefail

ID=$(python3 -c 'import json,sys; print(json.load(open("plugin.json"))["id"])')
VER=$(python3 -c 'import json,sys; print(json.load(open("plugin.json"))["version"])')
OUT="${ID}-v${VER}.zip"

python3 - "$ID" "$OUT" <<'PY'
import os, sys, zipfile, shutil
root, out = sys.argv[1], sys.argv[2]
stage = "/tmp/_plugin_stage_" + root
shutil.rmtree(stage, ignore_errors=True)
os.makedirs(os.path.join(stage, root), exist_ok=True)
keep = ["plugin.json", "INSTALL.md", "README.md", ".gitignore"]
items = [p for p in keep if os.path.exists(p)] + \
        [d for d in ("files", "assets", "patches") if os.path.isdir(d)]
for p in items:
    dst = os.path.join(stage, root, p)
    if os.path.isdir(p):
        shutil.copytree(p, dst, ignore=shutil.ignore_patterns(".DS_Store", "__pycache__"))
    else:
        shutil.copy2(p, dst)
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for base, _, names in os.walk(stage):
        for n in names:
            full = os.path.join(base, n)
            z.write(full, os.path.relpath(full, stage))
shutil.rmtree(stage, ignore_errors=True)
print("打包完成:", out)
PY
