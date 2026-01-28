use clap::Parser;
use regex::Regex;
use std::fs;
use std::path::{Path, PathBuf};
use walkdir::WalkDir;
use yaml_rust::YamlLoader;

#[derive(Parser, Debug)]
#[command(author, version, about)]
struct Args {
    #[arg(long, default_value = "rules/sui_vuln_rules.yaml")]
    rules: PathBuf,
    #[arg(long)]
    path: PathBuf,
}

#[derive(Debug, Clone)]
struct Rule {
    name: String,
    description: String,
    pattern: Regex,
    severity: String,
}

fn load_rules(path: &Path) -> anyhow::Result<Vec<Rule>> {
    let raw = fs::read_to_string(path)?;
    let docs = YamlLoader::load_from_str(&raw)?;
    let doc = docs
        .get(0)
        .ok_or_else(|| anyhow::anyhow!("empty rules file"))?;
    let rules_yaml = doc["rules"].as_vec().ok_or_else(|| anyhow::anyhow!("rules missing"))?;

    let mut rules = Vec::new();
    for r in rules_yaml {
        let name = r["name"].as_str().unwrap_or("unnamed").to_string();
        let description = r["description"].as_str().unwrap_or("").to_string();
        let pattern_str = r["pattern"].as_str().unwrap_or("");
        let pattern = Regex::new(pattern_str)?;
        let severity = r["severity"].as_str().unwrap_or("info").to_string();
        rules.push(Rule { name, description, pattern, severity });
    }

    Ok(rules)
}

fn collect_move_files(path: &Path) -> Vec<PathBuf> {
    if path.is_file() {
        return vec![path.to_path_buf()];
    }
    WalkDir::new(path)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_type().is_file())
        .filter(|e| e.path().extension().map(|ext| ext == "move").unwrap_or(false))
        .map(|e| e.path().to_path_buf())
        .collect()
}

fn main() -> anyhow::Result<()> {
    let args = Args::parse();
    let rules = load_rules(&args.rules)?;
    let files = collect_move_files(&args.path);

    for file in files {
        let code = fs::read_to_string(&file)?;
        for rule in &rules {
            if rule.pattern.is_match(&code) {
                println!(
                    "[VULN] {}: {} (Severity: {}) in {}",
                    rule.name,
                    rule.description,
                    rule.severity,
                    file.display()
                );
            }
        }
    }

    // Optional: integrate move-lint core here for deeper rules.
    Ok(())
}
