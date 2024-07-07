FROM dodeeric/pdf2epubex:latest

RUN apt -q update && apt -q -y install imagemagick wget

# Download and install xpdf CLI tools
RUN wget --no-check-certificate https://dl.xpdfreader.com/xpdf-tools-linux-4.05.tar.gz && \
    tar -xzf xpdf-tools-linux-4.05.tar.gz && \
    cp xpdf-tools-linux-4.05/bin64/* /usr/local/bin/ && \
    rm -rf xpdf-tools-linux-4.05 xpdf-tools-linux-4.05.tar.gz

# Bash script
COPY ./process_pdf.sh /bin/process_pdf
RUN chmod +x /bin/process_pdf

# xpdfrc
COPY ./.xpdfrc /etc/xpdfrc
