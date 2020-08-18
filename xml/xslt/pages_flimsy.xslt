<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:template name="layout-master-set-flimsy">
        <!-- Invoices, Ratecards and Contracts need their own page layout; quite different from other docs so just create a different set -->
        <fo:layout-master-set>
            <!-- first page -->
            <fo:simple-page-master master-name="Flimsy-First"
                xsl:use-attribute-sets="PortraitPage_flimsy">
                <fo:region-body region-name="region-body" xsl:use-attribute-sets="region-body-first"/>
                <fo:region-before region-name="region-before-first"
                    xsl:use-attribute-sets="region-before-first"/>
                <fo:region-after region-name="region-after-first"
                    xsl:use-attribute-sets="region-after-first"/>
            </fo:simple-page-master>
            <!-- all other pages -->
            <fo:simple-page-master master-name="Flimsy-Rest"
                xsl:use-attribute-sets="PortraitPage_flimsy">
                <fo:region-body region-name="region-body" xsl:use-attribute-sets="region-body-rest"/>
                <fo:region-before region-name="region-before-rest"
                    xsl:use-attribute-sets="region-before-rest"/>
                <fo:region-after region-name="region-after-rest"
                    xsl:use-attribute-sets="region-after-rest"/>
            </fo:simple-page-master>
            <!-- sequence master -->
            <fo:page-sequence-master master-name="Flimsy">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="Flimsy-First"
                        blank-or-not-blank="not-blank" page-position="first"/>
                    <fo:conditional-page-master-reference master-reference="Flimsy-Rest"
                        blank-or-not-blank="not-blank"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
        </fo:layout-master-set>
    </xsl:template>

    <xsl:template name="page_header">
        <fo:static-content flow-name="region-before-first" xsl:use-attribute-sets="HeaderFont">
            <fo:block>
                <fo:table width="100%" table-layout="fixed">
                    <fo:table-column column-width="proportional-column-width(40)"/>
                    <fo:table-column column-width="proportional-column-width(20)"/>
                    <fo:table-column column-width="proportional-column-width(40)"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell text-align="right" display-align="after"
                                padding-bottom="5mm">
                                <fo:block xsl:use-attribute-sets="TinyFont">
                                    <fo:block xsl:use-attribute-sets="bold main-color">
                                        <xsl:value-of select="/*/meta/company/full_name"/>
                                    </fo:block>
                                    <fo:block>
                                        <xsl:value-of select="/*/meta/company/address"/>
                                    </fo:block>
                                    <fo:block><xsl:value-of select="/*/meta/company/postal_code"
                                            />&#160;<xsl:value-of select="/*/meta/company/city"
                                        /></fo:block>
                                    <fo:block>
                                        <xsl:value-of select="/*/meta/company/country"/>
                                    </fo:block>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="center">
                                <fo:block>
                                    <fo:external-graphic xsl:use-attribute-sets="logo"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="after" padding-bottom="5mm">
                                <fo:block xsl:use-attribute-sets="TinyFont">
                                    <fo:block xsl:use-attribute-sets="bold main-color">
                                        <xsl:value-of select="/*/meta/company/website"/>
                                    </fo:block>
                                    <fo:block>
                                        <xsl:value-of select="/*/meta/company/email"/>
                                    </fo:block>
                                    <fo:block>
                                        <xsl:call-template name="getString">
                                            <xsl:with-param name="stringID" select="'page_kvk'"/>
                                        </xsl:call-template>
                                        <xsl:text>&#160;</xsl:text>
                                        <xsl:value-of select="/*/meta/company/coc"/>
                                    </fo:block>
                                    <fo:block>
                                        <xsl:call-template name="getString">
                                            <xsl:with-param name="stringID" select="'invoice_vatno'"
                                            />
                                        </xsl:call-template>
                                        <xsl:text>&#160;</xsl:text>
                                        <xsl:value-of select="/*/meta/company/vat_no"/>
                                    </fo:block>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="region-before-rest" xsl:use-attribute-sets="HeaderFont">
            <fo:block xsl:use-attribute-sets="header"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="page_footer_invoice">
        <fo:static-content flow-name="region-after-first" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer">
                <fo:inline xsl:use-attribute-sets="TinyFont main-color">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringID" select="'invoice_yaygreen'"/>
                    </xsl:call-template>
                </fo:inline>
                <fo:block/>
                <fo:inline xsl:use-attribute-sets="TinyFont main-color">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringID" select="'invoice_terms'"/>
                    </xsl:call-template>
                </fo:inline>
            </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="region-after-rest" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer">
                <fo:inline xsl:use-attribute-sets="TinyFont main-color">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringID" select="'invoice_yaygreen'"/>
                    </xsl:call-template>
                </fo:inline>
                <fo:block/>
                <fo:inline xsl:use-attribute-sets="TinyFont main-color">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringID" select="'invoice_terms'"/>
                    </xsl:call-template>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>
    <xsl:template name="page_footer">
        <fo:static-content flow-name="region-after-first"
                    xsl:use-attribute-sets="FooterFont">
                    <fo:block xsl:use-attribute-sets="footer">
                        <fo:retrieve-marker retrieve-class-name="tab"/>
                        <fo:leader leader-pattern="space"/>
                        <fo:inline>
                            <fo:page-number/>
                        </fo:inline>
                    </fo:block>
                </fo:static-content>
                <fo:static-content flow-name="region-after-rest" xsl:use-attribute-sets="FooterFont">
                    <fo:block xsl:use-attribute-sets="footer">
                        <fo:inline>
                            <fo:page-number/>
                        </fo:inline>
                        <fo:leader leader-pattern="space"/>
                        <xsl:value-of select="//meta/company/full_name"/>
                    </fo:block>
                </fo:static-content>
    </xsl:template>
</xsl:stylesheet>
