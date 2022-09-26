<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:template match="table">
        <!-- calculate total width of columns (if any) -->
        <xsl:variable name="colnumbers" select="replace(@cols, 'cm', '')"/>
        <xsl:variable name="coltotalwidth" select="sum(for $s in tokenize($colnumbers, '\s') return number($s))"/>
        <fo:block xsl:use-attribute-sets="table">
            <fo:table table-layout="fixed" width="100%"><!-- outer table to center the inner one (thanks, FOP :/) -->
                <fo:table-column column-width="proportional-column-width(1)"/>
                <fo:table-column>
                    <xsl:choose>
                        <xsl:when test="@cols"><!-- user's table has a cols attr, so we can set the middle column to be as wide as the total column width of her table -->
                            <xsl:attribute name="column-width" select="concat($coltotalwidth, 'cm')"></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@width"><!-- user's table has a width attr, so we can set the middle column to be that width -->
                        <xsl:attribute name="column-width" select="@width"/>
                    </xsl:when>
                        <xsl:otherwise><!-- if not, we got to take a gamble -->
                            <xsl:attribute name="column-width" select="'proportional-column-width(4)'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:table-column>
                <fo:table-column column-width="proportional-column-width(1)"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell column-number="2"><!-- positioning our content in the middle cell -->
                            <fo:block>
                                <!-- this is the start of the actual table the user has created -->
                                <fo:table table-layout="fixed"
                                    xsl:use-attribute-sets="table">
                                    <xsl:call-template name="checkIfLast"/>
                                    <xsl:choose>
                                        <xsl:when test="@cols">
                                            <xsl:attribute name="width" select="concat($coltotalwidth, 'cm')"/>
                                            <xsl:call-template name="build-columns">
                                                <xsl:with-param name="cols"
                                                  select="concat(@cols, ' ')"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:when test="@width">
                                            <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="width">100%</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <fo:table-body>
                                        <xsl:if test="@border = '1' or @border='yes'">
                                            <xsl:attribute name="border-style">
                                                <xsl:text>solid</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="border-color">
                                                <xsl:value-of select="$border-color"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="border-width">
                                                <xsl:text>1pt</xsl:text>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:apply-templates select="*"/>
                                    </fo:table-body>
                                </fo:table>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template name="build-columns">
        <xsl:param name="cols"/>

        <xsl:if test="string-length(normalize-space($cols))"><!-- check if @cols has content -->
            <xsl:variable name="next-col">
                <xsl:value-of select="substring-before($cols, ' ')"/>
            </xsl:variable>
            <xsl:variable name="remaining-cols">
                <xsl:value-of select="substring-after($cols, ' ')"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="contains($next-col, 'cm')">
                    <fo:table-column column-width="{$next-col}"/>
                </xsl:when>
                <xsl:when test="number($next-col) > 0">
                    <fo:table-column column-width="{concat($next-col, 'cm')}"/>
                </xsl:when>
                <xsl:otherwise>
                    <fo:table-column column-width="proportional-column-width(1)"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:call-template name="build-columns">
                <xsl:with-param name="cols" select="concat($remaining-cols, ' ')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="td">
        <fo:table-cell xsl:use-attribute-sets="td">
            <xsl:if test="@colspan">
                <xsl:attribute name="number-columns-spanned">
                    <xsl:value-of select="@colspan"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@rowspan">
                <xsl:attribute name="number-rows-spanned">
                    <xsl:value-of select="@rowspan"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if
                test="
                    (@border = '1' or
                    ancestor::tr[@border = '1'] or
                    ancestor::thead[@border = '1'] or
                    ancestor::table[@border = '1']) and
                    following-sibling::*">
                <xsl:attribute name="border-end-style">
                    <xsl:text>solid</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="border-end-color">
                    <xsl:text>#e4e4e4</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="border-end-width">
                    <xsl:text>1pt</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="align">
                <xsl:choose>
                    <xsl:when test="@align">
                        <xsl:choose>
                            <xsl:when test="@align = 'center'">
                                <xsl:text>center</xsl:text>
                            </xsl:when>
                            <xsl:when test="@align = 'right'">
                                <xsl:text>right</xsl:text>
                            </xsl:when>
                            <xsl:when test="@align = 'justify'">
                                <xsl:text>justify</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>left</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="ancestor::tr[@align]">
                        <xsl:choose>
                            <xsl:when test="ancestor::tr/@align = 'center'">
                                <xsl:text>center</xsl:text>
                            </xsl:when>
                            <xsl:when test="ancestor::tr/@align = 'right'">
                                <xsl:text>right</xsl:text>
                            </xsl:when>
                            <xsl:when test="ancestor::tr/@align = 'justify'">
                                <xsl:text>justify</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>left</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="ancestor::thead">
                        <xsl:text>center</xsl:text>
                    </xsl:when>
                    <xsl:when test="ancestor::table[@align]">
                        <xsl:choose>
                            <xsl:when test="ancestor::table/@align = 'center'">
                                <xsl:text>center</xsl:text>
                            </xsl:when>
                            <xsl:when test="ancestor::table/@align = 'right'">
                                <xsl:text>right</xsl:text>
                            </xsl:when>
                            <xsl:when test="ancestor::table/@align = 'justify'">
                                <xsl:text>justify</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>left</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>left</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <fo:block text-align="{$align}">
                <xsl:apply-templates select="* | text()"/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>

    <xsl:template match="tfoot">
        <xsl:apply-templates select="tr"/>
    </xsl:template>

    <xsl:template match="th">
        <fo:table-cell xsl:use-attribute-sets="th">
            <xsl:if test="@colspan">
                <xsl:attribute name="number-columns-spanned">
                    <xsl:value-of select="@colspan"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@rowspan">
                <xsl:attribute name="number-rows-spanned">
                    <xsl:value-of select="@rowspan"/>
                </xsl:attribute>
            </xsl:if>
            <fo:block>
                <xsl:apply-templates select="* | text()"/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>

    <xsl:template match="thead">
        <xsl:apply-templates select="tr"/>
    </xsl:template>

    <xsl:template match="tr">
        <xsl:choose>
            <xsl:when test="not(td)">
                <!-- don't have th widows -->
                <fo:table-row keep-with-next.within-column="always">
                    <xsl:apply-templates select="* | text()"/>
                </fo:table-row>
            </xsl:when>
            <xsl:otherwise>
                <fo:table-row>
                    <xsl:if test="(count(preceding-sibling::tr) + 1) mod 2 = 0">
                        <xsl:attribute name="background-color">#ededed</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="* | text()"/>
                </fo:table-row>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
