# PenText Roadmap  
  
## Business Goals  
  
* Creating a framework for the (largely automatic) generation of computer security and pentest related documents.
* Users can focus on content and special cases; boilerplate text, generation and design is taken care of by the framework.
* Platform-independent
* Open Source  
  
## How are we pursuing these goals?  
  
### 1. Set of XML templates and snippets

All previously written reports, quotes and invoices are analyzed for clear, well-written, useful snippets, which are maintained and updated as needed in an open Github project (link).
  
### 2. Set of XSLT templates

These:
* Guide user through workflow, from scoping through quote and report to invoice.
* Generate PDF documents for each of these steps.

### 3. Set of XML Schemas

The schemas can be used to validate any document at any stage of the workflow, ensuring that the document structure provides space for all necessary information contained within it.
  
### 4. Set of Python scripts to bridge the usability gap between the user and the saxon/fop command line tools

* docbuilder.py gives the user an interface to build documents without knowledge of the xslt framework or the saxon and fop command line tools
* validate_report.py adds extra validation to reports beyond the structural soundness checks XML Schema provides
  
## Use Cases  
  
### Pentesters  
  
* Write/Generate Pentest Reports  
* Have Contracts  
  
### Backoffice  
  
#### Sales/bizdev  

* Create Quickscope  
* Write/Generate Quotes  
* Write/Generate Rate sheets  
* Have Contracts  

#### Financial administration  
	
* Generate Invoices  
* Have Contracts  

#### HR  

* Write Contracts
* Have Contracts   
  
### Clients  
  
* Read Pentest Reports  
* Read Quotes  
* Read Rate Sheets  
* Read nvoices  
  
## Features  
  
### Achieved so far  
  
* Full document set in simple layout  
* Python scripts  
  
### Still to do  
  
* Make python scripts an installable module that can be used as-is or imported for chatops
* Define workflows and write high-level documentation of PenText framework (what does what)
* Finalize new design for all documents
* Document design customization options (what to change where) 
* Datasheet/infographic to summarise everything done in pentest.  
* Improve and complete low-level documentation  
  
