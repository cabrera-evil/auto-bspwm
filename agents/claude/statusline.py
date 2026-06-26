#!/usr/bin/env python3
import json
import sys
import os
import re
import time
import logging

LOG = os.path.expanduser("~/.claude/statusline.log")
logging.basicConfig(filename=LOG, level=logging.DEBUG, format="%(asctime)s %(message)s")

RESET  = "\033[0m"
DIM    = "\033[2m"
GREEN  = "\033[32m"
YELLOW = "\033[33m"
ORANGE = "\033[38;5;208m"
BRED   = "\033[1;31m"
SEP    = f" \033[2m│\033[0m "

def usage_color(pct):
    if pct < 60:   return GREEN
    if pct < 80:   return YELLOW
    if pct < 90:   return ORANGE
    return BRED

def fmt_k(n):
    if n is None: return "?"
    return f"{round((n or 0) / 1000)}K"

def fmt_duration(seconds):
    seconds = int(seconds)
    if seconds <= 0:  return "now"
    if seconds < 3600:
        return f"{seconds // 60}m"
    if seconds < 86400:
        h, m = divmod(seconds, 3600)
        m //= 60
        return f"{h}h{m:02d}m" if m else f"{h}h"
    d, rem = divmod(seconds, 86400)
    h = rem // 3600
    return f"{d}d{h:02d}h"

def fmt_reset(resets_at, pct):
    diff = int(resets_at) - int(time.time())
    label = "now" if diff <= 0 else fmt_duration(diff)
    return f"{DIM} in {RESET}{label}"

def model_label(model, full=True):
    m = re.sub(r"^claude-", "", model or "")
    match = re.search(r"(\d+)-(\d+)(?:-\d+)?$", m)
    if match:
        name = m[:match.start()].rstrip("-").replace("-", " ").title()
        ver  = f"{match.group(1)}.{match.group(2)}"
        label = f"{name} {ver}"
    else:
        label = m.replace("-", " ").title()
    return (f"Claude {label}" if full else label)

def bar(pct, width=10):
    filled = min(round(pct / 100 * width), width)
    return f"▕{'█' * filled}{'░' * (width - filled)}▏"

def tilde(path):
    home = os.path.expanduser("~")
    return ("~" + path[len(home):]) if path.startswith(home) else path

def render(data, columns):
    model_obj = data.get("model") or {}
    model   = model_obj.get("id", "") if isinstance(model_obj, dict) else str(model_obj)
    cwd     = data.get("cwd", "") or (data.get("workspace") or {}).get("current_dir", "")
    ctx     = data.get("context_window", {}) or {}
    rl      = data.get("rate_limits", {}) or {}

    ctx_pct  = ctx.get("used_percentage") or 0
    ctx_used = ctx.get("total_input_tokens") or 0
    ctx_max  = ctx.get("context_window_size") or 0

    cur = ctx.get("current_usage") or {}
    tok_in  = cur.get("input_tokens", 0) or 0
    tok_cr  = cur.get("cache_read_input_tokens", 0) or 0
    tok_cw  = cur.get("cache_creation_input_tokens", 0) or 0
    tok_out = cur.get("output_tokens", 0) or 0

    dur_ms  = 0  # not provided in current schema

    fh     = rl.get("five_hour", {})
    sd     = rl.get("seven_day", {})
    fh_pct = fh.get("used_percentage")
    fh_at  = fh.get("resets_at", 0)
    sd_pct = sd.get("used_percentage")
    sd_at  = sd.get("resets_at", 0)

    if fh_pct is not None:
        logging.debug(f"FiveHourUsed: {fh_pct:.3f}")
        logging.debug(f"FiveHourResetsAt: {fh_at}")
    if sd_pct is not None:
        logging.debug(f"SevenDayUsed: {sd_pct:.3f}")
        logging.debug(f"SevenDayResetsAt: {sd_at}")

    has_usage = fh_pct is not None and sd_pct is not None

    def usage_seg(show_label=True):
        prefix = f"{DIM}USAGE {RESET}" if show_label else ""
        if not has_usage:
            return f"{prefix}{DIM}5H {RESET}--{DIM} · 7D {RESET}--"
        fc = usage_color(fh_pct)
        sc = usage_color(sd_pct)
        fr = fmt_reset(fh_at, fh_pct)
        sr = fmt_reset(sd_at, sd_pct)
        return (
            f"{prefix}{DIM}5H {RESET}{fc}{fh_pct:.0f}%{RESET}{fr}"
            f"{DIM} · 7D {RESET}{sc}{sd_pct:.0f}%{RESET}{sr}"
        )

    dur = fmt_duration(dur_ms // 1000) if dur_ms else ""

    if columns >= 150:
        parts = [
            model_label(model, full=True),
            tilde(cwd),
            f"CTX {bar(ctx_pct)} {ctx_pct:.0f}% {fmt_k(ctx_used)}/{fmt_k(ctx_max)}",
            f"TOK {fmt_k(tok_in)}·{fmt_k(tok_cr)}·{fmt_k(tok_cw)}·{fmt_k(tok_out)}",
            usage_seg(show_label=True),
            dur,
        ]
    elif columns >= 120:
        parts = [
            model_label(model, full=False),
            os.path.basename(cwd) or cwd,
            f"{bar(ctx_pct)} {ctx_pct:.0f}% {fmt_k(ctx_used)}/{fmt_k(ctx_max)}",
            usage_seg(show_label=False),
            dur,
        ]
    elif columns >= 90:
        parts = [
            model_label(model, full=False),
            os.path.basename(cwd) or cwd,
            f"CTX {ctx_pct:.0f}% {fmt_k(ctx_used)}/{fmt_k(ctx_max)}",
            usage_seg(show_label=False),
        ]
    else:
        parts = [
            model_label(model, full=False),
            f"CTX {ctx_pct:.0f}%",
            usage_seg(show_label=False),
        ]

    return SEP.join(p for p in parts if p)


def main():
    try:
        raw  = sys.stdin.read()
        data = json.loads(raw) if raw.strip() else {}
    except Exception as e:
        logging.error(f"parse error: {e}")
        data = {}

    columns = int(os.environ.get("COLUMNS", "150"))

    try:
        print(render(data, columns))
    except Exception as e:
        logging.error(f"render error: {e}")


if __name__ == "__main__":
    main()
