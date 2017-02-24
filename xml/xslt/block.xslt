<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:template name="checkIfLast">
        <!-- Checks if an element is last in the section / appendix and adds some space after it if it is -->
        <xsl:if
            test="(parent::section and not(following-sibling::*)) or 
            (parent::appendix and not(following-sibling::*)) or 
            (ancestor::section and not(following-sibling::*) and not(parent::*/following-sibling::*) and not(parent::div) and not(parent::li)) or 
            (ancestor::appendix and not(following-sibling::*) and not(parent::*/following-sibling::*) and not(parent::div) and not(parent::li)) or 
            (not(self::title) and following-sibling::*[1][self::section]) or
            (not(self::title) and following-sibling::*[1][self::finding]) or
            (not(self::title) and following-sibling::*[1][self::non-finding])">
            <xsl:attribute name="margin-bottom" select="$very-large-space"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="company/address">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="br">
        <fo:block/>
    </xsl:template>
    
    <xsl:template match="p">
        <fo:block xsl:use-attribute-sets="p">
            <xsl:call-template name="checkIfLast"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="li/p">
        <fo:block xsl:use-attribute-sets="li">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="p" mode="summarytable">
        <xsl:apply-templates mode="summarytable"/>
    </xsl:template>
    
    <xsl:template match="pre">
        <fo:block xsl:use-attribute-sets="pre">
            <xsl:call-template name="checkIfLast"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="div"><!-- div doesn't do anything, it's just there to make snippets more flexible -->
        <fo:block>
            <xsl:call-template name="checkIfLast"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
</xsl:stylesheet>