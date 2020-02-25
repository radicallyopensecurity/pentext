<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"  xmlns:my="http://www.radical.sexy"
    exclude-result-prefixes="my xs" version="2.0">


    <xsl:import href="pages.xslt"/>
    <xsl:import href="meta.xslt"/>
    <xsl:import href="toc.xslt"/>
    <xsl:import href="structure.xslt"/>
    <xsl:import href="block.xslt"/>
    <xsl:import href="auto.xslt"/>
    <xsl:import href="table.xslt"/>
    <xsl:import href="lists.xslt"/>
    <xsl:import href="fo_inline.xslt"/>
    <xsl:import href="graphics.xslt"/>
    <xsl:import href="generic.xslt"/>
    <xsl:import href="numbering.xslt"/>
    <xsl:import href="localisation.xslt"/>
    <xsl:import href="fo_placeholders.xslt"/>

    <xsl:include href="styles_rep.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

    <xsl:include href="functions_params_vars.xslt"/>
    
    
    <!-- numbered titles or not? -->
    <xsl:param name="NUMBERING" select="true()"/>

    <!-- ROOT -->
    <xsl:template match="/">

        <fo:root xsl:use-attribute-sets="root-common">
            <xsl:call-template name="layout-master-set"/>
            <xsl:call-template name="FrontMatter">
                <xsl:with-param name="execsummary" select="false()" tunnel="yes"/>
            </xsl:call-template>
            <xsl:call-template name="Content">
                <xsl:with-param name="execsummary" select="false()" tunnel="yes"/>
            </xsl:call-template>
        </fo:root>
    </xsl:template>
    

</xsl:stylesheet>
