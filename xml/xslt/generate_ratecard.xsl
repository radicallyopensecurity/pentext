<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="pages.xslt"/>
    <xsl:import href="block.xslt"/>
    <xsl:import href="inline.xslt"/>
    <xsl:import href="auto.xslt"/>
    <xsl:import href="placeholders.xslt"/>
    <xsl:import href="structure.xslt"/>
    <xsl:import href="lists.xslt"/>
    <xsl:import href="generic.xslt"/>
    <xsl:import href="att-set.xslt"/>
    <xsl:import href="table.xslt"/>
    <xsl:include href="styles_rat.xslt"/>
    <xsl:include href="localisation.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    
    <!-- params & keys not needed but required by shared code -->
    <xsl:param name="AUTO_NUMBERING_FORMAT" select="'1.1.1'"/>
    <xsl:param name="EXEC_SUMMARY" select="false()"/>
    <xsl:key name="rosid" match="section|finding|appendix|non-finding" use="@id"/>
    <xsl:key name="biblioid" match="biblioentry" use="@id"/>
    <xsl:variable name="fee" select="/contract/meta/contractor/hourly_fee * 1"/>
    <xsl:variable name="plannedHours" select="/contract/meta/work/planning/hours * 1"/>
    <xsl:variable name="total_fee" select="$fee * $plannedHours"/>
    
    <!-- the ones below actually *are* used -->
    <xsl:variable name="CLASSES" select="document('../xslt/styles_rat.xslt')/*/xsl:attribute-set"/>
    <xsl:variable name="lang" select="/*/@xml:lang"/>
    <xsl:variable name="latestVersionDate">
            <xsl:for-each select="/*/meta/client/rates/latestrevisiondate">
                <xsl:sort select="xs:dateTime(@date)" order="descending"/>
                <xsl:if test="position() = 1">
                    <xsl:value-of select="format-dateTime(@date, '[MNn] [D1], [Y]', en, (), ())"/>
                    <!-- Note: this should be: 
                    <xsl:value-of select="format-dateTime(@date, $localDateFormat, $lang, (), ())"/> 
                    to properly be localised, but we're using Saxon HE instead of PE/EE and having localised month names 
                    would require creating a LocalizerFactory 
                    See http://www.saxonica.com/html/documentation/extensibility/config-extend/localizing/ for more info
                    sounds like I'd have to know Java for that so for now, the date isn't localised. :) -->
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
    
    <xsl:variable name="denomination">
            <xsl:choose>
                <xsl:when test="//meta/client/rates/@denomination = 'eur'">€</xsl:when>
                <xsl:when test="//meta/client/rates/@denomination = 'gbp'">£</xsl:when>
                <xsl:when test="//meta/client/rates/@denomination = 'usd'">$</xsl:when>
            </xsl:choose>
        </xsl:variable>
    
    <xsl:template match="ratecard">
        <!-- Invoice is generated straight from offerte -->
        <fo:root>
            <xsl:call-template name="layout-master-set"/>
            <xsl:call-template name="Content"/>
        </fo:root>
    </xsl:template>

    <!-- overrules for pages.xslt -->
    <xsl:template name="Content">
        <fo:page-sequence master-reference="Report">
            <xsl:call-template name="page_header"/>
            <xsl:call-template name="page_footer"/>
            <fo:flow flow-name="region-body" xsl:use-attribute-sets="DefaultFont">
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
                <fo:block id="EndOfDoc"/>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    
    <xsl:template match="meta">
        <!-- not doing anything here, ratecard meta is only for placeholder references -->
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
                            <fo:table-cell text-align="right" display-align="after"
                                padding-bottom="5mm">
                                <fo:block xsl:use-attribute-sets="TinyFont">
                                    <fo:block xsl:use-attribute-sets="bold orange-text">
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
                                    <fo:block xsl:use-attribute-sets="bold orange-text">
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
        <fo:static-content flow-name="region-before-content" xsl:use-attribute-sets="HeaderFont">
            <fo:block xsl:use-attribute-sets="header"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="page_footer">
        <fo:static-content flow-name="region-after-cover" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer">
                <fo:inline xsl:use-attribute-sets="TinyFont orange-text">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringID" select="'invoice_yaygreen'"/>
                    </xsl:call-template>
                </fo:inline>
            </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="region-after-content" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer">
                <fo:inline xsl:use-attribute-sets="TinyFont orange-text">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringID" select="'invoice_yaygreen'"/>
                    </xsl:call-template>
                </fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>
</xsl:stylesheet>
