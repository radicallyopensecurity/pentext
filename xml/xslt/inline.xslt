<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template name="checkLinkValidity">
        <xsl:if test="not(starts-with(@href, '#')) and not(contains(@href, '://')) and not(contains(@href, 'mailto:'))">
            <xsl:call-template name="displayErrorText">
                <xsl:with-param name="string">[ Invalid link: use #[id] for internal links or a
                    well-formed url for external ones ]</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="todo">
        <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string">### TODO<xsl:if test="@desc or not(normalize-space() = '')">: <xsl:value-of select="@desc"/><xsl:value-of select="."/></xsl:if> ###</xsl:with-param>
                </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
