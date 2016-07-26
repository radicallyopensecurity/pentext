<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="pages.xslt"/>
    <xsl:import href="meta.xslt"/>
    <xsl:import href="toc.xslt"/>
    <xsl:import href="structure.xslt"/>
    <xsl:import href="att-set.xslt"/>
    <xsl:import href="block.xslt"/>
    <xsl:import href="findings.xslt"/>
    <xsl:import href="auto.xsl"/>
    <xsl:import href="table.xslt"/>
    <xsl:import href="lists.xslt"/>
    <xsl:import href="inline.xslt"/>
    <xsl:import href="graphics.xslt"/>
    <xsl:import href="generic.xslt"/>
    <xsl:import href="numbering.xslt"/>
    <xsl:import href="waiver.xslt"/>
    
    <xsl:include href="localisation.xslt"/>
    <xsl:include href="styles_off.xslt"/>
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>


    <!-- ****** AUTO_NUMBERING_FORMAT:	value of the <xsl:number> element used for auto numbering -->
    <xsl:param name="AUTO_NUMBERING_FORMAT" select="'1.1.1'"/>
    

    <xsl:key name="rosid" match="section|finding|appendix|non-finding" use="@id"/>
    
    
    <xsl:variable name="CLASSES" select="document('../xslt/styles_off.xslt')/*/xsl:attribute-set"/>
    
    <xsl:variable name="lang" select="/offerte/@xml:lang"/>
    <xsl:variable name="localDateFormat" select="$strdoc/date/format[lang($lang)]"/>
    
    <xsl:variable name="latestVersionDate">
            <xsl:for-each select="/*/meta/version_history/version">
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
    
<!-- ROOT -->
    <xsl:template match="/">

        <fo:root>

            <xsl:call-template name="layout-master-set"/>
            <xsl:call-template name="Content"/>

        </fo:root>
    </xsl:template>

<!-- OVERRIDES -->
    
    <!-- FRONT PAGE -->
    <xsl:template match="meta">
        <fo:block xsl:use-attribute-sets="graphics-block">
            <fo:external-graphic xsl:use-attribute-sets="logo"/>
        </fo:block>
        <fo:block xsl:use-attribute-sets="title-0">
            <xsl:value-of select="upper-case(company/full_name)"/>
        </fo:block>
        <fo:block xsl:use-attribute-sets="for">
            <xsl:call-template name="getString">
                    <xsl:with-param name="stringID" select="'coverpage_offer'"/>
                </xsl:call-template>
        </fo:block>
        <fo:block xsl:use-attribute-sets="title-0">
            <xsl:value-of select="upper-case(offered_service_long)"/>
        </fo:block>
        <fo:block xsl:use-attribute-sets="for">
            <xsl:call-template name="getString">
                    <xsl:with-param name="stringID" select="'coverpage_for'"/>
                </xsl:call-template>
        </fo:block>
        <fo:block xsl:use-attribute-sets="title-client">
            <xsl:value-of select="permission_parties/client/full_name"/>
        </fo:block>
        <!-- NO DOCUMENT CONTROL, JUST THE DATE ON THE FP -->
        <fo:block xsl:use-attribute-sets="for break-after">
            <xsl:value-of select="$latestVersionDate"/>
        </fo:block>
    </xsl:template>
    
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
    
    <!-- CONTACT BOX (comes at the end, is just the address, no title/table) -->
    <xsl:template match="contact">
        <fo:block xsl:use-attribute-sets="Contact">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="contact/name">
            <fo:block><xsl:apply-templates/></fo:block>
        </xsl:template>
    <!--<xsl:template match="contact/address">
            <fo:block><xsl:apply-templates/></fo:block>
        </xsl:template>-->
    <!-- is already in block.xslt -->
    <xsl:template match="contact/phone">
            <fo:block><xsl:apply-templates/></fo:block>
        </xsl:template>
    <xsl:template match="contact/email">
            <fo:block><xsl:apply-templates/></fo:block>
        </xsl:template>
</xsl:stylesheet>
