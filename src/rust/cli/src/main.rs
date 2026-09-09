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
        // Showing usage is not a failure, and neither is --version.
        Err(Failure::Usage(message)) => {
            println!("{message}");
            ExitCode::SUCCESS
        }
        Err(Failure::Error(message)) => {
            eprintln!("{message}");
            ExitCode::FAILURE
        }
    }
}

/// Why the run stopped: something the user asked for, or something wrong.
enum Failure {
    Usage(String),
    Error(String),
}

impl From<String> for Failure {
    fn from(message: String) -> Self {
        Failure::Error(message)
    }
}

fn run(args: &[String]) -> Result<(), Failure> {
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

    if options.pause {
        let mut line = String::new();
        let _ = std::io::stdin().read_line(&mut line);
    }
    Ok(())
}

enum Source {
    File(PathBuf),
    Inline(String),
}

struct Options {
    source: Source,
    output: Option<PathBuf>,
    /// `-pause`: wait for Enter before exiting.
    pause: bool,
}

fn parse_args(args: &[String]) -> Result<Options, Failure> {
    let mut inline: Option<String> = None;
    let mut positional: Vec<PathBuf> = Vec::new();
    let mut pause = false;
    let mut index = 0;

    while index < args.len() {
        match args[index].as_str() {
            "-e" => {
                index += 1;
                let code = args
                    .get(index)
                    .ok_or_else(|| Failure::Error("-e にMMLを指定してください".to_string()))?;
                inline = Some(code.clone());
            }
            "-h" | "--help" => return Err(Failure::Usage(help_text())),
            "-v" | "--version" => return Err(Failure::Usage(format!("sakuramml {VERSION}"))),
            // Kept for compatibility with the Pascal build, which used it to
            // keep a console window open after compiling.
            "-pause" => pause = true,
            other => positional.push(PathBuf::from(other)),
        }
        index += 1;
    }

    // Unlike the Pascal version, `-e code out.mid` honours the output path.
    match inline {
        Some(code) => Ok(Options {
            source: Source::Inline(code),
            output: positional.first().map(PathBuf::from),
            pause,
        }),
        None => {
            let input = positional
                .first()
                .ok_or_else(|| Failure::Usage(help_text()))?;
            Ok(Options {
                source: Source::File(input.clone()),
                output: positional.get(1).cloned(),
                pause,
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
        // The working directory and its ancestors, so `-e` (which has no
        // source file) still finds the project's Include/ directory.
        if let Ok(cwd) = std::env::current_dir() {
            let mut dir = cwd;
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_inline_source_and_output() {
        let args = vec!["-e".into(), "cde".into(), "song.mid".into()];
        let options = match parse_args(&args) {
            Ok(options) => options,
            Err(_) => panic!("inline arguments should parse"),
        };
        assert!(matches!(options.source, Source::Inline(ref code) if code == "cde"));
        assert_eq!(options.output, Some(PathBuf::from("song.mid")));
        assert!(!options.pause);
    }

    #[test]
    fn parses_file_source_output_and_pause() {
        let args = vec!["input.mml".into(), "output.mid".into(), "-pause".into()];
        let options = match parse_args(&args) {
            Ok(options) => options,
            Err(_) => panic!("file arguments should parse"),
        };
        assert!(matches!(options.source, Source::File(ref path) if path == Path::new("input.mml")));
        assert_eq!(options.output, Some(PathBuf::from("output.mid")));
        assert!(options.pause);
    }

    #[test]
    fn missing_inline_source_is_an_error() {
        let args = vec!["-e".into()];
        assert!(matches!(parse_args(&args), Err(Failure::Error(_))));
    }
}
