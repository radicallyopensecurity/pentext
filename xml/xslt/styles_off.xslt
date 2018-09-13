<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:import href="styles.xslt"/>
    
    <!-- variables -->
    
    <xsl:variable name="medium-space">8pt</xsl:variable>
    
    <!-- Text -->
    <xsl:attribute-set name="p">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$small-space"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Pages -->
    <xsl:attribute-set name="region-body-cover">
        <xsl:attribute name="background-image"
            >url(../graphics/frontpage_quote.jpg)</xsl:attribute>
    </xsl:attribute-set>
    
</xsl:stylesheet>