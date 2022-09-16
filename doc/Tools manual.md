# Tools Manual

## Intro

You can write your documentation in OpenOffice (and then you just install OpenOffice and do your thing), or you can write it in XML. This allows you to concentrate only on the content without having to worry about what the end result will look like: the XML document is converted to PDF using a style sheet, so you only need to think about what needs to be said, not about numbering, styling or document metadata.

This sounds cool (and it is), but it does mean you may need to use some software you're not well used to working with. You're going to need:

- jEdit, An XML editor
- Saxon, An XML parser
- FOP, A tool to convert XSL-FO to PDF

## Downloading and installing

### Java

Make sure you have at least Java 7 installed (Java 8 is fine as well). If not, download it at www.java.com.

### jEdit

jEdit is an open source, cross platform text editor with support for XML editing. If you're used to working with XML and have a favorite different XML editor that's fine, but if not, start with jEdit.

Download jEdit (5.x) at: http://jedit.org/index.php?page=download and install.

### Saxon

Download Saxon Home Edition (HE) 9.6 **for Java** at: http://saxon.sourceforge.net/ and unzip to a location of your choice.

### FOP

Download Apache FOP 2.1 at https://xmlgraphics.apache.org/fop/download.html and unzip.

### Fonts

Download the Liberation Sans font from http://www.fontsquirrel.com/fonts/liberation-sans and install.

Download the Liberation Mono font from http://www.fontsquirrel.com/fonts/Liberation-Mono and install.


## Configuring

### jEdit

In jEdit, you're going to have to install the XML plugin: 

1. Start jEdit, then go to plugins > plugin manager
2. Click on the 'Install' tab
3. Find the plugin called 'XML' and click its checkbox. Its dependencies will be checked automatically; this is a good thing.
5. Click the 'Install' button below the description box and wait until everything is done downloading and installing.
6. Click the 'Close' button.

You may also want to dock the various plugin panes so they're easy to find and use: XML (XML Insert), Error List and Sidekick. XML will give you a list of all the elements you can insert at the caret, Error List will show you where your XML is not valid according to the Schema and Sidekick is useful for quick navigation.

### FOP

First, make sure you have installed the LiberationSansNarrow and LiberationMono fonts on your machine.

In the fop directory, find directory 'conf'. In this directory you'll find a file 'fop.xconf'. Make a copy of this file and rename it, maybe to rosfop.xconf.

Edit rosfop.xconf:

1. Under `<base>.</base>`, add the line: `<font-base>/Path/To/Your/Fonts/Directory</font-base>` (using the actual path to the Fonts directory on your own pc)
2. Change the line `<default-page-settings height="11in" width="8.26in"/>` to `<default-page-settings height="29.7cm" width="21cm"/>`
3. Just above the `</fonts>` closing tag, add:
```
<font kerning="yes" embed-url="LiberationSansNarrow-Regular.ttf">
        <font-triplet name="LiberationSansNarrow" style="normal" weight="normal"/>
        </font>
        <font kerning="yes" embed-url="LiberationSansNarrow-Bold.ttf">
          <font-triplet name="LiberationSansNarrow" style="normal" weight="bold"/>
        </font>
        <font kerning="yes" embed-url="LiberationSansNarrow-Italic.ttf">
          <font-triplet name="LiberationSansNarrow" style="italic" weight="normal"/>
        </font>
        <font kerning="yes" embed-url="LiberationSansNarrow-BoldItalic.ttf">
          <font-triplet name="LiberationSansNarrow" style="italic" weight="bold"/>
        </font>
        <font kerning="yes" embed-url="LiberationMono-Regular.ttf">
        <font-triplet name="LiberationMono" style="normal" weight="normal"/>
        </font>
        <font kerning="yes" embed-url="LiberationMono-Bold.ttf">
          <font-triplet name="LiberationMono" style="normal" weight="bold"/>
        </font>
        <font kerning="yes" embed-url="LiberationMono-Italic.ttf">
          <font-triplet name="LiberationMono" style="italic" weight="normal"/>
        </font>
        <font kerning="yes" embed-url="LiberationMono-BoldItalic.ttf">
          <font-triplet name="LiberationMono" style="italic" weight="bold"/>
        </font>
```
4. Save the file.

## Using

### jEdit

When you open an xml pentest report, jEdit automatically loads the referenced schema (the file containing all the xml 'grammar' rules). As part of the schema is online, jEdit will sometimes give you a message asking if you want to cache the online part:

"This XML file depends on a resource which is stored at the following Internet address: http://www.w3.org/2001/XInclude/XInclude.xsd"

Caching it is a good idea, so click the yes button when prompted (or 'no' if you have good reasons not to, it's your party!)

Use the pentestreport.xml template (which already contains some default stuff) to create your report (read the doc on report writing for more info).

Make sure the XML file you've created with jEdit is valid (no errors in the Error List in jEdit).

### Saxon

To transform your XML file into XSL-FO, use the following command from the saxon directory:

#### To Generate a Pentest Report

```java  -jar saxon9he.jar -s:/path/to/report/source/pentestreport.xml -xsl:/path/to/report/xslt/generate_report.xsl -o:/path/to/report/target/pentestreport.fo -xi```

(Note the source/xslt/target directories in this example, which correspond to the directory structure in the report directory. Also make sure to add the -xi option!)

#### To Generate an Offerte

```java  -jar saxon9he.jar -s:/path/to/report/source/offerte.xml -xsl:/path/to/report/xslt/generate_offerte.xsl -o:/path/to/report/target/offerte.fo```

(Note the source/xslt/target directories in this example, which correspond to the directory structure in the report directory.)

If you have defined extra parties that need to give permission, waivers for these parties will be generated in .fo format automatically

### FOP

To then convert your XSL-FO file into a nice and shiny pdf, use the following command from the fop directory:

#### To Generate a Pentest Report

```fop -c conf/rosfop.xconf /path/to/report/target/pentestreport.fo path/to/report/target/pentestreport.pdf```

(If you used another name for your custom FOP configuration file, use that.)

or maybe it is easier to go to your target directory and type:

```/path/to/fop -c path/to/fop/conf/rosfop.xconf offerte.fo offerte.pdf```

it depends on your directory structure, I guess.

Note that, if you define extra parties that need to give permission, you'll need to convert the waiver fo files to pdf as well.

#### To Generate an Offerte

```fop -c conf/rosfop.xconf /path/to/report/target/offerte.fo path/to/report/target/offerte.pdf```

(If you used another name for your custom FOP configuration file, use that.)
