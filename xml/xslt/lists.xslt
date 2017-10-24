<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:template match="ul">
        <fo:list-block provisional-distance-between-starts="0.75cm"
            provisional-label-separation="2.5mm">
            <xsl:call-template name="checkIfLast"/>
            <xsl:call-template name="do_ul"/>
        </fo:list-block>
    </xsl:template>
    
    
    <xsl:template match="ul" mode="summarytable">
        <!-- skip 'check if last' template -->
        <fo:list-block provisional-distance-between-starts="0.75cm"
            provisional-label-separation="2.5mm">
            <xsl:call-template name="do_ul"/>
        </fo:list-block>
    </xsl:template>
    
    <xsl:template name="do_ul">
        <xsl:attribute name="space-after">
            <xsl:choose>
                <xsl:when test="ancestor::ul or ancestor::ol">
                    <xsl:text>0pt</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>12pt</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="start-indent">
            <xsl:variable name="ancestors">
                <xsl:choose>
                    <xsl:when test="count(ancestor::ol) or count(ancestor::ul)">
                        <xsl:value-of
                            select="
                                1 +
                                (count(ancestor::ol) +
                                count(ancestor::ul)) *
                                1.25"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat($ancestors, 'cm')"/>
        </xsl:attribute>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    
    <xsl:template match="ul/li">
        <fo:list-item xsl:use-attribute-sets="li">
            <fo:list-item-label end-indent="label-end()">
                <fo:block>&#8226;</fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:apply-templates select="*|text()"/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>
    
    <xsl:template match="ol">
        <fo:list-block provisional-distance-between-starts="0.85cm"
            provisional-label-separation="2.5mm">
            <xsl:call-template name="checkIfLast"/>
            <xsl:attribute name="space-after">
                <xsl:choose>
                    <xsl:when test="ancestor::ul or ancestor::ol">
                        <xsl:text>0pt</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>12pt</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="start-indent">
                <xsl:variable name="ancestors">
                    <xsl:choose>
                        <xsl:when test="count(ancestor::ol) or count(ancestor::ul)">
                            <xsl:value-of
                                select="1 + 
                                (count(ancestor::ol) + 
                                count(ancestor::ul)) * 
                                1.25"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>1</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($ancestors, 'cm')"/>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </fo:list-block>
    </xsl:template>
    
    <xsl:template match="ol/li">
        <fo:list-item xsl:use-attribute-sets="li">
            <fo:list-item-label end-indent="label-end()">
                <fo:block>
                    <xsl:variable name="value-attr">
                        <xsl:choose>
                            <xsl:when test="../@start">
                                <xsl:number value="position() + ../@start - 1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:number value="position()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="../@type='i'">
                            <xsl:value-of select="../@labelprefix"/>
                            <xsl:number value="$value-attr" format="i. "/>
                        </xsl:when>
                        <xsl:when test="../@type='I'">
                            <xsl:value-of select="../@labelprefix"/>
                            <xsl:number value="$value-attr" format="I. "/>
                        </xsl:when>
                        <xsl:when test="../@type='a'">
                            <xsl:value-of select="../@labelprefix"/>
                            <xsl:number value="$value-attr" format="a. "/>
                        </xsl:when>
                        <xsl:when test="../@type='A'">
                            <xsl:value-of select="../@labelprefix"/>
                            <xsl:number value="$value-attr" format="A. "/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="../@labelprefix"/>
                            <xsl:number value="$value-attr" format="1. "/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:apply-templates select="*|text()"/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>
    
    
    
    <xsl:template match="biblioentries"><!-- div doesn't do anything, it's just there to make snippets more flexible -->
        <fo:list-block provisional-distance-between-starts="0.75cm"
            provisional-label-separation="2.5mm" space-after="12pt">
            <xsl:call-template name="checkIfLast"/>
            <xsl:apply-templates select="biblioentry"/>
        </fo:list-block>
    </xsl:template>
    
    <xsl:template match="biblioentry">
        <fo:list-item xsl:use-attribute-sets="li">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <fo:list-item-label end-indent="label-end()">
                <fo:block><xsl:number value="position()" format="[1] "/></fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block xsl:use-attribute-sets="biblioentry">
                    <xsl:apply-templates select="*"/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>
</xsl:stylesheet>