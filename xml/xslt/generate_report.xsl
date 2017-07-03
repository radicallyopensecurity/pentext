<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="pages.xslt"/>
    <xsl:import href="meta.xslt"/>
    <xsl:import href="toc.xslt"/>
    <xsl:import href="structure.xslt"/>
    <xsl:import href="att-set.xslt"/>
    <xsl:import href="block.xslt"/>
    <xsl:import href="findings.xslt"/>
    <xsl:import href="auto.xslt"/>
    <xsl:import href="table.xslt"/>
    <xsl:import href="lists.xslt"/>
    <xsl:import href="inline.xslt"/>
    <xsl:import href="graphics.xslt"/>
    <xsl:import href="generic.xslt"/>
    <xsl:import href="numbering.xslt"/>
    <xsl:import href="localisation.xslt"/>
    <xsl:import href="placeholders.xslt"/>
    <!--
    <xsl:import href="snippets.xslt"/>-->

    <xsl:include href="styles_rep.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>


    <!-- ****** AUTO_NUMBERING_FORMAT:	value of the <xsl:number> element used for auto numbering -->
    <xsl:param name="AUTO_NUMBERING_FORMAT" select="'1.1.1'"/>
    <xsl:param name="EXEC_SUMMARY" select="false()"/>

    <xsl:key name="rosid" match="section | finding | appendix | non-finding" use="@id"/>
    <xsl:key name="biblioid" match="biblioentry" use="@id"/>

    <!-- not used but needed because of shared code with contract; todo: clean these up -->
    <xsl:variable name="fee" select="/contract/meta/contractor/hourly_fee * 1"/>
    <xsl:variable name="plannedHours" select="/contract/meta/work/planning/hours * 1"/>
    <xsl:variable name="total_fee" select="$fee * $plannedHours"/>
    <xsl:variable name="denomination" select="'X'"/>
    <!-- end -->

    <xsl:variable name="lang" select="/*/@xml:lang"/>

    <xsl:variable name="CLASSES" select="document('../xslt/styles_rep.xslt')/*/xsl:attribute-set"/>

    <xsl:variable name="latestVersionDate">
        <xsl:for-each select="/*/meta/version_history/version">
            <xsl:sort select="xs:dateTime(@date)" order="descending"/>
            <xsl:if test="position() = 1">
                <xsl:value-of select="format-dateTime(@date, '[MNn] [D1o], [Y]', 'en', (), ())"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <!-- ROOT -->
    <xsl:template match="/">

            <xsl:if test="$EXEC_SUMMARY = true()">
                <xsl:result-document href="../target/execsummary.fo">
                    <fo:root xsl:use-attribute-sets="root-common">

                        <xsl:call-template name="layout-master-set"/>
                        <xsl:call-template name="Content">
                            <xsl:with-param name="execsummary" select="true()" tunnel="yes"/>
                        </xsl:call-template>

                    </fo:root>
                </xsl:result-document>
            </xsl:if>
                <fo:root xsl:use-attribute-sets="root-common">

                    <xsl:call-template name="layout-master-set"/>
                    <xsl:call-template name="Content">
                        <xsl:with-param name="execsummary" select="false()" tunnel="yes"/>
                    </xsl:call-template>

                </fo:root>
            
        
    </xsl:template>


</xsl:stylesheet>
