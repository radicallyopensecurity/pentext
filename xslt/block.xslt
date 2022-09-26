<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:template name="checkIfLast">
        <!-- Checks if an element is last in the section / appendix and adds some space after it if it is -->
        <xsl:if
            test="
                (parent::section and not(following-sibling::*)) or
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

    <xsl:template match="blockquote">
        <fo:block xsl:use-attribute-sets="p blockquote">
            <xsl:call-template name="checkIfLast"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="li/p">
        <fo:block xsl:use-attribute-sets="li">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- special case for p in summary table to avoid checkiflast - all other elements can ignore mode -->

    <xsl:template match="*" mode="summarytable">
        <xsl:apply-templates select="."/>
    </xsl:template>

    <!-- p is more specific so has higher prio -->
    <xsl:template match="p" mode="summarytable">
        <xsl:apply-templates mode="summarytable"/>
    </xsl:template>



    <xsl:template match="pre">
        <fo:block xsl:use-attribute-sets="pre">
            <xsl:call-template name="checkIfLast"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="div">
        <!-- div doesn't do anything, it's just there to make snippets more flexible -->
        <fo:block>
            <xsl:call-template name="checkIfLast"/>
            <xsl:apply-templates select="@* | node()"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="signature_box">
        <xsl:variable name="signee-difference"
            select="count(client_side/signee) - count(company_side/signee)"/>
        <fo:block keep-together.within-page="always" xsl:use-attribute-sets="signaturebox">
            <fo:block xsl:use-attribute-sets="title-client">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringID" select="'signed'"/>
                </xsl:call-template>
            </fo:block>
            <fo:block>
                <fo:table xsl:use-attribute-sets="fwtable borders">
                    <fo:table-column column-width="proportional-column-width(50)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-column column-width="proportional-column-width(50)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>For <fo:inline xsl:use-attribute-sets="bold"><xsl:value-of
                                            select="//client/full_name"/></fo:inline></fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>For <fo:inline xsl:use-attribute-sets="bold"><xsl:value-of
                                            select="//company/full_name"/></fo:inline></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <!-- client side -->
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <xsl:if test="$signee-difference &lt; 0">
                                    <xsl:call-template name="insertEmptyBlocks">
                                        <xsl:with-param name="times"
                                            select="abs($signee-difference)"/>
                                    </xsl:call-template>
                                </xsl:if>
                                <xsl:for-each select="client_side/signee">
                                    <xsl:call-template name="signeeBlock"/>
                                </xsl:for-each>
                            </fo:table-cell>
                            <!-- company side -->
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <xsl:if test="$signee-difference > 0">
                                    <xsl:call-template name="insertEmptyBlocks">
                                        <xsl:with-param name="times" select="$signee-difference"/>
                                    </xsl:call-template>
                                </xsl:if>
                                <xsl:for-each select="company_side/signee">
                                    <xsl:call-template name="signeeBlock"/>
                                </xsl:for-each>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <xsl:for-each select="client_side/place">
                                    <fo:block>
                                        <xsl:apply-templates/>
                                    </fo:block>
                                </xsl:for-each>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <xsl:for-each select="company_side/place">
                                    <fo:block>
                                        <xsl:apply-templates/>
                                    </fo:block>
                                </xsl:for-each>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <xsl:for-each select="client_side/date">
                                    <xsl:call-template name="dateBlock"/>
                                </xsl:for-each>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <xsl:for-each select="company_side/date">
                                    <xsl:call-template name="dateBlock"/>
                                </xsl:for-each>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:block>
    </xsl:template>
    
    <xsl:template name="dateBlock">
        <xsl:choose>
            <xsl:when
                test="not(normalize-space(.)) and not(child::*)">
                <!-- don't have a date, insert dotted name line -->
                    <fo:block margin-top="0.2cm" margin-bottom="0.2cm">(Date:<fo:leader
                        xsl:use-attribute-sets="signee_dottedline" leader-length="7.2cm"
                    />)</fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="signeeBlock">
        <xsl:choose>
            <xsl:when
                test="(client_legal_rep and not(normalize-space(//client/legal_rep))) or (not(normalize-space(.)) and not(*))">
                <!-- don't have a name, add dotted name line -->
                <fo:block-container xsl:use-attribute-sets="signee">
                    <fo:block xsl:use-attribute-sets="signee_signaturespace">
                        <fo:leader xsl:use-attribute-sets="signee_dottedline" leader-length="8cm"/>
                    </fo:block>
                    <fo:block margin-top="0.2cm" margin-bottom="0.2cm">(Name:<fo:leader
                            xsl:use-attribute-sets="signee_dottedline" leader-length="7cm"
                        />)</fo:block>
                </fo:block-container>
            </xsl:when>
            <xsl:otherwise>
                <fo:block-container xsl:use-attribute-sets="signee">
                    <fo:block xsl:use-attribute-sets="signee_signaturespace">
                        <fo:leader xsl:use-attribute-sets="signee_dottedline" leader-length="8cm"/>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="signee_name">
                        <xsl:apply-templates/>
                    </fo:block>
                </fo:block-container>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="emptyBlock">
        <fo:block-container xsl:use-attribute-sets="signee">
            <fo:block>&#160; </fo:block>
        </fo:block-container>
    </xsl:template>

    <xsl:template name="insertEmptyBlocks">
        <xsl:param name="index" select="1"/>
        <xsl:param name="times"/>

        <xsl:call-template name="emptyBlock"/>

        <xsl:if test="not($index = $times)">
            <xsl:call-template name="insertEmptyBlocks">
                <xsl:with-param name="index" select="$index + 1"/>
                <xsl:with-param name="times" select="$times"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="h2">
        <fo:block xsl:use-attribute-sets="h2">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="h3">
        <fo:block xsl:use-attribute-sets="h3">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="h4">
        <fo:block xsl:use-attribute-sets="h4">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>
