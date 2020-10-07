<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:my="http://www.radical.sexy"
    exclude-result-prefixes="xs my" version="2.0" extension-element-prefixes="my">


    <xsl:import href="pages.xslt"/>
    <xsl:import href="meta.xslt"/>
    <xsl:import href="toc.xslt"/>
    <xsl:import href="structure.xslt"/>
    <xsl:import href="att-set.xslt"/>
    <xsl:import href="block.xslt"/>
    <xsl:import href="auto.xslt"/>
    <xsl:import href="table.xslt"/>
    <xsl:import href="lists.xslt"/>
    <xsl:import href="fo_inline.xslt"/>
    <xsl:import href="graphics.xslt"/>
    <xsl:import href="generic.xslt"/>
    <xsl:import href="numbering.xslt"/>
    <xsl:import href="localisation.xslt"/>
    <xsl:import href="fo_placeholders.xslt"/>
    <xsl:import href="waiver.xslt"/>
    <xsl:include href="functions_params_vars.xslt"/>
    <xsl:include href="styles_off.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

    <!-- numbered titles or not? -->
    <xsl:param name="NUMBERING" select="false()"/>

    <!-- ROOT -->
    <xsl:template match="/">
        <fo:root xsl:use-attribute-sets="root-common">
            <xsl:call-template name="layout-master-set"/>
            <xsl:call-template name="FrontMatter">
                <xsl:with-param name="execsummary" select="false()" tunnel="yes"/>
            </xsl:call-template>
            <xsl:call-template name="Content">
                <xsl:with-param name="execsummary" select="false()" tunnel="yes"/>
            </xsl:call-template>
        </fo:root>
    </xsl:template>


    <!-- OVERRIDES -->

    <!-- PAGE LAYOUT -->
    <xsl:template name="Content">
        <fo:page-sequence master-reference="Sections">
            <xsl:call-template name="page_header"/>
            <xsl:call-template name="page_footer"/>
            <xsl:call-template name="page_tab"/>
            <fo:flow flow-name="region-body" xsl:use-attribute-sets="DefaultFont">
                <fo:block>
                    <xsl:apply-templates select="offerte"/>
                </fo:block>
                <xsl:if test="not(following-sibling::*)">
                    <fo:block id="EndOfDoc">
                        <fo:footnote>
                            <fo:inline/>
                            <fo:footnote-body>
                                <xsl:call-template name="ImageAttribution"/>
                            </fo:footnote-body>
                        </fo:footnote>
                    </fo:block>
                </xsl:if>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <xsl:template name="page_tab"/>

    <!-- skip meta in quote; this is handled in FrontMatter -->
    <xsl:template match="meta"/>

    <!-- FRONT PAGE -->
    <xsl:template match="meta" mode="frontmatter">
        <xsl:param name="execsummary" tunnel="yes"/>
        <xsl:variable name="latestVersionNumber">
            <xsl:for-each select="version_history/version">
                <xsl:sort select="xs:dateTime(@date)" order="descending"/>
                <xsl:if test="position() = 1">
                    <xsl:call-template name="VersionNumber">
                        <xsl:with-param name="number" select="@number"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <fo:block xsl:use-attribute-sets="frontpagetext">
            <fo:block xsl:use-attribute-sets="frontlogo">
                <fo:external-graphic src="../graphics/logo_large.png" width="17cm"
                    content-height="scale-to-fit"/>
            </fo:block>
            <fo:footnote>
                <fo:inline/>
                <fo:footnote-body xsl:use-attribute-sets="front-titleblock-container">
                    <fo:block xsl:use-attribute-sets="front-titleblock">
                        <xsl:call-template name="front"/>
                    </fo:block>
                </fo:footnote-body>
            </fo:footnote>
        </fo:block>

        <fo:footnote>
            <fo:inline/>
            <fo:footnote-body>
                <xsl:call-template name="Contact"/>
            </fo:footnote-body>
        </fo:footnote>
    </xsl:template>

    <!-- CONTACT BOX (comes at the end, is just the address, no title/table) -->
    <xsl:template match="contact">
        <fo:block xsl:use-attribute-sets="Contact">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="contact/name">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="contact/phone">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="contact/email">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
</xsl:stylesheet>
