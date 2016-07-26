<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:template match="table">
        <fo:table table-layout="fixed" width="100%">
            <xsl:call-template name="checkIfLast"/>
            <xsl:choose>
                <xsl:when test="@cols">
                    <xsl:call-template name="build-columns">
                        <xsl:with-param name="cols" select="concat(@cols, ' ')"/>
                    </xsl:call-template>
                </xsl:when><!--
                <xsl:otherwise>
                    <fo:table-column column-width="100%"/>
                </xsl:otherwise>-->
            </xsl:choose>
            <fo:table-body>
                <xsl:apply-templates select="*"/>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <xsl:template name="build-columns">
        <xsl:param name="cols"/>
        
        <xsl:if test="string-length(normalize-space($cols))">
            <xsl:variable name="next-col">
                <xsl:value-of select="substring-before($cols, ' ')"/>
            </xsl:variable>
            <xsl:variable name="remaining-cols">
                <xsl:value-of select="substring-after($cols, ' ')"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="contains($next-col, 'mm')">
                    <fo:table-column column-width="{$next-col}"/>
                </xsl:when>
                <xsl:when test="number($next-col) > 0">
                    <fo:table-column column-width="{concat($next-col, 'mm')}"/>
                </xsl:when>
                <xsl:otherwise>
                    <fo:table-column column-width="100%"/>
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
                test="@border='1' or 
                ancestor::tr[@border='1'] or
                ancestor::thead[@border='1'] or
                ancestor::table[@border='1']">
                <xsl:attribute name="border-style">
                    <xsl:text>solid</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="border-color">
                    <xsl:text>black</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="border-width">
                    <xsl:text>1pt</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="align">
                <xsl:choose>
                    <xsl:when test="@align">
                        <xsl:choose>
                            <xsl:when test="@align='center'">
                                <xsl:text>center</xsl:text>
                            </xsl:when>
                            <xsl:when test="@align='right'">
                                <xsl:text>right</xsl:text>
                            </xsl:when>
                            <xsl:when test="@align='justify'">
                                <xsl:text>justify</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>left</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="ancestor::tr[@align]">
                        <xsl:choose>
                            <xsl:when test="ancestor::tr/@align='center'">
                                <xsl:text>center</xsl:text>
                            </xsl:when>
                            <xsl:when test="ancestor::tr/@align='right'">
                                <xsl:text>right</xsl:text>
                            </xsl:when>
                            <xsl:when test="ancestor::tr/@align='justify'">
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
                            <xsl:when test="ancestor::table/@align='center'">
                                <xsl:text>center</xsl:text>
                            </xsl:when>
                            <xsl:when test="ancestor::table/@align='right'">
                                <xsl:text>right</xsl:text>
                            </xsl:when>
                            <xsl:when test="ancestor::table/@align='justify'">
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
                <xsl:apply-templates select="*|text()"/>
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
            <xsl:if
                test="@border='1' or 
                ancestor::tr[@border='1'] or
                ancestor::table[@border='1']">
                <xsl:attribute name="border-style">
                    <xsl:text>solid</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="border-color">
                    <xsl:text>black</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="border-width">
                    <xsl:text>1pt</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <fo:block>
                <xsl:apply-templates select="*|text()"/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>
    
    <xsl:template match="thead">
        <xsl:apply-templates select="tr"/>
    </xsl:template>
    
    <xsl:template match="tr">
        <xsl:choose>
            <xsl:when test="not(child::td)">
                <fo:table-row keep-with-next.within-column="always">
                    <xsl:apply-templates select="*|text()"/>
                </fo:table-row>
            </xsl:when>
            <xsl:otherwise>
                <fo:table-row>
                    <xsl:apply-templates select="*|text()"/>
                </fo:table-row>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>