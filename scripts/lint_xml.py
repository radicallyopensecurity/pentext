#!/usr/bin/env python3
"""XML quality checks for PenText.

Phases:
  well-formed  - xmllint --noout per *.xml file
  schema       - XSD validation of files declaring
                 xsi:noNamespaceSchemaLocation, looked up by basename
                 in dtd/, run with xmllint --xinclude
  format       - zpretty --check on every *.xml file

When GITHUB_OUTPUT / GITHUB_STEP_SUMMARY are set (running inside a
GitHub Actions step), the script appends machine-readable counts and
a markdown section per phase. The exit code reflects whether the
selected phase(s) passed.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DTD_DIR = REPO_ROOT / "dtd"
EXCLUDE_PARTS = {"target", ".git", ".github"}
SCHEMA_RE = re.compile(r'xsi:noNamespaceSchemaLocation="([^"]+)"')

PHASE_TITLES = {
    "well-formed": "Well-formedness",
    "schema": "XSD schema validation",
    "format": "zpretty formatting",
}


@dataclass
class Result:
    phase: str
    total: int = 0
    failures: list[str] = field(default_factory=list)

    @property
    def failed(self) -> int:
        return len(self.failures)

    @property
    def ok(self) -> bool:
        return self.failed == 0


def find_xml_files(root: Path = REPO_ROOT) -> list[Path]:
    files: list[Path] = []
    for p in sorted(root.rglob("*.xml")):
        parts = p.relative_to(root).parts
        if any(part in EXCLUDE_PARTS for part in parts):
            continue
        files.append(p)
    return files


def rel(p: Path) -> str:
    return str(p.relative_to(REPO_ROOT))


def run_wellformed(files: list[Path]) -> Result:
    res = Result("well-formed", total=len(files))
    for f in files:
        proc = subprocess.run(
            ["xmllint", "--noout", str(f)],
            capture_output=True,
            text=True,
        )
        if proc.returncode != 0:
            err = (proc.stderr or proc.stdout).strip()
            print(err)
            first = err.splitlines()[0] if err else "parse error"
            res.failures.append(f"{rel(f)}: {first}")
    return res


def read_schema_ref(xml_file: Path) -> str | None:
    try:
        head = xml_file.read_text(encoding="utf-8", errors="replace")[:4096]
    except OSError:
        return None
    m = SCHEMA_RE.search(head)
    return Path(m.group(1)).name if m else None


def run_schema(files: list[Path]) -> Result:
    res = Result("schema")
    for f in files:
        xsd_name = read_schema_ref(f)
        if not xsd_name:
            continue
        xsd_path = DTD_DIR / xsd_name
        relpath = rel(f)
        if not xsd_path.exists():
            msg = f"{relpath}: schema not found in dtd/ ({xsd_name})"
            print(f"WARN: {msg}")
            res.failures.append(msg)
            continue
        res.total += 1
        print(f"-> {relpath}  (schema: {xsd_name})")
        proc = subprocess.run(
            [
                "xmllint",
                "--noout",
                "--xinclude",
                "--schema",
                str(xsd_path),
                str(f),
            ],
            capture_output=True,
            text=True,
        )
        out = (proc.stderr + proc.stdout).strip()
        if out:
            print(out)
        if proc.returncode != 0:
            res.failures.append(f"{relpath}: validation failed")
    return res


def run_format(files: list[Path]) -> Result:
    res = Result("format", total=len(files))
    proc = subprocess.run(
        ["zpretty", "--check", *[str(f) for f in files]],
        capture_output=True,
        text=True,
    )
    output = proc.stdout + proc.stderr
    if output:
        sys.stdout.write(output if output.endswith("\n") else output + "\n")
    prefix = "This file would be rewritten:"
    for line in output.splitlines():
        if line.startswith(prefix):
            path = line[len(prefix):].strip()
            try:
                path = rel(Path(path).resolve())
            except ValueError:
                pass
            res.failures.append(path)
    return res


PHASES = {
    "well-formed": run_wellformed,
    "schema": run_schema,
    "format": run_format,
}


def emit_output(result: Result) -> None:
    path = os.environ.get("GITHUB_OUTPUT")
    if not path:
        return
    with open(path, "a", encoding="utf-8") as fh:
        fh.write(f"total={result.total}\n")
        fh.write(f"failed={result.failed}\n")


def append_summary(result: Result) -> None:
    path = os.environ.get("GITHUB_STEP_SUMMARY")
    if not path:
        return
    title = PHASE_TITLES.get(result.phase, result.phase)
    status = "passed" if result.ok else "failed"
    lines = [
        f"### {title}: {status}",
        "",
        f"- Files checked: **{result.total}**",
        f"- Failures: **{result.failed}**",
    ]
    if result.failures:
        lines += [
            "",
            f"<details><summary>{result.failed} failing item(s)</summary>",
            "",
            "```",
            *result.failures,
            "```",
            "",
            "</details>",
        ]
    lines.append("")
    with open(path, "a", encoding="utf-8") as fh:
        fh.write("\n".join(lines) + "\n")


def run_phase(phase: str, files: list[Path]) -> int:
    title = PHASE_TITLES[phase]
    print(f"::group::{title}")
    result = PHASES[phase](files)
    print("::endgroup::")
    print(
        f"SUMMARY phase={result.phase} "
        f"total={result.total} failed={result.failed}"
    )
    emit_output(result)
    append_summary(result)
    return 0 if result.ok else 1


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "phase",
        choices=[*PHASES, "all"],
        nargs="?",
        default="all",
    )
    args = parser.parse_args()

    files = find_xml_files()

    if args.phase == "all":
        rc = 0
        for name in PHASES:
            rc |= run_phase(name, files)
        return rc

    return run_phase(args.phase, files)


if __name__ == "__main__":
    sys.exit(main())
