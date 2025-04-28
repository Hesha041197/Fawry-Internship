#!/bin/bash

# Syntax function to show the correct syntax
Syntax() {
    echo "Usage: $0 [-n] [-v] search_term file"
    echo ""
    echo "Options:"
    echo "  -n    Show line numbers with matches."
    echo "  -v    Invert match (show non-matching lines)."
    echo "  --help  Show this help message."
}

# CheckArg function to verify argument count
CheckArg() {
    if [ "$#" -ne 2 ]; then
        echo "Error: Incorrect number of arguments."
        echo ""
        Syntax
        exit 1
    fi
}

# CheckFile function to verify file existence
CheckFile() {
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found."
        echo ""
        Syntax
        exit 1
    fi
}

# Highlight function to color matched terms
Highlight() {
    text="$1"
    term="$2"
    RED='\033[1;31m'
    NC='\033[0m'

    safe_term=$(printf '%s\n' "$term" | sed 's/[]\/$*.^|[]/\\&/g')

    echo "$text" | awk -v term="$safe_term" -v red="$RED" -v nc="$NC" '
    BEGIN { IGNORECASE = 1 }
    {
        gsub(term, red "&" nc)
        print
    }'
}

# Initialize flags
show_line_numbers=false
invert_search=false

# If --help is provided
if [[ "$1" == "--help" ]]; then
    Syntax
    exit 0
fi

# Parse options using getopts
while getopts ":nv" opt; do
    case $opt in
        n) show_line_numbers=true ;;
        v) invert_search=true ;;
        \?) 
            echo "Invalid option: -$OPTARG"
            Syntax
            exit 1
            ;;
    esac
done

# Shift parsed options
shift $((OPTIND -1))

# Assign positional parameters
search_term="$1"
file="$2"

# Validate arguments
CheckArg "$search_term" "$file"
CheckFile

# Initialize line counter
line_num=0

# Read the file line by line
while IFS= read -r line; do
    line_num=$((line_num + 1))

    if $invert_search; then
        if [[ "${line,,}" != *"${search_term,,}"* ]]; then
            if $show_line_numbers; then
                echo "$line_num $line"
            else
                echo "$line"
            fi
        fi
    else
        if [[ "${line,,}" == *"${search_term,,}"* ]]; then
            highlighted_line=$(Highlight "$line" "$search_term")
            if $show_line_numbers; then
                echo "$line_num $highlighted_line"
            else
                echo "$highlighted_line"
            fi
        fi
    fi
done < "$file"
