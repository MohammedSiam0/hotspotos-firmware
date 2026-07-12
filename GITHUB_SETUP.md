# GitHub Actions Setup Guide - HotspotOS

## Quick Start (5 minutes)

### Step 1: Create GitHub Repository
1. Go to https://github.com/new
2. Name: `hotspotos-firmware`
3. Visibility: Public (free builds) or Private
4. Check "Add a README file"
5. Click "Create repository"

### Step 2: Upload Files
```bash
# On your local machine
git clone https://github.com/YOUR_USERNAME/hotspotos-firmware.git
cd hotspotos-firmware

# Copy all HotspotOS files here
# (extract the zip we provided)

git add .
git commit -m "HotspotOS v1.0.0 - Initial release"
git push origin main
```

### Step 3: Trigger Build
1. Go to your repository on GitHub
2. Click "Actions" tab
3. Click "Build HotspotOS Firmware" workflow
4. Click "Run workflow" button
5. Select your target (default: lantiq/xrx200)
6. Click "Run workflow"

### Step 4: Download Firmware
1. Wait 2-4 hours for build to complete
2. Go to "Actions" tab → click the completed run
3. Scroll to "Artifacts" section
4. Download:
   - `hotspotos-firmware-lantiq-xrx200-23.05.6` (contains .bin files)
   - `hotspotos-packages-lantiq-xrx200` (contains .ipk files)

### Step 5: Create Release (Optional)
```bash
# Tag a release
git tag -a v1.0.0 -m "HotspotOS v1.0.0 Release"
git push origin v1.0.0
```
This automatically creates a GitHub Release with all firmware files attached.

---

## Build Status Monitoring

During build, you can monitor progress:
1. Go to Actions tab
2. Click the running workflow
3. Expand each step to see logs
4. Build takes 2-4 hours depending on GitHub's load

---

## Troubleshooting

### Build fails at "Download sources"
- This is usually network timeout
- GitHub Actions will retry automatically
- If still failing, re-run the workflow

### Build fails at "Build firmware"
- Check the build log in the Actions output
- Common issues:
  - Missing dependencies (fixed in our workflow)
  - Disk space (we clean up before build)
  - Memory (GitHub provides 7GB, usually enough)

### Artifact not found
- Build might have failed
- Check the build logs
- Re-run the workflow

---

## Free vs Paid

| Feature | Free | GitHub Pro |
|---------|------|------------|
| Build time | 2000 min/month | 3000 min/month |
| Storage | 500 MB | 2 GB |
| Retention | 90 days | 90 days |
| Concurrent | 20 jobs | 40 jobs |

**For HotspotOS:** Free tier is more than enough (one build ~4 hours = 240 min)

---

## Alternative: Self-Hosted Runner

If you have your own server:
```bash
# On your Linux server
curl -fsSL https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64-2.311.0.tar.gz | tar xz
./config.sh --url https://github.com/YOUR_USERNAME/hotspotos-firmware --token YOUR_TOKEN
./run.sh
```
Then builds run on YOUR server instead of GitHub's.
