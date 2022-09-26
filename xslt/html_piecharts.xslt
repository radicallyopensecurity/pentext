<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:my="http://www.radical.sexy"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="piecharts.xslt"/>

    <xsl:variable name="pieTextStyle">
        <xsl:text>font-family: 'Open Sans'; font-size: 11pt; color:
                black;</xsl:text>
    </xsl:variable>

    <xsl:template name="output_piechart_with_legend">
        <xsl:param name="pieTable"/>
        <xsl:param name="pieHeight"/>
        <xsl:param name="pieTotal"/>
        <xsl:param name="no_entries"/>
        <xsl:param name="pieHeightHalf"/>
        <xsl:param name="x"/>
        <xsl:param name="pieAttr"/>
        <xsl:for-each select="$pieTable">
            <div class="row">
                <div class="five columns">
                    <xsl:call-template name="pie_svg">
                        <xsl:with-param name="pieHeight" select="$pieHeight"/>
                        <xsl:with-param name="pieTotal" select="$pieTotal"/>
                        <xsl:with-param name="no_entries" select="$no_entries"/>
                        <xsl:with-param name="pieHeightHalf" select="$pieHeightHalf"/>
                    </xsl:call-template>
                </div>
                <!-- PIE CHART LEGEND -->
                <div class="seven columns">
                    <xsl:for-each select="$pieTable/pieEntry">
                        <xsl:variable name="pieEntryLabelClean"
                            select="translate(pieEntryLabel, '/', '_')"/>
                        <xsl:variable name="pieEntryLabel">
                            <xsl:sequence
                                select="
                                    string-join(for $x in tokenize(pieEntryLabel, '_')
                                    return
                                        my:titleCase($x), ' ')"
                            />
                        </xsl:variable>
                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg" height="16" width="16">
                                <rect xmlns="http://www.w3.org/2000/svg" stroke="#706f6f"
                                    stroke-width="1" stroke-linejoin="round" height="16" width="16">
                                    <xsl:attribute name="fill">
                                        <xsl:call-template name="selectColor">
                                            <xsl:with-param name="position" select="position()"/>
                                            <xsl:with-param name="label" select="pieEntryLabel"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </rect>
                            </svg>
                            <span class="pieLegendText">
                                <xsl:value-of select="$pieEntryLabel"/>
                                <xsl:text> (</xsl:text>
                                <!-- for threatLevel legend, link to finding summary table -->
                                <xsl:choose>
                                    <xsl:when test="$pieAttr = 'threatLevel'">
                                        <a>
                                            <xsl:attribute name="href"
                                                  >#summaryTableThreatLevel<xsl:value-of
                                                  select="$pieEntryLabelClean"/></xsl:attribute>
                                            <xsl:value-of select="pieEntryCount"/>
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="pieEntryCount"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>)</xsl:text>
                            </span>
                        </div>
                    </xsl:for-each>
                </div>
            </div>


        </xsl:for-each>
    </xsl:template>


    <xsl:template name="pie_percentage_large_slice_style">
        <xsl:param name="text_angle"/>
        <xsl:param name="middle_x"/>
        <xsl:param name="text_line_x"/>
        <xsl:param name="percentage"/>
        <xsl:param name="part_half"/>
        <xsl:param name="middle_y"/>
        <xsl:param name="text_line_y"/>
        <text xmlns="http://www.w3.org/2000/svg">
            <xsl:attribute name="style"><xsl:value-of select="normalize-space($pieTextStyle)"/></xsl:attribute>
            <xsl:call-template name="pie_percentage_large_slice_content">
                <xsl:with-param name="text_angle" select="$text_angle"/>
                <xsl:with-param name="middle_x" select="$middle_x"/>
                <xsl:with-param name="text_line_x" select="$text_line_x"/>
                <xsl:with-param name="percentage" select="$percentage"/>
                <xsl:with-param name="part_half" select="$part_half"/>
                <xsl:with-param name="middle_y" select="$middle_y"/>
                <xsl:with-param name="text_line_y" select="$text_line_y"/>
            </xsl:call-template>
        </text>
    </xsl:template>



    <xsl:template name="pie_percentage_small_slice_style">
        <xsl:param name="text_x_relative_to_line"/>
        <xsl:param name="middle_y"/>
        <xsl:param name="text_line_y"/>
        <xsl:param name="percentage"/>
        <text xmlns="http://www.w3.org/2000/svg" text-anchor="end">
            <xsl:attribute name="style"><xsl:value-of select="normalize-space($pieTextStyle)"/></xsl:attribute>
            <xsl:call-template name="pie_percentage_small_slice_content">
                <xsl:with-param name="text_x_relative_to_line" select="$text_x_relative_to_line"/>
                <xsl:with-param name="middle_y" select="$middle_y"/>
                <xsl:with-param name="text_line_y" select="$text_line_y"/>
                <xsl:with-param name="percentage" select="$percentage"/>
            </xsl:call-template>
        </text>
    </xsl:template>
</xsl:stylesheet>
