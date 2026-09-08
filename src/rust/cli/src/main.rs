//! Command line front end — the counterpart of `csakura.dpr`.
//!
//! All the I/O lives here; the compiler core stays pure so the same code can
//! run under WASI and in the browser.

use sakuramml_core::IncludeResolver;
use std::path::{Path, PathBuf};
use std::process::ExitCode;

const VERSION: &str = env!("CARGO_PKG_VERSION");

fn main() -> ExitCode {
    let args: Vec<String> = std::env::args().skip(1).collect();
    match run(&args) {
        Ok(()) => ExitCode::SUCCESS,
        Err(message) => {
            eprintln!("{message}");
            ExitCode::FAILURE
        }
    }
}

fn run(args: &[String]) -> Result<(), String> {
    let options = parse_args(args)?;

    let (source, origin) = match &options.source {
        Source::Inline(code) => (code.clone(), None),
        Source::File(path) => {
            let bytes = std::fs::read(path).map_err(|e| {
                format!(
                    "Failed .. Could not load mml file: {} ({e})",
                    path.display()
                )
            })?;
            let (text, _) = sakuramml_core::encoding::decode_auto(&bytes);
            (text, Some(path.clone()))
        }
    };

    let output_path = options.output.clone().unwrap_or_else(|| match &origin {
        Some(path) => path.with_extension("mid"),
        None => PathBuf::from("a.mid"),
    });

    let resolver = FileIncludes::new(origin.as_deref());
    let result =
        sakuramml_core::compile_with(&source, &resolver).map_err(|e| format!("Failed...{e}"))?;

    for message in &result.messages {
        println!("[表示] {message}");
    }
    for warning in &result.warnings {
        eprintln!("{warning}");
    }

    std::fs::write(&output_path, &result.smf).map_err(|e| {
        format!(
            "Failed .. Could not write midi file: {} ({e})",
            output_path.display()
        )
    })?;

    println!("Success!");
    Ok(())
}

enum Source {
    File(PathBuf),
    Inline(String),
}

struct Options {
    source: Source,
    output: Option<PathBuf>,
}

fn parse_args(args: &[String]) -> Result<Options, String> {
    let mut inline: Option<String> = None;
    let mut positional: Vec<PathBuf> = Vec::new();
    let mut index = 0;

    while index < args.len() {
        match args[index].as_str() {
            "-e" => {
                index += 1;
                let code = args.get(index).ok_or("-e にMMLを指定してください")?;
                inline = Some(code.clone());
            }
            "-h" | "--help" => return Err(help_text()),
            "-v" | "--version" => return Err(format!("sakuramml {VERSION}")),
            other => positional.push(PathBuf::from(other)),
        }
        index += 1;
    }

    // Unlike the Pascal version, `-e code out.mid` honours the output path.
    match inline {
        Some(code) => Ok(Options {
            source: Source::Inline(code),
            output: positional.first().map(PathBuf::from),
        }),
        None => {
            let input = positional.first().ok_or_else(help_text)?;
            Ok(Options {
                source: Source::File(input.clone()),
                output: positional.get(1).cloned(),
            })
        }
    }
}

fn help_text() -> String {
    format!(
        "=== MML Compiler sakuramml (Rust) ===\n\
         version {VERSION}\n\
         [USAGE]\n\
         csakura mmlfile [midifile]\n\
         csakura -e mmlcode [midifile]"
    )
}

/// Finds `#Include` files on disk.
///
/// Searches the same places the Pascal build does: next to the source file,
/// the current directory, and an `Include/` directory in either — plus next to
/// the executable, for an installed copy.
struct FileIncludes {
    roots: Vec<PathBuf>,
}

impl FileIncludes {
    fn new(source: Option<&Path>) -> Self {
        let mut roots = Vec::new();
        // The source file's directory, then its ancestors: include files
        // usually live in an Include/ directory at the top of the project.
        if let Some(dir) = source.and_then(|p| p.parent()) {
            let mut dir = dir.to_path_buf();
            for _ in 0..8 {
                roots.push(dir.clone());
                if !dir.pop() {
                    break;
                }
            }
        }
        roots.push(PathBuf::from("."));
        if let Ok(exe) = std::env::current_exe() {
            if let Some(dir) = exe.parent() {
                roots.push(dir.to_path_buf());
            }
        }
        // Each root may hold the file directly or under Include/.
        let with_include: Vec<PathBuf> = roots.iter().map(|r| r.join("Include")).collect();
        roots.extend(with_include);
        Self { roots }
    }
}

impl IncludeResolver for FileIncludes {
    fn resolve(&self, name: &str) -> Option<Vec<u8>> {
        self.roots
            .iter()
            .map(|root| root.join(name))
            .find_map(|path| std::fs::read(path).ok())
    }
}
