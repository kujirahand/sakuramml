//! Command line front end — the counterpart of `csakura.dpr`.
//!
//! All the I/O lives here; the compiler core stays pure so the same code can
//! run under WASI and in the browser.

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

    let result = sakuramml_core::compile(&source).map_err(|e| format!("Failed...{e}"))?;

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

#[allow(dead_code)]
fn is_mml_file(path: &Path) -> bool {
    path.extension()
        .is_some_and(|e| e.eq_ignore_ascii_case("mml"))
}
