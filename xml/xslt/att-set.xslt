<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:template match="@class">
        <xsl:call-template name="use-att-set">
            <xsl:with-param name="CLASS" select="string(.)"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="use-att-set">
        <xsl:param name="CLASS" select="."/>
        <xsl:param name="SUFFIX"/>
        <xsl:choose>
            <xsl:when test="contains($CLASS, ' ')">
                <xsl:call-template name="att-set">
                    <xsl:with-param name="CLASS"
                        select="concat(substring-before($CLASS, ' '), $SUFFIX)"/>
                </xsl:call-template>
                <xsl:call-template name="use-att-set">
                    <xsl:with-param name="CLASS" select="substring-after($CLASS, ' ')"/>
                    <xsl:with-param name="SUFFIX" select="$SUFFIX"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="att-set">
                    <xsl:with-param name="CLASS" select="concat($CLASS, $SUFFIX)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- att-set handles only one single class -->
    <xsl:template name="att-set">
        <xsl:param name="CLASS"/>

        <xsl:choose>
            <xsl:when test="normalize-space($CLASS) = ''"/>
            <xsl:otherwise>
                <xsl:if test="$CLASSES[@name = $CLASS]/@use-attribute-sets">
                    <xsl:call-template name="use-att-set">
                        <xsl:with-param name="CLASS"
                            select="$CLASSES[@name = $CLASS]/@use-attribute-sets"/>
                    </xsl:call-template>
                </xsl:if>

                <xsl:for-each select="$CLASSES[@name = $CLASS]/xsl:attribute">
                    <xsl:attribute name="{@name}">
                        <xsl:apply-templates/>
                    </xsl:attribute>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
