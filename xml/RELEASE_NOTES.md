RELEASE NOTES
=============

June 15, 2016
-------------

Giant update to celebrate these xml templates having been elevated to OWASP project status. Because how better to do that than through introducing a load of bugs. :) 

### Multilingual workflow

You can now set the desired language in quickscope, using the offer_language element. This will generate the proper offer with the proper language snippets.

Note: language stuff is defined in two places:

1. in source/snippets/offerte (language directories for all snippets)
2. in source/snippets/localisationstrings.xml (these are strings used in xslt; e.g. when generating an offer from quickscope)

### Offer types

You can now set the desired offer type in quickscope, using the offer_type element. This will generate the proper offer with the proper snippets.

Note: system looks for snippets with the type suffix first, and uses the standard snippet if none is found.

#### Example

Offer type is 'basic-scan'.

When generating an xml offer from quickscope, the xslt will first look for the file:

`methodology_basic-scan.xml`

If it cannot find this file, it will instead use

`methodology.xml`

### Customizable waivers

Yes, the stories you heard are true (and we'll get that snitch one day!) - waivers are no longer hard-coded but are now normal, customizable snippets. Well, not completely normal. It goes like this:

When generating waivers for client + third parties, the xslt will use the contents of the `<standard_waiver>` element in `<waivers>` in the `waiver.xml` snippet.

UNLESS: you have added an optional `<alternative_waiver>` element below `<standard_waiver>` (still in `<waivers>`) and have given it a `Ref` attribute that refers to the `id` of the client/party for which this alternative waiver needs to be used (just add an `id` if the client or party doesn't have one yet).

So to summarize:

1. xslt checks if an alternative waiver has been defined for a specific client or party in the offer,
2. if not, it uses the standard waiver

Now isn't that simple!

Note: to support this functionality, a bunch of waiver-only placeholders have been introduced, to wit: `<signee_long>`, `<signee_short>`, `<signee_street>`, `<signee_city>`, `<signee_country>`, `<signee_waiver_rep>`. Don't use them anywhere else though (they will fail and anyway it wouldn't make sense). 

May 23, 2016
------------

### Offerte --> Pentest-report

Last step in the document chain has been completed: you can now generate a (bare bones) Pentest report from any offerte the client has accepted, using the following command:

`java -jar saxon9he.jar -s:source/offerte.xml -xsl:xslt/off2rep.xsl -o:source/report.xml`

This makes the document workflow as follows:

1. Fill in quickscope.xml
2. Create offerte.xml from quickscope.xml using qs2offerte.xsl
3. If client accepts offerte, create report.xml from offerte.xml using off2rep.xsl
4. After pentest has concluded, create invoice from offerte using either the direct route or the roundabout one (see March 24, 2016 in the release notes for more info)

April 25, 2016
-------------

### Hidden elements

It is now possible to hide `section`, `appendix` and `annex` elements from the generated report, offerte or generic document. To do so, add the optional attribute `visibility="hidden"` to whatever it is you want to hide in the generated PDF.

Links to hidden targets will give an error (in the document), as will links to non-existing targets in general.

### Client Placeholder renaming

All placeholders that used to start with `c_*` (c_short, c_poc1, etc) now start with `client_`.

April 21, 2016
-------------

### Generic Documents

We now have a generic document type, which can be used for (drumroll) generic documents (whitepapers, training notes, presentation notes, whatever).

It is a super-simple template: it contains a a sparse meta section, an optional ToC and then any number of sections and elements. All the general text elements (tables, lists, pre, code, a, etc etc) can be used. It's so simple I'm not even going to document it. Check the example doc in `doc/examples` if you're lost, but if you've ever written an offer or a pentest report using this system it should be a piece of cake. :)

Usage: `genericdocument.xml --> genericdocument.pdf (using generate_doc.xsl + fop)`

April 4, 2016
-------------

### Associating targets with parties

You can now associate certain targets with certain parties. The `<client>` and <`party`> element now have an optional `id` attribute. Each `target` element now has an optional `Ref` attribute.

In waivers, only the targets associated with the party/client that needs to sign the waiver will be shown.

`<generate_targets/>` also has an optional `Ref` attribute for when you only want to generate a list of targets for one client/party.

If a target has no Ref attribute, it will appear in all the lists (both in the waivers and when using `<generate_targets/>`).


March 24, 2016
--------------
### More elaborate invoicing

Instead of generating an invoice straight from the offerte, as described in the release notes of March 10, you can now also take the roundabout route and customize the invoice.

So instead of:

1. offerte.xml --> invoice.pdf (using generate_inv.xsl + fop)

You can do:

1. offerte.xml --> invoice.xml (using off2inv.xsl)
2. edit invoice.xml (add some extra costs, most likely)
3. invoice.xml --> invoice.pdf (using generate_inv.xsl + fop)

More often than not, the simple route will do just fine, though.

### Added client VAT element

When billing EU customers, you do not need to charge VAT (but you do need to have the client's VAT number on the invoice). So the `<client>` element now has an optional `<vat_no>` child.

March 10, 2016
-------------
### Fee denomination

The `<fee>` element in `<pentestinfo>` now has an optional `denomination` attribute, which can be set to `euro` (default) or `dollar`. Yay for globalization! No, wait.

Anyway, the denomination is added automatically whenever you reference the fee using the `<p_fee/>` placeholder.

### Client info now has its own file

The `<client>` element has been extracted from the document and now exists all by itself in the file `client_info.xml`, which is located in the `source` directory. This gives us the possibility to have a 'client library' and to easily reuse client info - just replace the file with the proper one for the current client.

Note that there are some new fields in the client section, `<invoice_rep>` and `<invoice_mail>` for use in the... (see next section)

### Invoices!

w00t. You can now generate a pdf invoice directly from offerte.xml. Use:

`java  -jar saxon9he.jar -s:/path/to/offerte/source/offerte.xml -xsl:/path/to/offerte/xslt/generate_invoice.xsl -o:/path/to/report/target/invoice.fo INVOICE_NO=[invoice number] -xi` 

And then:

`fop -c conf/rosfop.xconf /path/to/offerte/target/invoice.fo path/to/offerte/target/invoice.pdf`

March 9, 2016
-------------

### An essay on placeholders

#### Universality
Placeholders can now be used in both offertes and pentest reports. Within reason, though! Pentest reports only have access to a limited set as the other placeholders are not relevant:

- c_long, c_short, c_street, c_city, c_country (i.e. client data)
- company_long, company_short (i.e. company data)
- p_duration, p_boxtype, p_testingduration, p_reportwritingduration, p_reportdue (i.e. pentest info)
- t_app, t_app_producer (i.e. tested app name & producer)

To accommodate for especially those last two bullets, we now have room for an optional `pentestinfo` tag in the report meta section, following the `<targets>` element. It's the same as the `pentestinfo` for offertes, except it doesn't hold financial info.

#### Robustness
When you insert a placeholder, there is now a check to see if
a. The element you're referring to exists
b. The element you're referring to contains text

If either a or b are not the case, you'll end up with a red XXXXX. Which should hopefully get your, or somebody else's, attention during review time.

#### Title Case

Uppercase is now forced on titles that should be in uppercase (i.e. report and offerte title pages, plus offerte titles in general).

Forcing title case for pentest report titles is unfortunately not possible from a style point of view as xsl-fo can only capitalize every word, which is not really what we want. But Peter Mosmans's validation script has your back on this.

### Finally, we have a `<div>` element!

#### What does `<div>` do?

Nothing. `<div>` just *is*.

#### Sigh. Ok, why *is* `<div>`?

You can use `<div>` as a container for other block elements. This is basically only (but very) useful for snippets, as snippets need to be well-formed XML documentlets and can therefore only have one root element. If the snippet is a complete section, this is not a problem. If the snippet is a bunch of paragraphs or something, you're out of luck. Or rather, you used to be out of luck, because there was no `<div>`. But now there is `<div>`. So your snippet can be `<div>` (root element), containing everything you want. Well, everything that's allowed, anyway.

#### So what's allowed in `<div>`?

All block elements: p, ul, ol, table, img, pre, code

#### And what elements can *contain* `<div>`?

Sections, Annexes and Appendices. NOTHING ELSE. DON'T EVEN TRY.


