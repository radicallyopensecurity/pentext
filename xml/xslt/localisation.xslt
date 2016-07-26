<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">

    
    <xsl:variable name="strdoc"
        select="document('../source/snippets/localisationstrings.xml')/localised_strings"/>


    
    
    <xsl:template name="getString">
        <xsl:param name="stringID" select="'none'"/>
        <xsl:copy-of select="$strdoc/string[@id=$stringID]/translation[lang($lang)]/node()"/>
    </xsl:template>

</xsl:stylesheet>
