const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const srcConfig = path.join(rootDir, 'scorecard', 'scorecard_config.json');
const srcVulns = path.join(rootDir, 'scorecard', 'web', 'vulns_exported.json');

const destDir = path.join(rootDir, 'apps', 'web', 'data');
const destConfig = path.join(destDir, 'config.json');
const destVulns = path.join(destDir, 'vulns.json');

// Ensure destination directory exists
if (!fs.existsSync(destDir)) {
  fs.mkdirSync(destDir, { recursive: true });
}

try {
  if (fs.existsSync(srcConfig)) {
    fs.copyFileSync(srcConfig, destConfig);
    console.log(`✅ Synced config from ${srcConfig} to ${destConfig}`);
  } else {
    console.warn(`⚠️ Source config not found at ${srcConfig}`);
  }

  if (fs.existsSync(srcVulns)) {
    fs.copyFileSync(srcVulns, destVulns);
    console.log(`✅ Synced vulnerabilities from ${srcVulns} to ${destVulns}`);
  } else {
    console.warn(`⚠️ Source vulnerabilities not found at ${srcVulns}`);
  }
} catch (error) {
  console.error('❌ Data synchronization failed:', error);
  process.exit(1);
}
