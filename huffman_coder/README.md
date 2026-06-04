# Huffman Coder

C coursework folder for a Huffman coding assignment. The folder contains the assignment source scaffold, compiled artifact, and sample text/code-table/encoded/decoded files.

## What It Covers

- Character frequency counting
- ASCII-indexed code table storage
- Huffman code table generation workflow
- Encoding text into bit-string form
- Decoding bit strings back into text using a code table
- Compression statistics such as original size, compressed size, and compression ratio

## Key Files

| File | Purpose |
| --- | --- |
| `main.c` | Assignment scaffold showing the intended encoder/decoder flow. |
| `huffman` | Existing compiled executable/artifact. |
| `message.txt`, `seashells.txt` | Sample input text files. |
| `*_codeTable.txt` | Sample Huffman code tables. |
| `*_encoded.txt` | Sample encoded bit-string outputs. |
| `*_decoded.txt` | Sample decoded outputs. |

## Intended Usage

The assignment interface is structured around two modes:

```bash
./huffman encode <input_text> <output_code_table> <output_encoded_text>
./huffman decode <input_code_table> <input_encoded_text> <output_decoded_text>
```

## Current Status

`main.c` reads like an instructional scaffold and references variables that still need to be wired into a complete implementation. The folder is still useful as a coursework artifact because it documents the expected Huffman workflow and includes sample generated files.

## Concepts Demonstrated

- Compression fundamentals
- Frequency tables
- File I/O in C
- Command-line program design
- Encoding/decoding pipeline structure
