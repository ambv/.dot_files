from pathlib import Path


p = Path('~/.local/share/fish/fish_history')
p = p.expanduser()

hist = p.open("rb").readlines()
new_hist = []
seen_commands = set()

skip_when = False
for line in hist:
    if skip_when:
        if line.startswith(b"  when: "):
            skip_when = False
            continue

    if line.startswith(b"- cmd: : "):
        prefix, command = line.split(b";", 1)
        if command in seen_commands:
            print("warning: duplicate", command)
            continue
        ts = int(prefix.split(b":")[2])
        new_hist.append(b"- cmd: " + command)
        new_hist.append(b"  when: " + str(ts).encode() + b"\n")
        skip_when = True
    else:
        new_hist.append(line)

with p.with_suffix(".new").open("wb") as f:
    for line in new_hist:
        f.write(line)