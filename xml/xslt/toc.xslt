<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:template match="generate_index">
        <fo:block xsl:use-attribute-sets="title-toc">Table of Contents</fo:block>
        <fo:block xsl:use-attribute-sets="index">
            <fo:block>
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="proportional-column-width(14)"/>
                    <fo:table-column column-width="proportional-column-width(79)"/>
                    <fo:table-column column-width="proportional-column-width(7)"/>
                    <fo:table-body>
                        <xsl:apply-templates select="/" mode="toc"/>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template match="meta | *[ancestor-or-self::*/@visibility = 'hidden']" mode="toc"/>

    <!-- meta, hidden things and children of hidden things not indexed -->

    <xsl:template
        match="section[not(@visibility = 'hidden')] | finding | appendix[not(@visibility = 'hidden')] | non-finding"
        mode="toc">
        <xsl:param name="execsummary" tunnel="yes"/>
        <xsl:choose>
            <xsl:when test="$execsummary = true()">
                <xsl:if test="ancestor-or-self::*[@inexecsummary][1]/@inexecsummary = 'yes'">
                    <xsl:call-template name="ToC"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ToC"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="ToC">
        <xsl:param name="execsummary" tunnel="yes"/>
        <fo:table-row>
            <fo:table-cell xsl:use-attribute-sets="tocCell">
                <fo:block>
                    <xsl:if test="parent::pentest_report or parent::generic_document">
                        <!-- We're in a top-level section, so add some extra styling -->
                        <xsl:call-template name="topLevelToCEntry"/>
                    </xsl:if>
                    <fo:basic-link>
                        <xsl:attribute name="internal-destination">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <xsl:call-template name="tocContent_Numbering"/>
                    </fo:basic-link>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="tocCell">
                <fo:block>
                    <xsl:if test="parent::pentest_report or parent::generic_document">
                        <!-- We're in a top-level section, so add some extra styling -->
                        <xsl:call-template name="topLevelToCEntry"/>
                    </xsl:if>
                    <fo:basic-link>
                        <xsl:attribute name="internal-destination">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <xsl:call-template name="tocContent_Title"/>
                    </fo:basic-link>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-right="3pt" display-align="after"
                xsl:use-attribute-sets="tocCell">
                <fo:block text-align="right">
                    <xsl:if test="parent::pentest_report or parent::generic_document">
                        <!-- We're in a top-level section, so add some extra styling -->
                        <xsl:call-template name="topLevelToCEntry"/>
                    </xsl:if>
                    <fo:basic-link>
                        <xsl:attribute name="internal-destination">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <fo:page-number-citation ref-id="{@id}"/>
                    </fo:basic-link>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        <xsl:choose>
            <xsl:when test="$execsummary = true()">
                <xsl:apply-templates
                    select="section[not(@visibility = 'hidden')][not(../@visibility = 'hidden')][ancestor-or-self::*[@inexecsummary][1]/@inexecsummary = 'yes']"
                    mode="toc"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates
                    select="section[not(@visibility = 'hidden')][not(../@visibility = 'hidden')] | finding[not(../@visibility = 'hidden')] | non-finding[not(../@visibility = 'hidden')]"
                    mode="toc"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="topLevelToCEntry">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="margin-top">4mm</xsl:attribute>
    </xsl:template>


    <xsl:template name="tocContent_Title">
        <xsl:apply-templates select="title" mode="toc"/>
    </xsl:template>

    <xsl:template match="title" mode="toc">
        <xsl:call-template name="prependId"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="tocContent_Numbering">
        <xsl:param name="execsummary" tunnel="yes"/>
        <xsl:choose>
            <xsl:when test="self::appendix[not(@visibility = 'hidden')]">
                <xsl:choose>
                    <xsl:when test="$execsummary = true()">
                        <fo:inline> Appendix&#160;<xsl:number
                                count="appendix[not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/></fo:inline>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:inline> Appendix&#160;<xsl:number
                                count="appendix[not(@visibility = 'hidden')]" level="multiple"
                                format="{$AUTO_NUMBERING_FORMAT}"/></fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::appendix[not(@visibility = 'hidden')]">
                <xsl:choose>
                    <xsl:when test="$execsummary = true()">
                        <xsl:if test="ancestor::appendix[@inexecsummary = 'yes']">
                            <fo:inline> App&#160;<xsl:number
                                    count="appendix[not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                                    count="section[not(@visibility = 'hidden')][ancestor-or-self::*[@inexecsummary][1]/@inexecsummary = 'yes'][ancestor::appendix[not(@visibility = 'hidden')]]"
                                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                            </fo:inline>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:inline> App&#160;<xsl:number
                                count="appendix[not(@visibility = 'hidden')]" level="multiple"
                                format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                                count="section[not(@visibility = 'hidden')][ancestor::appendix[not(@visibility = 'hidden')]]"
                                level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                        </fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$execsummary = true()">
                        <xsl:number
                            count="section[not(@visibility = 'hidden')][ancestor-or-self::*[@inexecsummary][1]/@inexecsummary = 'yes']"
                            level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
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

</xsl:stylesheet>
