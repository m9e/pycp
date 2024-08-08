# ccp (Formerly known as pycp)

`ccp` is a utility for copying the contents of multiple files directly into your clipboard. It is especially useful for developers and those who need to quickly aggregate code snippets or entire files for further processing.

## Installation

To install, simply place the `ccp` and `collate` scripts in your `~/bin` directory and ensure this directory is included in your system's `PATH` by adding the following line to your `.bash_profile` or `.bashrc`:

```sh
export PATH="$PATH:~/bin"
```

Reload your profile to apply the changes:

```sh
source ~/.bash_profile
```

## Usage

### ccp

`ccp` can be used to copy the contents of one or more files to your clipboard. This is particularly handy when working with large codebases or when you need to pass multiple files to a Large Language Model (LLM) for processing.

#### Example

```sh
ccp file1.py file2.py dir/file3.py && cllm -M azure -m gptp4o -C -p "output a completely new version of file1.py that imports the functions from file3.py instead of doing that locally" > file1-new.py
```

In this example, the contents of `file1.py`, `file2.py`, and `file3.py` are copied to the clipboard and then passed to an LLM for processing.

### collate

`collate` is a tool that allows you to aggregate the contents of multiple files from various directories into a single output file or standard output. This can be extremely useful for creating a consolidated view of code or text files, especially when preparing inputs for further processing or analysis.

#### Example

```sh
collate dir1 dir2 -o combined_output.txt -e .py,.js
```

This example aggregates all `.py` and `.js` files from `dir1` and `dir2`, and writes the combined output to `combined_output.txt`. The script also respects `.gitignore` files and can be configured to output directly to standard output if desired.

or

```sh
collate dir1 dir2 -O
```

This example grabs all .py and .js files (because those are the default -e items) and outputs the collated contents with the header on stdout

### Command-Line Options

- **Gitignore Support**: Both `ccp` and `collate` automatically respect `.gitignore` files, ensuring that unwanted files are not processed.
- **File Headers**: Adds a header with the file path to each file's contents, making it easier to identify the source of each snippet in the output.
- **Multiple Extensions**: Supports a variety of file extensions, configurable via command-line arguments.
- **Output to File or Stdout**: The `collate` script allows output to be written to a file or directly to the console.

## Why Use These Tools?

If you often find yourself needing to quickly gather code snippets or entire files from various directories and pass them to an LLM or other tools, `ccp` and `collate` streamline this process significantly.

## Related Tools

`ccp` and `collate` work seamlessly with tools like [cllm](https://github.com/m9e/cllm/tree/main), enhancing your workflow when working with LLMs.
