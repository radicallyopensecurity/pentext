# PenText testing procedure

## Main PenText document chain (quickscope - quote - report - invoice)

1. Start out with a sample XML Quickscope document (in source).
2. Check XML Quickscope document validity.
		EXPECTED OUTCOME: document is valid
3. From Quickscope, generate an XML Quote.
4. Check XML Quote document validity (please!)
		EXPECTED OUTCOME: document is valid
5. From XML Quote, generate an FO/PDF Quote.
6. Test with the following options: 
	a. test with different quote types (retest, code audit, pentest, ...)
		EXPECTED OUTCOME: every quote type has its own set of snippets (you can check the snippets in snippets/snippetselection.xml) and so differs in content
	b. test with/without optional code audit (regardless of quote type)
		EXPECTED OUTCOME: quote is generated with/without optional code audit snippet (except in case of a specific code audit quote, which obviously does not need the optional extra code audit snippet)
	c. test with optional Third Party
		EXPECTED OUTCOME: quote is generated with extra waiver for third party; third party is listed in 'Conditions' section
	d. test with optional extra third parties (3 in total)
		EXPECTED OUTCOME: quotes are generated with extra waivers for third parties; third parties are listed in 'Conditions' section
	e. test with alternative waiver
		EXPECTED OUTCOME: quote is generated with alternative waiver
	f. test with different language (english/dutch)
		EXPECTED OUTCOME: quote is now in different language
7. For *each* option, check PDF Quote:
	a. placeholders resolve
	b. target list resolves
	c. layout looks ok
	d. waiver signature box is present and correct
8. From XML Quote, generate an FO/PDF Invoice (do not forget to enter the invoice number parameter)
9. Test with the following options:
	a. with/without date parameter
		EXPECTED OUTCOME: no date parameter: today's date; with date parameter: invoice uses date from parameter
	b. generate from different language quote (set `<offerte xml:lang="en">` to `nl`)
		EXPECTED OUTCOME: invoice is generated in other language
10. For *each* option, check PDF Invoice:
	a. contents
	b. layout
11. From XML Quote, generate an XML Invoice (that is XML, not FO/PDF!)
12. Check XML Invoice validity
		EXPECTED OUTCOME: document is valid
13. Edit XML Invoice:
	a. Add some bogus description and fee to `<additionalcosts>`
	b. Set @vat to 'no' for any service/cost
14. Check XML Invoice validity
		EXPECTED OUTCOME: document is still valid
15. From XML Invoice, generate FO/PDF Invoice
16. Check PDF Invoice:
	a. contents
		EXPECTED OUTCOME: extra bogus info is listed in invoice
	b. layout
	c. vat amount
		EXPECTED OUTCOME: amount is correct
	d. total amount
		EXPECTED OUTCOME: amount is correct
17. From XML Quote, generate XML Report
18. Check XML Report validity (note: you will have to set a bogus @findingCode as the default '???' results in an error)
		EXPECTED OUTCOME: document is valid
19. From XML Report, generate FO/PDF Report
20. Check PDF Report:
	a. contents
		EXPECTED OUTCOME: everything present on/in the cover page, meta page, ToC, Testing team
	b. layout
21. From XML Report, generate XML Quote
		EXPECTED OUTCOME: this should automatically be a retest quote
22. Check XML Retest Quote validity; contents and layout have already been tested earlier so those should be okay
		EXPECTED OUTCOME: document is valid

## Incident Response Management

1. Start out with a sample XML Incident Response Quickscope document (in source; `ir_quickscope.xml`).
2. Check XML IR Quickscope document validity.
		EXPECTED OUTCOME: document is valid
3. From Quickscope, generate an XML Incident Response Management 'Quote'.
4. Test with and without the `<organizational_readiness_assessment>` element in `ir_quickscope.xml`.
		EXPECTED OUTCOME: depending on the presence of the `<organizational_readiness_assessment>`, the `organizational_readiness_assessment.xml` snippet is or is not included in the resulting doc
4. In both cases, check XML Incident Response Management 'Quote' document validity (please!)
		EXPECTED OUTCOME: document is valid
5. From XML Incident Response Management 'Quote', generate an FO/PDF Quote.
6. Check PDF Quote:
	a. contents (do all placeholders resolve)
	b. layout

## Rate Cards

1. Use the `ratecard.xml` snippet and `generate_ratecard.xsl` to generate a FO/PDF Rate Card.
2. Check PDF Rate Card:
	a. contents (do all placeholders resolve, do the rates have the correct denomination)
	b. layout

## Contracts

1. Start out with a sample XML Contract Info document.
2. From Contract Info, generate FO/PDF Contract.
3. Test with the following options:
	a. different contract types (single_engagement|fixed_term|non_zzp)
	b. different language (english|dutch)
4. For *each option*, check PDF Contract:
	a. contents (do all placeholders resolve)
	b. layout


## Generic Document

1. Start out with a sample XML Generic document.
2. Check XML Generic Document validity.
2. From XML Generic Document, generate FO/PDF Document.
3. Test with the following options:
	a. different contract types (single_engagement|fixed_term|non_zzp)
	b. different language (english|dutch)
4. For *each option*, check PDF Contract:
	a. contents (do all placeholders resolve)
	b. layout
