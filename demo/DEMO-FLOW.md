# NIH Demo Flow
## Continuous ATO - Pipeline Evidence Collection

**Duration:** ~20-25 minutes total (3 slides + live demo)
**Customer:** NHLBI/NIH
**Priority Items:** Evidence Collection, Continuous ATO, Compliance-Engineering Alignment

---

## Pre-Demo Setup

```bash
# Terminal 1: Have the app running locally
docker-compose up -d

# Terminal 2: Ready to trigger pipeline
cd /Users/nkennedy/proj/dropbox-clone

# Browser tabs ready:
# 1. Slides: file:///Users/nkennedy/proj/dropbox-clone/demo/slides-nih.html
# 2. GitHub repo (this repo)
# 3. GitHub Actions tab
# 4. Judge dashboard (or Archivista UI)
```

---

## Part 1: Slides (5-7 minutes)

### Slide 1: The Problem
**Key message:** Manual evidence recording doesn't scale.

**Talking points:**
- "Your developers are screenshotting pipeline runs"
- "Compliance documentation is 6 months behind what's actually deployed"
- "AI-assisted development is about to 10x the rate of code changes"
- "Manual processes can't keep up—you need evidence as a byproduct, not an afterthought"

**Transition:** "So what's the alternative?"

---

### Slide 2: The Solution
**Key message:** Evidence FROM the pipeline, not ABOUT the pipeline.

**Talking points:**
- Walk through the 3 pillars—these map directly to your stated priorities:
  1. **Pipeline Evidence Collection** → "Every build generates signed proof"
  2. **Continuous ATO** → "Real-time status, not annual snapshots"
  3. **Eng + Compliance Alignment** → "Same dashboard, no more chasing"

**Digital Twin callout:**
- "We analyze your code and CI/CD—we never touch production"
- "No access to running systems, no HIPAA/sensitive data concerns"
- "This is critical for healthcare environments"

**Transition:** "Let me show you exactly how this works."

---

### Slide 3: Demo Setup
**Key message:** Here's what you're about to see.

**Talking points:**
- Walk through the 4-step flow quickly
- "This is a Go application running on an internal development platform"
- "We'll push code, watch the pipeline run, and see evidence generated automatically"
- "Then we'll show how that evidence maps to NIST 800-53 controls"

**Transition:** "Let's switch to the live environment."

---

## Part 2: Live Demo (15-18 minutes)

### Demo Step 1: Show the Application (2 min)
**What to show:**
- Brief tour of the dropbox-clone codebase
- Point out it's a standard Go application with nothing special about the code itself

**Talking points:**
- "This is a typical internal application—file storage service"
- "Nothing compliance-specific in the code"
- "The magic happens in the pipeline"

---

### Demo Step 2: Show the Pipeline (3 min)
**What to show:**
- `.github/workflows/ci.yaml`
- Point out Witness integration
- Highlight Semgrep SAST step

**Talking points:**
- "Standard GitHub Actions pipeline"
- "We've added Witness to wrap each step"
- "Semgrep runs static analysis—this is your open-source SAST"
- "Every step generates a cryptographically signed attestation"

**Key file to show:**
```yaml
# .github/workflows/ci.yaml
- name: Run Semgrep SAST
  uses: returntocorp/semgrep-action@v1
  with:
    config: p/default

- name: Generate Attestation
  uses: testifysec/witness-run-action@v0.1
  with:
    step: "sast-scan"
    attestations: "sarif"
```

---

### Demo Step 3: Trigger the Pipeline (2 min)
**What to do:**
- Make a small code change (or use a prepared commit)
- Push to GitHub
- Watch Actions tab

**Talking points:**
- "I'm pushing a code change now"
- "Watch the pipeline kick off automatically"
- "Each green checkmark is generating signed evidence"

---

### Demo Step 4: Show Evidence Generated (5 min)
**What to show:**
- Attestation JSON output
- Signed envelope structure
- Link to Archivista storage

**Talking points:**
- "Here's what Witness captured automatically"
- "This is cryptographically signed—can't be tampered with"
- "Includes: what ran, exit codes, inputs, outputs, who authorized it"
- "This is your audit trail, generated at the moment of execution"

**Example attestation to highlight:**
```json
{
  "type": "https://witness.dev/attestations/command-run/v0.1",
  "attestation": {
    "cmd": ["semgrep", "--config=auto", "."],
    "exitcode": 0
  },
  "materials": [...],
  "products": [...],
  "signature": "MEUCIQD..."
}
```

---

### Demo Step 5: Control Mapping (5 min)
**What to show:**
- How attestations map to NIST controls
- Dashboard view (Judge or equivalent)

**Controls to highlight:**

| Control | Evidence Source |
|---------|----------------|
| **SA-11** (Developer Security Testing) | Semgrep SAST attestation |
| **CM-3** (Configuration Change Control) | Git commit attestation |
| **SI-7** (Software Integrity) | Build artifact hash attestation |
| **AU-2** (Audit Events) | Pipeline execution attestation |

**Talking points:**
- "SA-11 requires developer security testing—here's cryptographic proof Semgrep ran"
- "CM-3 requires change control—here's every commit signed and traced"
- "The compliance team can query this directly—no chasing engineers"
- "If this dashboard shows green, you're compliant. If something drifts, you get alerted."

---

### Demo Step 6: Continuous ATO Value (2 min)
**What to show:**
- Real-time status
- What happens when evidence is missing (drift)

**Talking points:**
- "This isn't a point-in-time snapshot—it's continuous"
- "Every build updates your compliance posture"
- "If a scan stops running, compliance knows immediately"
- "No more 6-month documentation lag"

---

## Part 3: Wrap-Up (2-3 min)

### Key Takeaways
1. **Evidence collection is automated** — no manual screenshots
2. **Continuous ATO** — always know your compliance status
3. **Engineering keeps shipping** — compliance self-serves evidence

### The Ask
- "We'd like to schedule a deeper technical session"
- "We can set this up in your environment in a lab engagement"
- "What questions do you have?"

---

## Objection Handling

**"How does this integrate with our existing pipeline?"**
> "We augment, not replace. Witness wraps your existing steps. Works with GitHub, GitLab, Jenkins—whatever you're running."

**"What about air-gapped environments?"**
> "Witness and Archivista work fully offline. Evidence stays in your boundary."

**"Can we trust AI-generated compliance docs?"**
> "The AI writes FROM evidence, not imagination. Every statement traces back to signed attestations from your actual pipeline."

**"What if we want to go direct to TestifySec?"**
> [Partnership positioning] "We're your implementation partner. We handle the integration, customization, and ongoing support. TestifySec provides the technology; we make it work in your environment."

---

## Files to Prepare

1. **Slides:** `demo/slides-nih.html`
2. **Sample attestation JSON:** Have one ready to show
3. **CI workflow with Witness:** `.github/workflows/ci.yaml`
4. **Control mapping table:** Screenshot or dashboard view

---

## Technical Requirements for Demo

- [ ] GitHub repo with Actions enabled
- [ ] Witness CLI installed
- [ ] Semgrep configured in pipeline
- [ ] Archivista running (or mock data ready)
- [ ] Judge dashboard access (or screenshots)
- [ ] Stable internet for live demo

**Backup plan:** Pre-recorded video of pipeline run if live demo fails.
