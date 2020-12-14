<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">


    <!-- comment -->
    <xsl:attribute-set name="co">
        <xsl:attribute name="color">#998</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- keyword -->
    <xsl:attribute-set name="st">
        <xsl:attribute name="color">#e2632a</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="cf" use-attribute-sets="kw"/>
    <xsl:attribute-set name="kw" use-attribute-sets="st">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- variable -->
    <xsl:attribute-set name="va">
        <xsl:attribute name="color">#415179</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="nt" use-attribute-sets="va"/>
    
    <xsl:attribute-set name="fu">
        <xsl:attribute name="color">#2f4858</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="bu">
        <xsl:attribute name="color">#ac4a83</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="op" use-attribute-sets="fu"/>
    <xsl:attribute-set name="dt">
        <xsl:attribute name="color">#73528b</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- attribute -->
    <xsl:attribute-set name="at">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- example? path, anyway -->
    <xsl:attribute-set name="ex">
        
    </xsl:attribute-set>
    <xsl:attribute-set name="dv" use-attribute-sets="ex"/>
    
    


</xsl:stylesheet>
