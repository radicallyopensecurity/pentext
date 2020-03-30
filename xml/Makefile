PROJECT	= sample-report
TARGETS	= target/report_$(PROJECT).pdf
OBJS	= target/report_$(PROJECT).fo
FOP	= fop -c rosbot/fop.conf
JAVA	= java
MKDIR	= mkdir -p
MV	= mv -f
RM	= rm -f
UNZIP	= unzip
WGET	= wget
XSLTPROC= xsltproc --nonet --xinclude


all: $(TARGETS)

target/report_$(PROJECT).pdf: $(OBJS)
	$(FOP) target/report_$(PROJECT).fo -pdf $@

target/report_$(PROJECT).fo: ../saxon9he.jar sample-report/source/report.xml xslt/generate_report.xsl
	$(MKDIR) -- target
	$(JAVA) -jar ../saxon9he.jar \
	     -s:"sample-report/source/report.xml" \
	     -xsl:"xslt/generate_report.xsl" \
	     -o:"$@" \
	     -xi

../saxon9he.jar:
	$(WGET) -O download.zip https://sourceforge.net/projects/saxon/files/Saxon-HE/9.7/SaxonHE9-7-0-11J.zip/download
	$(UNZIP) download.zip saxon9he.jar
	$(RM) -- download.zip
	$(MV) -- saxon9he.jar $@

clean:
	$(RM) -- $(OBJS)

distclean: clean
	$(RM) -- $(TARGETS)

export-csv: sample-report/source/report.xml
	@$(XSLTPROC) "xslt/findings2csv.xsl" "sample-report/source/report.xml"

export-json: sample-report/source/report.xml
	@$(XSLTPROC) "xslt/findings2json.xsl" "sample-report/source/report.xml"

.PHONY: clean distclean export-csv export-json
