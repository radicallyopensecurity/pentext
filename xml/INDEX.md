# Directory overview:
_boilerplate version 0.1_

This is an XML framework for generating Pentest Reports and Offers for clients. You download the whole framework whenever you need to write a new document (so every document exists in its own framework).



## naming structure
+ All names are lowercase, even personal names and abbreviations.

# Directory overview:

## README.md
This file holds project-related information.

## communication
This folder holds all email messages and other forms of communication between ROS and the client.

## customerprovidedstuff
This folder holds all *source code*, documents and other files that were handed to ROS by the client.

## doc
All available documentation in several formats (pick the one you like best). The 'tools' documentation is general. Writing documentation is specific to offertes and reports and is split up in subdirectories for each.

There is also an 'examples' directory which contains an example report, finding and offerte to have a look at. To generate an example report or offerte, copy it to the 'source' directory and generate it according to the instructions in the tools doc.

## dtd
Contains schemas, i.e. the grammar of the report and offerte language. Not for users.

## findings
Contains all findings in XML format. Note that you can always get the most up-to-date boilerplate findings from the *ROS pentesters library*.

## graphics
If you use screenshots (graphics) in your report or offerte, place them here. You can then reference the graphics from your report or offerte by setting the img href attribute to "../graphics/yourgraphic.jpg".
Note that the `source` directory is the root of the offer letter / report.

## non-findings
Contains all non-findings in XML format. Note that you can always get the most up-to-date boilerplate non-findings from the *ROS pentesters library*.

## rosbot
Rosbot internals. Nothing to see here, move along...

## scans
All scan output in either text or XML format.

## source
This folder holds the offerte as well as pentest XML files. In `source` there is a subdirectory `snippets` containing boilerplate text for reports and offertes, as well as bios. Note that you can always get the most up-to-date snippets and bios from the *ROS pentesters library*.

## target
This is where your intermediate XSL-FO and generated PDF document end up if you have generated your XML according to the instructions in the tools doc.

## templates
Holds templates for offertes, reports, findings (general and specific) and non-findings. Grab whatever you need and copy it to the 'source' directory (in case of offerte or report) or the pentest repo's 'finding' directory (in case of findings). Then edit to your liking.

## xslt
Contains stylesheets to transform the XML into XSL-FO, which can then be used to generate a PDF through FOP. Not for users.
