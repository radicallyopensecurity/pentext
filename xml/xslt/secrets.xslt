<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs" version="2.0">

    <!-- black out anything you don't want seen -->
    <xsl:template match="secret">
        <xsl:choose>
            <xsl:when test="/pentest_report[@secrets = 'hide']">
                <xsl:choose>
                    <xsl:when
                        test="img | generate_piechart | p | div | table | section | ol | ul | pre">
                        <fo:block xsl:use-attribute-sets="censoredblock">
                            <xsl:call-template name="checkIfLast"/>
                            <xsl:text>[ CENSORED ]</xsl:text></fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:inline xsl:use-attribute-sets="censoredtext">[ CENSORED ]</fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
