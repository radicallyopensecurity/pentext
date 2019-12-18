<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:template match="ul">
        <fo:list-block xsl:use-attribute-sets="list p">
            <xsl:call-template name="checkIfLast"/>
            <xsl:call-template name="do_ul_default"/>
        </fo:list-block>
    </xsl:template>
    
    
    <xsl:template match="ul" mode="summarytable">
        <!-- skip 'check if last' template -->
        <fo:list-block xsl:use-attribute-sets="list_summarytable">
            <xsl:call-template name="do_ul_summarytable"/>
        </fo:list-block>
    </xsl:template>
    
    <xsl:template name="do_ul_default">
        <xsl:call-template name="space_after_list"/>
        <xsl:call-template name="do_ul"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    <xsl:template name="do_ul_summarytable">
        <xsl:call-template name="do_ul"/>
        <xsl:apply-templates select="*" mode="summarytable"/>
    </xsl:template>
    
    <xsl:template name="do_ul">
        <xsl:call-template name="calculate_indent"/>
    </xsl:template>
    
    <xsl:template name="space_after_list">
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
    </xsl:template>
    
    <xsl:template name="calculate_indent">
        <xsl:attribute name="start-indent">
            <xsl:variable name="base-indent">0.2</xsl:variable>
            <xsl:variable name="ancestors">
                <xsl:choose>
                    <xsl:when test="count(ancestor::ol) or count(ancestor::ul)">
                        <xsl:value-of
                            select="
                                (count(ancestor::ol) +
                                count(ancestor::ul)) *
                                0.75 + $base-indent"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$base-indent"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat($ancestors, 'cm')"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="ul/li">
        <fo:list-item xsl:use-attribute-sets="li">
            <xsl:call-template name="do_ul_li"/>
        </fo:list-item>
    </xsl:template>
    
    <xsl:template match="ul/li" mode="summarytable">
        <fo:list-item>
            <xsl:call-template name="do_ul_li"/>
        </fo:list-item>
    </xsl:template>
    
    <xsl:template name="do_ul_li">
        <fo:list-item-label end-indent="label-end()">
            <fo:block>&#8226;</fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
            <fo:block>
                <xsl:apply-templates select="* | text()"/>
            </fo:block>
        </fo:list-item-body>
    </xsl:template>
    
    <xsl:template match="ol">
        <fo:list-block xsl:use-attribute-sets="list p">
            <xsl:call-template name="checkIfLast"/>
            <xsl:call-template name="do_ol_default"/>
        </fo:list-block>
    </xsl:template>
    
    <xsl:template match="ol" mode="summarytable">
        <fo:list-block xsl:use-attribute-sets="list">
            <xsl:call-template name="do_ol_summarytable"/>
        </fo:list-block>
    </xsl:template>
    
    <xsl:template name="do_ol_default">
        <xsl:call-template name="space_after_list"/>
        <xsl:call-template name="do_ol"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    <xsl:template name="do_ol_summarytable">
        <xsl:call-template name="do_ol"/>
        <xsl:apply-templates select="*" mode="summarytable"/>
    </xsl:template>
    
    <xsl:template name="do_ol">
        <xsl:call-template name="calculate_indent"/>
    </xsl:template>
    
    <xsl:template match="ol/li">
        <fo:list-item xsl:use-attribute-sets="li">
            <xsl:call-template name="do_ol_li"/>
        </fo:list-item>
    </xsl:template>
    
    <xsl:template match="ol/li" mode="summarytable">
        <fo:list-item>
            <xsl:call-template name="do_ol_li"/>
        </fo:list-item>
    </xsl:template>
    
    <xsl:template name="do_ol_li">
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
                    <xsl:when test="../@type = 'i'">
                        <xsl:value-of select="../@labelprefix"/>
                        <xsl:number value="$value-attr" format="i. "/>
                    </xsl:when>
                    <xsl:when test="../@type = 'I'">
                        <xsl:value-of select="../@labelprefix"/>
                        <xsl:number value="$value-attr" format="I. "/>
                    </xsl:when>
                    <xsl:when test="../@type = 'a'">
                        <xsl:value-of select="../@labelprefix"/>
                        <xsl:number value="$value-attr" format="a. "/>
                    </xsl:when>
                    <xsl:when test="../@type = 'A'">
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
                <xsl:apply-templates select="* | text()"/>
            </fo:block>
        </fo:list-item-body>
    </xsl:template>
    
    
    
    <xsl:template match="biblioentries"><!-- div doesn't do anything, it's just there to make snippets more flexible -->
        <fo:list-block xsl:use-attribute-sets="list" space-after="12pt">
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