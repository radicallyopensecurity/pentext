<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="secrets.xslt"/>
    
    <xsl:template name="censoredBlock">
        <fo:block xsl:use-attribute-sets="censoredblock">
            <xsl:call-template name="checkIfLast"/>
            <xsl:text>[ CENSORED ]</xsl:text>
        </fo:block>
    </xsl:template>
    
    <xsl:template name="censoredInline">
        <fo:inline xsl:use-attribute-sets="censoredtext">[ CENSORED ]</fo:inline>
    </xsl:template>
    
</xsl:stylesheet>