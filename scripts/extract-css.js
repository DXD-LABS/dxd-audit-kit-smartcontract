const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const indexHtmlPath = path.join(rootDir, 'scorecard', 'web', 'index.html');
const globalsCssPath = path.join(rootDir, 'apps', 'web', 'app', 'globals.css');

if (!fs.existsSync(indexHtmlPath)) {
  console.error(`❌ Source index.html not found at ${indexHtmlPath}`);
  process.exit(1);
}

const htmlContent = fs.readFileSync(indexHtmlPath, 'utf8');

// Find style block
const styleStartTag = '<style>';
const styleEndTag = '</style>';

const startIndex = htmlContent.indexOf(styleStartTag);
const endIndex = htmlContent.indexOf(styleEndTag);

if (startIndex === -1 || endIndex === -1) {
  console.error('❌ Could not find <style> or </style> tags in index.html');
  process.exit(1);
}

const cssContent = htmlContent.substring(startIndex + styleStartTag.length, endIndex).trim();

// Next.js Tailwind 4 global css template
const newGlobalsCss = `@import "tailwindcss";

${cssContent}

/* Override fonts to use Next.js font variables */
:root {
  --font-display: var(--font-outfit), -apple-system, sans-serif;
  --font-mono: var(--font-fira-code), monospace;
}

body {
  font-family: var(--font-display);
}

/* Ensure next-js main container fits the body flex structure */
header {
  width: 100%;
}

main {
  flex: 1;
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 1.5rem;
}

/* Additional UI fixes for Next.js layout structure */
.tabs-nav {
  position: sticky;
  top: 0;
  z-index: 50;
  background-color: var(--bg-base);
  border-bottom: 1px solid var(--border-subtle);
  backdrop-filter: blur(12px);
}
`;

fs.writeFileSync(globalsCssPath, newGlobalsCss, 'utf8');
console.log(`✅ Extracted CSS from index.html to ${globalsCssPath}`);
