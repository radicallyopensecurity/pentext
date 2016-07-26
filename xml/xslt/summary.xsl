<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="pages.xslt"/>
    <xsl:import href="summary.xslt"/>
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
    
    <xsl:include href="styles_rep.xslt"/>
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>


    <!-- ****** AUTO_NUMBERING_FORMAT:	value of the <xsl:number> element used for auto numbering -->
    <xsl:param name="AUTO_NUMBERING_FORMAT" select="'1.1.1'"/>

    <xsl:key name="rosid" match="section|finding|appendix|non-finding" use="@id"/>
    
    <xsl:variable name="CLASSES" select="document('../xslt/styles_rep.xslt')/*/xsl:attribute-set"/>
    
    <xsl:variable name="latestVersionDate">
            <xsl:for-each select="/*/meta/version_history/version">
                <xsl:sort select="xs:dateTime(@date)" order="descending"/>
                <xsl:if test="position() = 1">
                    <xsl:value-of select="format-dateTime(@date, '[MNn] [D1o], [Y]', 'en', (), ())"/>
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

    
</xsl:stylesheet>
