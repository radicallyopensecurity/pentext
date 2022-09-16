<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:template match="img">
        <fo:block xsl:use-attribute-sets="graphics-block">
            <xsl:call-template name="checkIfLast"/>
            <fo:block>
                <fo:external-graphic src="{@src}">
                <xsl:choose>
                    <xsl:when test="@width">
                        <xsl:attribute name="width">
                            <xsl:choose>
                                <xsl:when test="contains(@width, 'cm')">
                                    <xsl:value-of select="@width"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat(@width, 'cm')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@height">
                        <xsl:attribute name="height">
                            <xsl:choose>
                                <xsl:when test="contains(@height, 'cm')">
                                    <xsl:value-of select="@height"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat(@height, 'cm')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- No height or width set; should plop down graphic as-is, unless it's larger than the page, in which case scale down to page size -->
                        <!-- Note: this is just making things page-width regardless of size... could be much more robust but I'm going to assume we're working with large graphics for now :/ -->
                        <xsl:attribute name="width">
                            <xsl:text>17cm</xsl:text>
                            <!-- 21cm - 5.5cm for the margins -->
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
                <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
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
            </fo:external-graphic>
            </fo:block>
            <fo:block xsl:use-attribute-sets="img-title"><xsl:value-of select="@title"/></fo:block>
        </fo:block>
    </xsl:template>
    
</xsl:stylesheet>