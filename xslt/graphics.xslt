<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:template match="img">
        <xsl:variable name="imageWidth">
            <xsl:choose>
                <xsl:when test="not(@width != '')">
                    <xsl:text>100%</xsl:text>
                </xsl:when>
                <xsl:when test="translate(@width, '0123456789.', '') = ''">
                    <!-- legacy behavior, add cm unit -->
                    <xsl:value-of select="concat(@width, 'cm')"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- percent or other unit included -->
                    <xsl:value-of select="@width"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="graphics-block">
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block>
                            <fo:external-graphic src="{@src}" content-width="scale-to-fit" content-height="auto" scaling="uniform" width="{$imageWidth}">
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
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block xsl:use-attribute-sets="img-title">
                            <xsl:value-of select="@title"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
</xsl:stylesheet>