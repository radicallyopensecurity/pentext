<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="pages.xslt"/>
    <xsl:import href="toc.xslt"/>
    <xsl:import href="structure.xslt"/>
    <xsl:import href="att-set.xslt"/>
    <xsl:import href="block.xslt"/>
    <xsl:import href="findings.xslt"/>
    <xsl:import href="auto.xslt"/>
    <xsl:import href="table.xslt"/>
    <xsl:import href="lists.xslt"/>
    <xsl:import href="inline.xslt"/>
    <xsl:import href="graphics.xslt"/>
    <xsl:import href="generic.xslt"/>
    <xsl:import href="numbering.xslt"/>
    <xsl:import href="localisation.xslt"/>

    <xsl:include href="styles_con.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>


    <!-- ****** AUTO_NUMBERING_FORMAT:	value of the <xsl:number> element used for auto numbering -->
    <xsl:param name="AUTO_NUMBERING_FORMAT" select="'1.1.1'"/>


    <xsl:key name="rosid" match="section | finding | appendix | non-finding" use="@id"/>


    <xsl:variable name="CLASSES" select="document('../xslt/styles_con.xslt')/*/xsl:attribute-set"/>

    <xsl:variable name="lang" select="/contract/@xml:lang"/>
    <xsl:variable name="localDateFormat" select="$strdoc/date/format[lang($lang)]"/>
    <xsl:variable name="fee" select="/contract/meta/contractor/hourly_fee * 1"/>
    <xsl:variable name="plannedHours" select="/contract/meta/work/planning/hours * 1"/>
    <xsl:variable name="total_fee" select="$fee * $plannedHours"/>
    <xsl:variable name="denomination">
        <xsl:choose>
            <xsl:when test="/contract/meta/contractor/hourly_fee/@denomination = 'eur'">€</xsl:when>
            <xsl:when test="/contract/meta/contractor/hourly_fee/@denomination = 'gbp'">£</xsl:when>
            <xsl:when test="/contract/meta/contractor/hourly_fee/@denomination = 'usd'">$</xsl:when>
        </xsl:choose>
    </xsl:variable>

    <xsl:param name="latestVersionDate"><!-- we're not using versions for contracts, but the contract date will do just fine -->
            <xsl:value-of select="format-date(/contract/meta/work/start_date, '[MNn] [D1], [Y]', 'en', (), ())"/>
    </xsl:param>

    <!-- ROOT -->
    <xsl:template match="/">

        <fo:root>

            <xsl:call-template name="layout-master-set"/>
            <xsl:call-template name="Content"/>

        </fo:root>
    </xsl:template>

    <!-- OVERRIDES -->


    <!-- NO FRONT PAGE FOR META, JUST A HEADER -->
    <xsl:template match="meta"/>
    

    <!-- TITLES (NO NUMBERING) -->
    <xsl:template match="title">
        <xsl:variable name="LEVEL" select="count(ancestor::*) - 1"/>
        <xsl:variable name="CLASS">
            <!-- use title-x for all levels -->
            <xsl:text>title-</xsl:text>
            <xsl:value-of select="$LEVEL"/>
        </xsl:variable>

        <fo:block>
            <xsl:call-template name="use-att-set">
                <xsl:with-param name="CLASS" select="$CLASS"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- TITLES (ALL CAPS) -->
    <xsl:template match="title/text()">
        <xsl:value-of select="upper-case(.)"/>
    </xsl:template>


    <xsl:template match="generate_contract_signature_box">
        <fo:block keep-together.within-page="always" xsl:use-attribute-sets="signaturebox">
            <fo:block>
                <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="borders">
                    <fo:table-column column-width="proportional-column-width(50)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-column column-width="proportional-column-width(50)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block><xsl:value-of
                                                select="/contract/meta/contractor/city"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block><xsl:value-of
                                                select="/*/meta/company/city"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>&#160;</fo:block>
                                <fo:block>&#160;</fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>&#160;</fo:block>
                                <fo:block>&#160;</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block><xsl:value-of
                                                select="/*/meta/contractor/name"/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block><xsl:value-of select="/*/meta/company/legal_rep"/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block/>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block xsl:use-attribute-sets="bold"><xsl:value-of select="/*/meta/company/full_name"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:block>
    </xsl:template>
    
    <xsl:template name="page_header">
        <fo:static-content flow-name="region-before-cover" xsl:use-attribute-sets="HeaderFont">
            <fo:block>
            <fo:table width="100%" table-layout="fixed">
                <fo:table-column column-width="proportional-column-width(40)"/>
                <fo:table-column column-width="proportional-column-width(20)"/>
                <fo:table-column column-width="proportional-column-width(40)"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell text-align="right" display-align="after" padding-bottom="5mm">
                            <fo:block xsl:use-attribute-sets="TinyFont">
                                <fo:block xsl:use-attribute-sets="bold orange-text"><xsl:value-of select="/*/meta/company/full_name"/></fo:block>
                                <fo:block><xsl:value-of select="/*/meta/company/address"/></fo:block>
                                <fo:block><xsl:value-of select="/*/meta/company/postal_code"/>&#160;<xsl:value-of select="/*/meta/company/city"/></fo:block>
                                <fo:block><xsl:value-of select="/*/meta/company/country"/></fo:block>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="center">
                            <fo:block><fo:external-graphic xsl:use-attribute-sets="logo"/></fo:block>
                        </fo:table-cell>
                        <fo:table-cell display-align="after" padding-bottom="5mm">
                            <fo:block xsl:use-attribute-sets="TinyFont">
                                <fo:block xsl:use-attribute-sets="bold orange-text"><xsl:value-of select="/*/meta/company/website"/></fo:block>
                                <fo:block><xsl:value-of select="/*/meta/company/email"/></fo:block>
                                <fo:block>Chamber of Commerce <xsl:value-of select="/*/meta/company/coc"/></fo:block>
                                <fo:block>VAT number <xsl:value-of select="/*/meta/company/vat_no"/></fo:block>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="region-before-content" xsl:use-attribute-sets="HeaderFont">
            <fo:block xsl:use-attribute-sets="header">
                <xsl:value-of select="/pentest_report/meta/classification"/>
            </fo:block>
        </fo:static-content>
    </xsl:template>

</xsl:stylesheet>
