# Pentext

The PenText XML documentation project is a collection of XML templates, XML schemas and XSLT code, which combined provide an easy way to generate IT security documents including test reports (for penetration tests, load tests, code audits, etc), offers (to companies requesting these tests) and invoices. 

### How it Works
The OWASP PenText project is based on XML. A PenText Report, Offer, Invoice or Generic Document is in fact a (modular) XML document, conforming to an XML Schema. The XML Schema ensures that the documents are structured correctly, so that they can then be transformed into other formats using XSLT and the SAXON XSLT processor. Currently there is only one target format: PDF. To produce the PDF document, the report, offer, invoice or generic document XML is first transformed into XSL-FO (XSL Formatting Objects), which is then converted to PDF using Apache FOP.

### The Structure
The directories are used as follows:
- scripts: contains misc scripts. Currently has a script for importing github issues into XML format suited for PenText.
- chatops: contains bash and Python scripts that can be used with Hubot (chatOps), handy for automation while getting started or for checking document validity or spellchecking. 
- xml: 
   - contains the XML system and templates in directories *dtd*, *source* and *xslt*
   - your report or quote goes in *source*
   - contains a *graphics* map for your company logo 
   - the *findings* and *non-findings* maps are reserved for finding templates for reports.

## Getting Started
### Software Requirements
An XML editor -which could be any text editor like *JEdit*, to a full IDE- for editing of course ;). Preferably something that can check XML file validity. The *FOP* library for building a PDF document and a PDF reader for the result are the bare minimum and lastly the *Java* library *Saxon*.
It is also possible to set up the whole system with Ansible scripts or Docker.

### Compiling
Manually compiling a quotation, report or other document can be done with *java -jar path-to-Saxon-jar -s:name-of-xml-file -xsl:name-of-xsl-file-in-xsl-directory -o:name-for-pdf-output*
Of course this is tedious to write manually. Therefore it would be easier to script this or use one of the Hubot scripts in the chatops directory to build a document in a chatroom. 
