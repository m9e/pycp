#!/usr/bin/env python

import os
import sys
import pyperclip
import argparse
from gitignore_parser import parse_gitignore

def get_args():
    parser = argparse.ArgumentParser(description="Copy file contents to clipboard.")
    parser.add_argument('files', nargs='+', help="Files to process")
    parser.add_argument('--ignore-ignore', action='store_true', help="Ignore .gitignore files")
    return parser.parse_args()

def find_file(filename):
    if os.path.isabs(filename):
        if os.path.exists(filename) and os.path.isfile(filename):
            return filename
        else:
            print(f"File not found or is a directory: {filename}", file=sys.stderr)
            return None
    else:
        potential_path = os.path.join(os.getcwd(), filename)
        if os.path.exists(potential_path) and os.path.isfile(potential_path):
            return potential_path
        else:
            print(f"File not found or is a directory: {filename}", file=sys.stderr)
            return None

def read_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as file:
            return file.readlines()
    except Exception as e:
        print(f"Error reading file {filepath}: {str(e)}", file=sys.stderr)
        return []

def get_comment_prefix_suffix(filepath):
    """
    Returns the appropriate comment prefix and suffix based on the file extension.
    """
    extension_to_comment = {
        '.js': ('//', ''),
        '.py': ('#', ''),
        '.java': ('//', ''),
        '.c': ('//', ''),
        '.cpp': ('//', ''),
        '.h': ('//', ''),
        '.sh': ('#', ''),
        '.rb': ('#', ''),
        '.php': ('//', ''),
        '.sql': ('--', ''),
        '.html': ('<!--', '-->'),
        '.xml': ('<!--', '-->'),
        '.md': ('<!--', '-->'),
    }
    
    _, ext = os.path.splitext(filepath)
    return extension_to_comment.get(ext, ('#', ''))

def load_gitignore_files(directory):
    gitignore_matchers = []
    current_dir = directory
    while current_dir != os.path.dirname(current_dir):  # Stop at the root directory
        gitignore_path = os.path.join(current_dir, '.gitignore')
        if os.path.exists(gitignore_path):
            gitignore_matchers.append(parse_gitignore(gitignore_path))
        current_dir = os.path.dirname(current_dir)
    # Check the current working directory's .gitignore
    cwd_gitignore_path = os.path.join(os.getcwd(), '.gitignore')
    if os.path.exists(cwd_gitignore_path):
        gitignore_matchers.append(parse_gitignore(cwd_gitignore_path))
    return gitignore_matchers

def is_file_ignored_by_gitignore(file_path, gitignore_matchers):
    return any(matcher(file_path) for matcher in gitignore_matchers)

def process_files(files, ignore_ignore):
    all_contents = []
    gitignore_matchers = [] if ignore_ignore else load_gitignore_files(os.getcwd())
    for file in files:
        file_path = find_file(file)
        if file_path:
            is_ignored = is_file_ignored_by_gitignore(file_path, gitignore_matchers)
            if ignore_ignore or not is_ignored:
                lines = read_file(file_path)
                relative_path = os.path.relpath(file_path, os.getcwd())
                comment_prefix, comment_suffix = get_comment_prefix_suffix(file_path)
                
                # Check if the first line is a shebang
                if lines and lines[0].startswith('#!'):
                    shebang_line = lines.pop(0)
                    check_lines = lines[:2]  # Check the next two lines for the relative path comment
                    if not any(relative_path in line for line in check_lines):
                        lines.insert(0, f"{comment_prefix} {relative_path} {comment_suffix}\n")
                    lines.insert(0, shebang_line)
                else:
                    check_lines = lines[:1]  # Check the first line for the relative path comment
                    if not any(relative_path in line for line in check_lines):
                        lines.insert(0, f"{comment_prefix} {relative_path} {comment_suffix}\n")
                
                all_contents.extend(lines)
                all_contents.append("\n")

    if all_contents:
        try:
            # Add a blank line between files
            clipboard_content = '\n'.join(all_contents)
            pyperclip.copy(clipboard_content)
            print("Copied to clipboard.")
        except Exception as e:
            print(f"Error copying to clipboard: {str(e)}", file=sys.stderr)
    else:
        print("No contents to copy.", file=sys.stderr)

if __name__ == "__main__":
    args = get_args()
    process_files(args.files, args.ignore_ignore)