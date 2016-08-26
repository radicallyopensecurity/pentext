<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:template match="a">
        <xsl:variable name="destination">
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#')">
                    <xsl:value-of select="substring(@href, 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with(@href, '#') and not(//*[@id = $destination])">
                <fo:inline xsl:use-attribute-sets="errortext">WARNING: LINK TARGET NOT FOUND IN
                    DOCUMENT</fo:inline>
            </xsl:when>
            <xsl:when
                test="starts-with(@href, '#') and //*[@id = $destination][ancestor-or-self::*[@visibility = 'hidden']]">
                <fo:inline xsl:use-attribute-sets="errortext">WARNING: LINK TARGET IS
                    HIDDEN</fo:inline>
            </xsl:when>
            <xsl:otherwise>
                <fo:basic-link color="blue">
                    <xsl:choose>
                        <xsl:when test="starts-with(@href, '#')">
                            <xsl:attribute name="internal-destination">
                                <xsl:value-of select="$destination"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="external-destination">
                                <xsl:value-of select="$destination"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="starts-with(@href, '#') and not(text())">
                            <xsl:for-each select="key('rosid', $destination)">
                                <xsl:if
                                    test="not(local-name() = 'appendix' or local-name() = 'finding')">
                                    <!-- appendix already has 'appendix' as part of its numbering, findings should not be prefixed with the word 'finding' -->
                                    <xsl:value-of select="local-name()"/>
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:apply-templates select="." mode="number"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="* | text()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:basic-link>
                <xsl:if test="starts-with(@href, '#')">
                    <xsl:text> (page </xsl:text>
                    <fo:page-number-citation ref-id="{substring(@href, 2)}"/>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="a" mode="summarytable">
        <xsl:variable name="destination">
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#')">
                    <xsl:value-of select="substring(@href, 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:basic-link color="blue">
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#')">
                    <xsl:attribute name="internal-destination">
                        <xsl:value-of select="$destination"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="external-destination">
                        <xsl:value-of select="$destination"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#') and not(text())">
                    <xsl:for-each select="key('rosid', $destination)">
                        <xsl:if test="not(local-name() = 'appendix' or local-name() = 'finding')">
                            <!-- appendix already has 'appendix' as part of its numbering, findings should not be prefixed with the word 'finding' -->
                            <xsl:value-of select="local-name()"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:apply-templates select="." mode="number"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="* | text()"/>
                </xsl:otherwise>
            </xsl:choose>
        </fo:basic-link>
    </xsl:template>

    <xsl:template match="b">
        <fo:inline xsl:use-attribute-sets="bold">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="i">
        <fo:inline xsl:use-attribute-sets="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="u">
        <fo:inline xsl:use-attribute-sets="underline">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="monospace">
        <xsl:choose>
            <xsl:when test="parent::title">
                <fo:inline xsl:use-attribute-sets="monospace-title">
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline xsl:use-attribute-sets="monospace">
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="sup">
        <fo:inline xsl:use-attribute-sets="sup">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="sub">
        <fo:inline xsl:use-attribute-sets="sub">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="fnref">
        <xsl:variable name="fnCount" select="count(preceding::fnref) + 1"/>
        <fo:footnote>
            <fo:inline xsl:use-attribute-sets="sup">
                <xsl:value-of select="$fnCount"/>
                <xsl:text>&#160;</xsl:text>
            </fo:inline>
            <fo:footnote-body xsl:use-attribute-sets="TinyFont">
                <fo:block>
                    <fo:inline xsl:use-attribute-sets="sup">
                        <xsl:value-of select="$fnCount"/>
                    </fo:inline>
                    <xsl:apply-templates/>
                </fo:block>
            </fo:footnote-body>
        </fo:footnote>
    </xsl:template>

    <xsl:template match="bibref">
        <xsl:variable name="bibid" select="./@ref"/>
        <xsl:variable name="bibCount" select="count(preceding::biblioentry[@id = $bibid]) + 1"/>
        <xsl:choose>
            <xsl:when test="starts-with(@href, '#') and not(//*[@id = $bibid])">
                <fo:inline xsl:use-attribute-sets="errortext">WARNING: BIBLIOGRAPHY ENTRY NOT FOUND
                    IN DOCUMENT</fo:inline>
            </xsl:when>
            <xsl:when
                test="starts-with(@href, '#') and //*[@id = $bibid][ancestor-or-self::*[@visibility = 'hidden']]">
                <fo:inline xsl:use-attribute-sets="errortext">WARNING: BIBLIOGRAPHY ENTRY IS
                    HIDDEN</fo:inline>
            </xsl:when>
            <xsl:otherwise>
                <fo:basic-link>
                    <xsl:attribute name="internal-destination">
                        <xsl:value-of select="$bibid"/>
                    </xsl:attribute>
                    <xsl:text>[</xsl:text>
                    <xsl:for-each select="key('biblioid', $bibid)">
                                <xsl:apply-templates select="." mode="number"/>
                            </xsl:for-each>
                    <xsl:text>]</xsl:text>
                </fo:basic-link>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="author">
        <xsl:value-of select="firstname"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="surname"/>
        <xsl:if test="org">
            <xsl:if test="firstname | surname">
                <xsl:text> (</xsl:text>
            </xsl:if>
            <xsl:value-of select="org"/>
            <xsl:if test="firstname | surname">
                <xsl:text>)</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="following-sibling::author">, </xsl:when>
            <xsl:otherwise>
                <xsl:text>. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="biblioentry/title">
        <xsl:choose>
            <xsl:when test="../@role = 'book'">
                <fo:inline xsl:use-attribute-sets="title.book">
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:when>
            <xsl:when test="../@role = 'article'">
                <fo:inline xsl:use-attribute-sets="title.article">
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="following-sibling::info">
                <!-- we're getting something more, place a comma -->
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="journal">
        <fo:inline xsl:use-attribute-sets="journal">
            <xsl:apply-templates/>
        </fo:inline>
        <xsl:choose>
            <xsl:when test="following-sibling::info or following-sibling::pubdate">
                <!-- we're getting something more, place a comma -->
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="website">
        <fo:inline xsl:use-attribute-sets="website">
            <xsl:apply-templates/>
        </fo:inline>
        <xsl:choose>
            <xsl:when test="following-sibling::info or following-sibling::pubdate">
                <!-- we're getting something more, place a comma -->
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="info">
        <fo:inline xsl:use-attribute-sets="info">
            <xsl:apply-templates/>
        </fo:inline>
        <xsl:choose>
            <xsl:when test="../@role = 'article' and following-sibling::pubdate">
                <!-- we're getting something more, place a comma -->
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="publisher">
        <fo:inline xsl:use-attribute-sets="publisher">
            <xsl:apply-templates/>
        </fo:inline>
        <xsl:choose>
            <xsl:when test="following-sibling::pubdate">
                <!-- we're getting something more, place a comma -->
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>. </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="publisher/name">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::location">
            <!-- we're getting something more, place a comma -->
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="publisher/location">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="pubdate">
        <fo:inline xsl:use-attribute-sets="pubdate">
            <xsl:apply-templates/>
        </fo:inline>
        <xsl:text>. </xsl:text>
    </xsl:template>

    <xsl:template match="link">
        <xsl:apply-templates select="a"/>
        <xsl:text>. </xsl:text>
        <xsl:if test="accessed"><xsl:apply-templates select="accessed"/></xsl:if>
    </xsl:template>

    <xsl:template match="accessed">
        <xsl:text>Accessed: </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>.</xsl:text>
    </xsl:template>

</xsl:stylesheet>
