#!/usr/bin/env python

import os
import sys
import pyperclip

def get_files_from_args():
    if len(sys.argv) < 2:
        print("Usage: ccp.py <file1> <file2> ... <fileN>")
        sys.exit(1)
    return sys.argv[1:]

def find_file(filename):
    if os.path.isabs(filename):
        if os.path.exists(filename) and os.path.isfile(filename):
            return filename
        else:
            print(f"File not found or is a directory: {filename}")
            return None
    else:
        potential_path = os.path.join(os.getcwd(), filename)
        if os.path.exists(potential_path) and os.path.isfile(potential_path):
            return potential_path
        else:
            print(f"File not found or is a directory: {filename}")
            return None

def read_file(filepath):
    with open(filepath, 'r') as file:
        return file.readlines()

def get_comment_prefix(filepath):
    if filepath.endswith('.js'):
        return '//'
    elif filepath.endswith('.py'):
        return '#'
    else:
        return '#'

def process_files(files):
    all_contents = []
    for file in files:
        file_path = find_file(file)
        if file_path:
            lines = read_file(file_path)
            relative_path = os.path.relpath(file_path, os.getcwd())
            comment_prefix = get_comment_prefix(file_path)
            check_lines = lines[:3] if lines and lines[0].startswith('#!') else lines[:1]
            if not any(relative_path in line for line in check_lines):
                lines.insert(0, f"{comment_prefix} {relative_path}\n")
            all_contents.extend(lines)
            all_contents.append("\n")
        else:
            print(f"Skipping file {file}: not found or is a directory")
    if all_contents:
        pyperclip.copy(''.join(all_contents))
        print("Copied to clipboard.")
    else:
        print("No contents to copy.")

if __name__ == "__main__":
    files = get_files_from_args()
    process_files(files)

