<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    
    <xsl:template match="finding" mode="number">
        <!-- Output finding display number (context is finding) -->
        <xsl:variable name="sectionNumber">
            <xsl:choose>
                <xsl:when test="/pentest_report/@findingNumberingBase = 'Section'">
                    <xsl:value-of select="count(ancestor::section[last()]/preceding-sibling::section) + 1"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="findingNumber" select="count(preceding::finding)+1"/>
        <xsl:variable name="numFormat" select="'00'"/>
        <xsl:value-of
            select="concat(ancestor::*[@findingCode][1]/@findingCode,'-',$sectionNumber, string(format-number($findingNumber, $numFormat)))"
        />
    </xsl:template>
    
    <xsl:template match="section[not(@visibility='hidden')]|appendix[not(@visibility='hidden')]|non-finding" mode="number">
        <xsl:choose>
            <xsl:when test="self::appendix">
                <fo:inline> Appendix&#160;<xsl:number count="appendix[not(@visibility='hidden')]" level="multiple"
                    format="{$AUTO_NUMBERING_FORMAT}"/>
                </fo:inline>
            </xsl:when>
            <xsl:when test="ancestor::appendix">
                <fo:inline> App&#160;<xsl:number count="appendix" level="multiple"
                    format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number count="section[ancestor::appendix][not(@visibility='hidden')]" level="multiple"
                        format="{$AUTO_NUMBERING_FORMAT}"/>
                </fo:inline>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline>
                    <xsl:number count="section[not(@visibility='hidden')]|finding|non-finding" level="multiple"
                        format="{$AUTO_NUMBERING_FORMAT}"/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="biblioentry" mode="number">
                <fo:inline>
                    <xsl:number count="biblioentry" 
                        format="{$AUTO_NUMBERING_FORMAT}"/>
                </fo:inline>
    </xsl:template>
    
</xsl:stylesheet>