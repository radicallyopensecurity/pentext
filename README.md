# Pentext

The PenText XML documentation project is a collection of XML templates, XML schemas and XSLT code, which combined provide an easy way to generate IT security documents including test reports (for penetration tests, load tests, code audits, etc), offers (to companies requesting these tests) and invoices. 

### How it Works
The OWASP PenText project is based on XML. A PenText Report, Quote, Invoice or Generic Document is in fact a (modular) XML document, conforming to an XML Schema. The XML Schema ensures that the documents are structured correctly, so that they can then be transformed into other formats using XSLT and the SAXON XSLT processor. Currently there is only one target format: PDF. To produce the PDF document, the report, offer, invoice or generic document XML is first transformed into XSL-FO (XSL Formatting Objects), which is then converted to PDF using Apache FOP.

### The Structure
The directories are used as follows:
- chatops: contains bash and Python scripts that can be used with Hubot (chatOps), handy for automation while getting started or for checking document validity or spellchecking. 
- xml: 
   - contains the PenText XML system and templates in directories *dtd*, *source* and *xslt*
   - your report or quote will go into *source*
   - contains a *graphics* map for your company logo 
   - the *findings* and *non-findings* directories are for findings and non-findings

## Getting Started

What do you need ?

1. Clone this repository

2. Install the toolchain

3. Edit the content

Listo! That's all you need. Now you can build PDF reports using the content.


### Toolchain
To convert the XML content into PDF files the tools the *Apache FOP* library and the *Java* library *Saxon* will be used
It is easiest to install the toolchain using Ansible: check out the role PeterMosmans.docbuilder (https://galaxy.ansible.com/PeterMosmans/docbuilder/)

To edit (and view) the content you'll need a XML editor - which could be any text editor like *JEdit*, to a full IDE- for editing of course ;). Preferably something that can check XML file validity. To view the resulting PDF files a PDF viewer is necessary. 

### Building PDF's
Manually compiling a quotation, report or other document can be done using `java -jar path-to-Saxon-jar -s:name-of-xml-file -xsl:name-of-xsl-file-in-xsl-directory -o:name-for-pdf-output`
But why do it manually when the [ChatOps](https://github.com/radicallyopensecurity/pentext/tree/master/chatops) directory contains so much nice scripts to do just that ?

See for more detailed information the [tools manual](https://github.com/radicallyopensecurity/pentext/blob/master/xml/doc/Tools%20manual.md)

## Adding and Modifying Content
### Guidelines
- There is a guide for [report writing](xml/doc/report/Report%20Writing%20-%20Procedure.md)
- There is also a guide for [quotation writing](xml/doc/offerte/Offerte%20Writing%20Procedure.md)

### Example documents
Besides the reports and quotations, generic documents can also be created.
Those can be found [here](xml/doc/examples)
