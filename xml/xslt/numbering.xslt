<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">


    <xsl:template match="finding" mode="number">
        <!-- Output finding display number (context is finding) -->
        <xsl:variable name="sectionNumber">
            <xsl:if test="/pentest_report/@findingNumberingBase = 'Section'">
                    <xsl:value-of
                        select="count(ancestor::section[last()]/preceding-sibling::section) + 1"/>
                </xsl:if>
        </xsl:variable>
        <xsl:variable name="findingNumber" select="count(preceding::finding) + 1"/>
        <xsl:variable name="numFormat">
            <xsl:choose>
                <xsl:when test="/pentest_report/@findingNumberingBase = 'Section'">00</xsl:when>
                <xsl:otherwise>000</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of
            select="concat(ancestor::*[@findingCode][1]/@findingCode, '-', $sectionNumber, string(format-number($findingNumber, $numFormat)))"
        />
    </xsl:template>
    
    <xsl:template match="non-finding" mode="number">
        <!-- Output finding display number (context is finding) -->
        <xsl:variable name="nonFindingNumber" select="count(preceding::non-finding) + 1"/>
        <xsl:variable name="numFormat" select="'000'"/>
        <xsl:value-of
            select="concat('NF-', string(format-number($nonFindingNumber, $numFormat)))"
        />
    </xsl:template>

    <xsl:template
        match="section[not(@visibility = 'hidden')] | appendix[not(@visibility = 'hidden')]"
        mode="number">
        <xsl:choose>
            <xsl:when test="$EXEC_SUMMARY = true()">
                <xsl:choose>
                    <xsl:when test="self::appendix">
                        <fo:inline> Appendix&#160;<xsl:number
                                count="appendix[not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="ancestor::appendix">
                        <fo:inline> App&#160;<xsl:number count="appendix" level="multiple"
                                format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                                count="section[ancestor::appendix][not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                        </fo:inline>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:inline>
                            <xsl:number
                                count="section[not(@visibility = 'hidden')][ancestor-or-self::*/@inexecsummary = 'yes'] | finding | non-finding"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                        </fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="self::appendix">
                        <fo:inline> Appendix&#160;<xsl:number
                                count="appendix[not(@visibility = 'hidden')]" level="multiple"
                                format="{$AUTO_NUMBERING_FORMAT}"/>
                        </fo:inline>
                    </xsl:when>
                    <xsl:when test="ancestor::appendix">
                        <fo:inline> App&#160;<xsl:number count="appendix" level="multiple"
                                format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                                count="section[ancestor::appendix][not(@visibility = 'hidden')]"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                        </fo:inline>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:inline>
                            <xsl:number
                                count="section[not(@visibility = 'hidden')] | finding | non-finding"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                        </fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="biblioentry" mode="number">
        <fo:inline>
            <xsl:number count="biblioentry" format="{$AUTO_NUMBERING_FORMAT}"/>
        </fo:inline>
    </xsl:template>
    
    <xsl:template name="prependNumber">
        <xsl:choose>
                <xsl:when test="parent::finding">
                    <!-- prepend finding id (XXX-NNN) -->
                    <xsl:apply-templates select=".." mode="number"/>
                    <xsl:text> &#8212; </xsl:text>
                </xsl:when>
                <xsl:when test="parent::non-finding">
                    <!-- prepend non-finding id (NF-NNN) -->
                    <xsl:apply-templates select=".." mode="number"/>
                    <xsl:text> &#8212; </xsl:text>
                </xsl:when>
            </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
