<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- imported from info2contract.xsl and qs2offerte.xsl to select the proper xml snippets -->
    <xsl:template name="docCheck">
        <xsl:param name="snippetDirectory"/>
        <xsl:param name="fileNameBase" select="'none'"/>
        <xsl:variable name="file"
            select="concat('snippets/', $snippetDirectory, '/', $lang, '/', $fileNameBase, '.xml')"/>
        <xsl:value-of select="$file"/>
    </xsl:template>
    
</xsl:stylesheet>