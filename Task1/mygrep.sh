#!/bin/bash

# Syntax function to show the correct syntax to use with the command
Syntax(){
	echo "Syntax: $0 search_term file"
	echo "Syntax: $0 -n search_term file"
	echo "Syntax: $0 -v search_term file"
}

# CheckArg function to check if the correct number of arguments is provided
CheckArg(){
	if [ "$1" -ne "$arg" ]; then
		# If the number of arguments is incorrect, display an error and show syntax
		echo "Incorrect number of arguments given"
		echo ""
		Syntax
		exit 1
	fi
}

# CheckFile function to check if the file exists and is a regular file
CheckFile(){
	if [ ! -f "$file" ]; then
		# If the file does not exist or is not a regular file, show an error and syntax
		echo "Error: File '$file' not found."
		echo ""
		Syntax
		exit 1
	fi
}

# Highlight function to highlight the matching word in every line
Highlight(){
    text="$1"   # Line text
    term="$2"   # Search term to highlight
    RED='\033[1;31m'  # Define red color escape sequence
    NC='\033[0m'      # Define no color escape sequence

    # Escape special characters in the search term for safe matching
    safe_term=$(printf '%s\n' "$term" | sed 's/[]\/$*.^|[]/\\&/g')

    # Use awk to highlight case-insensitive matches by wrapping them with color codes
    echo "$text" | awk -v term="$safe_term" -v red="$RED" -v nc="$NC" '
    BEGIN { IGNORECASE = 1 }  # Enable case-insensitive matching
    {
        gsub(term, red "&" nc)  # Replace matched term with colored version
        print
    }'
}

# Initialize option flags
show_line_numbers=false  # Set default: do not show line numbers
invert_search=false      # Set default: normal search (not inverted)

# If the user asks for help
if [ "$1" == "--help" ]; then
	Syntax
	exit

# If the first argument is "-n" (show line numbers)
elif [ "$1" == "-n" ]; then
	show_line_numbers=true
	shift 1  # Shift arguments to skip processed option

# If the first argument is "-v" (invert search)
elif [ "$1" == "-v" ]; then
	invert_search=true
	shift 1  # Shift arguments to skip processed option

# If both "-n" and "-v" options are provided together
elif [ "$1" == "-nv" -o "$1" == "-vn" ]; then
	show_line_numbers=true
	invert_search=true
	shift 1  # Shift arguments to skip processed option
fi

# Assign positional arguments after options
search_term=$1  # First non-option argument is the search term
file=$2         # Second non-option argument is the file to search in

# Expect exactly 2 arguments (search_term and file)
arg=2

# Validate number of arguments and file existence
CheckArg "$#"
CheckFile

# Initialize line counter
line_num=0

# Read the file line by line
while IFS= read -r line; do
    line_num=$((line_num + 1))  # Increment line counter

    if $invert_search; then
        # If invert_search is enabled, print lines that do NOT contain the search term
        if [[ "${line,,}" != *"${search_term,,}"* ]]; then
            if $show_line_numbers; then
                # Show line number with output
                echo "$line_num $line"
            else
                # Just show the line
                echo "$line"
            fi
        fi
    else
        # Normal search mode: find lines containing the search term
        if [[ "${line,,}" == *"${search_term,,}"* ]]; then
            # Highlight matched terms in the line
            highlighted_line=$(Highlight "$line" "$search_term")
            if $show_line_numbers; then
                # Show line number with highlighted output
                echo "$line_num $highlighted_line"
            else
                # Just show highlighted line
                echo "$highlighted_line"
            fi
        fi
    fi
done < "$file"  # Input file is read here
