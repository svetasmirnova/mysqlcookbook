STYLESHEET = changes-html.xsl

LYNX = lynx -dump -nolist -width=70 -justify=0

all:: ../Changes.html ../Changes.txt

../Changes.html:: Changes.xml $(STYLESHEET)
	xsltproc -o ../Changes.html $(STYLESHEET) Changes.xml

../Changes.txt:: ../Changes.html
	$(LYNX) ../Changes.html > ../Changes.txt

lastchangeset:
	lastchangeset.rb Changes.xml
