<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="pages_flimsy.xslt"/>
    <xsl:import href="block.xslt"/>
    <xsl:import href="inline.xslt"/>
    <xsl:import href="auto.xslt"/>
    <xsl:import href="fo_placeholders.xslt"/>
    <xsl:import href="structure.xslt"/>
    <xsl:import href="lists.xslt"/>
    <xsl:import href="generic.xslt"/>
    <xsl:import href="att-set.xslt"/>
    <xsl:import href="table.xslt"/>
    <xsl:import href="numbering.xslt"/>
    <xsl:include href="styles_rat.xslt"/>
    <xsl:include href="localisation.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:include href="functions_params_vars.xslt"/>

    <xsl:template match="ratecard">
        <!-- Invoice is generated straight from offerte -->
        <fo:root xsl:use-attribute-sets="root-common">
            <xsl:call-template name="layout-master-set-flimsy"/>
            <xsl:call-template name="Content">
                <xsl:with-param name="execsummary" select="'no'" tunnel="yes"/>
            </xsl:call-template>
        </fo:root>
    </xsl:template>

  <xsl:template name="Content">
        <fo:page-sequence master-reference="Flimsy">
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

    <!-- title override -->
    <xsl:template match="title[not(parent::biblioentry)]">
        <fo:block padding-left="2mm" xsl:use-attribute-sets="title-0">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="meta">
        <!-- not doing anything here, ratecard meta is only for placeholder references -->
    </xsl:template>

    <xsl:template name="VersionNumber">
        <xsl:param name="number"/>
    </xsl:template>

</xsl:stylesheet>
