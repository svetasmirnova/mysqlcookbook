The flags directory contains some sample image files that you can load
into the database with store_image.pl:

Example:
./store_image.pl flags/argentina.jpg image/jpeg

To load them all using a loop:

tcsh:
foreach f (flags/*.jpg)
./store_image.pl $f image/jpeg
end

sh:
for f in flags/*.jpg; do
./store_image.pl $f image/jpeg
done

These flag images come from the CIA World Factbook, available at:

http://www.odci.gov/cia/publications/factbook/

Mime types for GIF and JPEG files are:

*.gif files: image/gif
*.jpg files: image/jpeg
