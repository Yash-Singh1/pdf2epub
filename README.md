# pdf2epub

Based off of [pdf2epubEX](https://github.com/dodeeric/pdf2epubex) but image rasterization is done by xpdf instead of pdf2htmlEX.

## Usage

**Requires Docker**

```bash
./run.sh <pdf-file>
```

## Building

```bash
docker build -t pdf_processor .
```

## Links

Docker Hub: <https://hub.docker.com/r/saiansh/pdf2epub>
