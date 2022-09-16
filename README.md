# PenText

The PenText XML documentation project is a collection of XML templates, XML
schemas and XSLT code, which combined provide an easy way to generate IT
security documents including test reports (for penetration tests, load tests,
code audits, etc), offers (to companies requesting these tests), and invoices.

### How it Works

The OWASP PenText project is based on XML. A PenText Report, Quote, Invoice or
Generic Document is in fact a (modular) XML document, conforming to an XML
Schema. The XML Schema ensures that the documents are structured correctly, so
that they can then be transformed into other formats using XSLT and the SAXON
XSLT processor.

To produce a PDF document, the report, offer, invoice or generic document XML is
first transformed into XSL-FO (XSL Formatting Objects), which is then converted
to PDF using Apache FOP.

It is also possible to export e.g. all findings of a report to JSON, XML or
plaintext format.

### The Structure

- The framework itself consists of files in the `dtd` and `xslt` directory
- A report or quote will go into `source`
- Graphics, including screenshots and e.g. a company logo, will go into
  `graphics`
- Findings and non-findings of penetration test reports can go into `findings`
  and `non-findings`

## Getting Started

What do you need ?

1. Clone this repository

2. Install the toolchain

3. Edit the content

Listo! That's all you need. Now you can build PDF reports using the content.

### Toolchain

To convert the XML content into PDF files the tools the _Apache FOP_ library and
the _Java_ library _Saxon_ will be used. A separate repository will contain
these tools on a handy Docker container.

To edit (and view) the content you'll need a XML editor - which could be any
text editor like _JEdit_, to a full IDE- for editing of course ;). Preferably
something that can check XML file validity. To view the resulting PDF files a
PDF viewer is necessary.

### Building PDFs

Manually compiling a quotation, report or other document can be done using the
supplied Makefile:

`make report`

See for more detailed information the
[tools manual](https://github.com/radicallyopensecurity/pentext/blob/master/xml/doc/Tools%20manual.md)

## Adding and Modifying Content

### Guidelines

- There is a guide for
  [report writing](doc/report/Report%20Writing%20-%20Procedure.md)
- There is also a guide for
  [quotation writing](doc/offerte/Offerte%20Writing%20Procedure.md)

### Example documents

Besides the reports and quotations, generic documents can also be created. Those
can be found [here](doc/examples)

## Important note

From version 2.0 onwards, the structure of the PenText repository has been
simplified. Please see the [CHANGELOG](CHANGELOG.md) for more information.
