<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="inline.xslt"/>
    
    <xsl:template match="br | p | ul | ol | li | pre | div | img">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="a">
        <xsl:variable name="destination">
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#')">
                    <xsl:value-of select="substring(@href, 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="checkLinkValidity"/>
        <xsl:choose>
            <xsl:when test="starts-with(@href, '#') and not(//*[@id = $destination])">
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string" select="'WARNING: LINK TARGET NOT FOUND IN DOCUMENT'"></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                test="(starts-with(@href, '#') and //*[@id = $destination][ancestor-or-self::*[@visibility = 'hidden']])">
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string" select="'WARNING: LINK TARGET NOT FOUND IN DOCUMENT'"></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <a class="link" href="{@href}">
                    <xsl:call-template name="linkText">
                        <xsl:with-param name="destination" select="$destination"/>
                    </xsl:call-template>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    

    <xsl:template name="linkText">
        <xsl:param name="destination"/>
        <xsl:choose>
            <xsl:when test="starts-with(@href, '#') and not(text())">
                <xsl:for-each select="key('rosid', $destination)">
                    <xsl:if test="not(local-name() = 'appendix' or local-name() = 'finding')">
                        <!-- appendix already has 'appendix' as part of its numbering, findings should not be prefixed with the word 'finding' -->
                        <xsl:value-of select="local-name()"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="." mode="number"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="* | text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="a" mode="summarytable">
        <xsl:variable name="destination">
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#')">
                    <xsl:value-of select="substring(@href, 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <a class="link" href="{@href}">
            <xsl:choose>
                <xsl:when test="starts-with(@href, '#') and not(text())">
                    <xsl:for-each select="key('rosid', $destination)">
                        <xsl:if test="not(local-name() = 'appendix' or local-name() = 'finding')">
                            <!-- appendix already has 'appendix' as part of its numbering, findings should not be prefixed with the word 'finding' -->
                            <xsl:value-of select="local-name()"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:apply-templates select="." mode="number"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="* | text()"/>
                </xsl:otherwise>
            </xsl:choose>
        </a>
    </xsl:template>

    <xsl:template match="b">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>

    <xsl:template match="i">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="u">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="code">
        <xsl:choose>
            <xsl:when test="ancestor::title">
                <code>
                    <xsl:apply-templates/>
                </code>
            </xsl:when>
            <xsl:when test="ancestor::pre">
                <!-- <code> in <pre> is just <pre> -->
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <code>
                    <xsl:apply-templates/>
                </code>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="sup">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="sub">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>