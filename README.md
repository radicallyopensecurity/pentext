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
It is easiest to install the toolchain using Ansible: https://github.com/radicallyopensecurity/docbuilder

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


## PenText Visual Editor (Beta)
The pentext framework is shipped with an editor that facilitates the redacting of findings and non-findings. As the pentext framework relies heavily on xml to be able to generate documents,
the writer(s) of these documents are faced with an extra challenge. Not only do they have to worry about content, now the structure of the document is also of importance.
In practice this has led to annoying errors like file-inclusion errors and tag mismatch errors.

The editor tries to relieve the writer from the burden of having to maintain proper document structure, so he/she can focus on content only.
An added feature of the editor is that is has built in support for the pentester's library. This means that standard findings from the library
can be easily integrated into the document.

The editor is a meteor application that runs locally. In the future, when more components are added to it, it can be easily extended to a network facing application
so it can be used by multiple collaborators.

To start:
1. Go to the <pentext_root>/editor directory
2. Execute ./start.sh. It will pull in its dependencies, and if all went will run the service on localhost:4000
3. Open a browser and go to localhost:4000

Here you see two tabs, edit findings and edit non-findings. These tabs will let you handle findings and non-findings respectively
The general workflow for these tabs is the same, the difference is that they handle different sections of the document.

In both tabs, two directories can be specified. The [non]findings directory is mandatory. Point this to a clone of the gitrepository of the test you
are working on.
The Library directory is optional and should point to a directory which contains generic [non]findings that could be used.

Click update to update the system.

Now two tabs appear. One represents the directory with the pentest's findings, the other represents the library findings.
All .xml files that are found will appear in the screen. Even the ones that do not necessasily belong to the pentext framework.
When you click on the arrow in the file, an editor opens up and all the fields are copied from the file to the editor fields.
A file is outlined red when the structure of the file does not match the framework's specification. This means that when the file is selected, not all fields can be filled. It is advised to copy+paste from the raw file view (click file) to the fields.

When a file is saved, the correct structure is used and when the directory is updated, the file should show up green and should be handled by the pentext system without hassle.


