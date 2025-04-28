# mygrep.sh

A custom Bash script that extends and simplifies the functionality of `grep`, offering powerful **case-insensitive searching**, **colored highlighting**, **line numbering**, and **inverted matches** — all in a lightweight, portable, and fully transparent Bash implementation.

---

## Table of Contents
- [Features](#features)
- [Visual Overview](#visual-overview)
- [Installation](#installation)
- [Usage](#usage)
- [Options](#options)
- [Examples](#examples)
- [Internal Code Logic](#internal-code-logic)
- [Error Handling](#error-handling)
- [Design Decisions](#design-decisions)
- [Why Use mygrep.sh?](#why-use-mygrepsh)
- [Author](#author)

---

## Features

✅ **Case-Insensitive Search**: No need to worry about upper- or lowercase.  
✅ **Colored Highlighting**: Matches are highlighted in bright red for easy visibility.  
✅ **Line Numbering (`-n`)**: See exactly where matches occur by line number.  
✅ **Inverted Search (`-v`)**: Display lines that *do not* match the given search term.  
✅ **Combined Flags (`-nv` / `-vn`)**: Combine numbering and inversion for greater flexibility.  
✅ **Help Option (`--help`)**: Quick reference to usage information.  
✅ **Robust Input Validation**: Catch errors early (wrong arguments, missing files, etc.).  
✅ **Minimal Dependencies**: Only requires Bash and Awk — no external tools!

---

## Visual Overview

> Screenshots demonstrating typical usage:

**Figure 1: Help Option Output**  
![Help option example](screenshots/1.png)

---

**Figure 2: Searching for "line" with highlight**  
![Searching for "line"](screenshots/2.png)

---

**Figure 3: Search with Line Numbers (`-n` option)**  
![-n option example](screenshots/3.png)

---

**Figure 4: Inverted Search (`-v` option)**  
![-v option example](screenshots/4.png)

---

**Figure 5: Combined Line Numbers + Inverted Search (`-nv` option)**  
![-nv option example](screenshots/5.png)

---

**Figure 6: Error Handling Examples**  
![error handling](screenshots/6.png)

---

## Installation

Clone or download the repository, then make the script executable:

```bash
chmod +x mygrep.sh
```

No additional installation steps are needed — it runs directly from Bash!

---

## Usage

```bash
# Basic case-insensitive search
./mygrep.sh <search_term> <file>

# Search with line numbers
./mygrep.sh -n <search_term> <file>

# Invert search (show lines NOT matching)
./mygrep.sh -v <search_term> <file>

# Inverted search with line numbers
./mygrep.sh -nv <search_term> <file>
./mygrep.sh -vn <search_term> <file>

# Show help information
./mygrep.sh --help
```

---

## Options

| Option | Description |
|:------:|:------------|
| `-n` | Show line numbers along with matching lines. |
| `-v` | Show lines **not** matching the search term. |
| `-nv` or `-vn` | Combine both `-n` and `-v`. |
| `--help` | Display syntax and usage help. |

**Notes**:
- Options must appear **before** the search term and file.
- Search is **always case-insensitive**.

---

## Examples

```bash
# Highlight all occurrences of "apple" in fruits.txt
./mygrep.sh apple fruits.txt

# Show line numbers when searching for "banana"
./mygrep.sh -n banana fruits.txt

# Show lines that don't mention "TODO"
./mygrep.sh -v TODO notes.txt

# Show numbered lines that do not contain "hello"
./mygrep.sh -nv hello example.txt
```

---

## Internal Code Logic

**1. Parse Command-Line Arguments**  
The script first checks if the user requested `--help`, or if options like `-n`, `-v`, or `-nv`/`-vn` were passed.  
It sets flags (`show_line_numbers`, `invert_search`) accordingly and shifts positional arguments.

**2. Validate Inputs**  
It ensures:
- Correct number of arguments provided.
- The specified file exists and is a regular file.

Otherwise, it shows usage instructions and exits gracefully.

**3. Read and Process File Line-by-Line**  
The file is read using a `while read` loop. For each line:
- Case-insensitive matching is done by converting both the line and search term to lowercase (`${line,,}` and `${search_term,,}`).
- If a match (or non-match, for `-v`) is found:
  - If highlighting is needed, an `awk` command is used to wrap matched terms in ANSI escape codes (bright red).
  - Line numbers are optionally prepended if `-n` is enabled.

**4. Highlight Matches**  
The `Highlight()` function:
- Escapes special characters to avoid breaking patterns.
- Uses `awk`'s `gsub()` function with `IGNORECASE=1` to replace matching parts with colored versions.

---

## Error Handling

The script handles:
- **Incorrect argument counts**: Clear message + syntax help.
- **Nonexistent files**: Clear error stating the file wasn't found.
- **Unrecognized options**: Defaults to showing usage information.

This improves user experience and prevents confusing failures.

---

## Design Decisions

- **Case-Insensitive by Default**: Simplifies command usage without needing a `-i` flag.
- **Special Characters**: The script safely escapes characters like `.`, `*`, `[`, `]`, and `|` from the search term while highlighting to avoid unintended regex behavior.
- **Awk for Highlighting**: Faster and more powerful than `sed` or pure Bash string manipulation for highlighting.
- **Shifted Positional Parameters**: After detecting options, `shift` allows treating the search term and filename uniformly.

---

## Why Use mygrep.sh?

✨ **Educational**: Learn real Bash scripting concepts like argument parsing, validation, loops, and text processing.  
✨ **Portable**: Works on any Unix/Linux/Mac system — even inside Docker containers!  
✨ **Customizable**: Easy to extend — add new options like regex support or case-sensitivity toggling.  
✨ **Efficient**: No unnecessary external dependencies.  
✨ **Clear and User-Friendly**: Always guides the user with helpful error messages.

---

## Author

**Hesha**  
- Developed during the **Fawry Internship Program** 2025.  
- Focused on improving Bash scripting, text parsing, user experience, and CLI tool design.

---

