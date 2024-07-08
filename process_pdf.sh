#!/bin/sh

echo "Running pdf2epubEX on $1..."

epuboutputfilename=$(basename "$1" .pdf)-150dpi-jpg.epub

# Patch out weird sed bug when modifying CSS
sh -c \
  "sed -i \"s#sed -i 's/;unicode-bidi:bidi-override//g' base.min.css#cp base.min.css /tmp/base.min.css.bk \&\& sed -i -e 's/;unicode-bidi:bidi-override//g' /tmp/base.min.css.bk \&\& cat /tmp/base.min.css.bk >base.min.css || echo failed sed here#\" \"/usr/bin/pdf2epubEX\""

# Patch out DPI and format prompts
sed -ri '/echo "(======================|Caution:|- if you chose |If you want)/d; /read -p "Format of the images/d; /if \[ "\$imgformat" != "svg" \]/{N;N;d;}' /usr/bin/pdf2epubEX

pdf2epubEX $1

echo "Preparing to modify EPUB..."

mkdir -p bookmod
cd bookmod
mv ../$epuboutputfilename .
unzip $epuboutputfilename >/dev/null
rm $epuboutputfilename

echo "Extracting ppm images..."

mkdir -p ppm-out
pdftoppm -verbose ../$1 ppm-out
mv ppm-out-* ppm-out/
mkdir -p jpegimgs

echo "Converting ppm images to jpeg..."

for i in $(seq 1 `ls ppm-out | wc -l`); do
    page=$(printf "%06d" $i)

    # Define the input file names
    ppm="ppm-out/ppm-out-$page.ppm"

    # Define the output file name
    jpeg_file="jpegimgs/pg$i.jpeg"

    # Execute ImageMagick convert command
    convert $ppm $jpeg_file
done

echo "Converting cover image to png..."

convert jpegimgs/pg1.jpeg OEBPS/cover.png

rm -rf ppm-out

echo "Copying jpeg images to OEBPS..."

cat OEBPS/content.opf

for img in jpegimgs/*.jpeg; do
  cp $img OEBPS/bg`printf "%x\n" $(echo $img | sed "s/jpegimgs\/pg//; s/.jpeg//")`.jpg
done

echo "Zipping up..."

rm -rf jpegimgs
zip -0Xq ./test.epub mimetype && zip -Xr9Dq test.epub * -x mimetype -x ./test.epub && mv test.epub ../$epuboutputfilename
cd ..
rm -rf bookmod
