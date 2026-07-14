# Regi — Bench Protocol Timers

A single-file web app for running wet-lab protocols with **click-to-trigger, parallel timers**
and a persistent **run log** that shows drift between planned and actual step durations.

Built for workflows that *aren't* a fixed auto-advancing schedule — you trigger each step by hand
as the bench work allows, and often run the same step for several samples staggered a few minutes
apart (e.g. free-floating IHC sections dropped into wells one at a time).

## Run it

**Recommended (macOS): double-click `Regi.command`.** It starts a tiny local web server and opens
the app in your browser, with **saving enabled**. Leave the Terminal window it opens running while
you use Regi; closing it (or pressing Ctrl+C) stops the server. The first time, macOS Gatekeeper
may block it — right-click `Regi.command` → **Open** → **Open** to approve it once.

**Or just open the file:** double-click `index.html` (or drag it into any browser). No build, no
dependencies, works fully offline.

> ⚠️ **Saving and `file://`.** When opened directly as a file, some browsers (Safari, Firefox
> private mode) block `localStorage`, so Regi runs but **can't save** your protocols or run log
> between sessions — you'll see a one-time console warning if so. Chrome saves fine from a file.
> To guarantee saving everywhere, use the `Regi.command` launcher above, or serve the folder
> manually:
> ```
> python3 -m http.server 8000
> ```
> then open http://localhost:8000/index.html

> 🎤 **Voice dictation needs Chrome or Safari, and a network connection.** Firefox doesn't support
> the browser's speech API — the 🎤 buttons simply don't appear there. In supported browsers,
> transcription happens server-side, so dictation won't work fully offline; typing always does.

## Using it

- **Run** — the active protocol's steps, each with a troubleshooting note and tappable parameter
  **chips**. Tap a chip to start a countdown. **Tap the same chip again** to start a second,
  independent timer in parallel (for staggered samples). A badge shows how many are running.
- **Active Timers dock** (bottom of every view) — each timer has a live countdown, progress bar,
  and **Pause / Resume** and **Stop**. When a timer completes, an **alarm sounds** and the card
  flashes until you **Dismiss** it. Use **Silence** to quiet the alarm.
- **Edit** — rename the protocol, add / delete / reorder steps (▲▼), edit troubleshooting notes,
  and add / delete / reorder parameters with a default duration (minutes + seconds). Reorder
  parameters by **dragging the ⠿ handle** (the ▲▼ arrows still work as a fallback on touch). Use
  the **⋯** menu next to the protocol pill to create a new protocol, duplicate the current one, or
  delete it (disabled when it's your only one). Every text field (protocol name/description, step
  title, note, parameter label) has a **🎤 dictate button** — tap it and speak to fill the field
  hands-free; speaking again appends rather than replacing.
- **Run Log** — every stopped or completed timer is recorded with planned vs. actual time and
  **drift** (actual − planned, colored). A per-parameter summary shows mean drift across runs so
  systematic drift is visible over time. Filter by protocol / parameter, **Export JSON** for
  backup, or **Clear log**.

## Data & persistence

Everything is stored locally in your browser via `localStorage` (keys prefixed `regi.`):

- `regi.protocols` — your protocols, steps, and parameters
- `regi.runlog` — the run history
- `regi.activeProtocolId`, `regi.schemaVersion`

Protocols and the run log **persist across sessions**. Running timers are intentionally **not**
persisted — reloading or closing the tab clears in-flight timers (you'll get a browser warning
first). Timing is wall-clock based, so remaining time stays accurate even if the tab is
backgrounded or throttled.

Data is per-browser/per-device. Use **Run Log → Export JSON** to back up or move data.

## Sample data

Regi opens **blank** — a welcome screen prompts you to create a protocol. If you'd rather start
from an example, the welcome screen offers a one-click **IHC (free-floating sections)** sample
protocol, fully editable like any other. Delete it any time — deleting your last protocol just
returns you to the welcome screen.
