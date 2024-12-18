<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:my="http://www.radical.sexy"
  exclude-result-prefixes="xs my"
  version="2.0"
>
    
    <xsl:import href="piecharts.xslt" />
    
    <xsl:template name="output_piechart_with_legend">
        <xsl:param name="pieTable" />
        <xsl:param name="pieHeight" />
        <xsl:param name="pieTotal" />
        <xsl:param name="no_entries" />
        <xsl:param name="pieHeightHalf" />
        <xsl:param name="x" />
        <xsl:param name="pieAttr" />
        <xsl:for-each select="$pieTable">
            <fo:block xsl:use-attribute-sets="p">
                <fo:table margin-top="15px" xsl:use-attribute-sets="fwtable">
                    <!-- need some margin to make space for percentages that can't fit in the pie... -->
                    <fo:table-column column-width="{$pieHeight + 85}px" />
                    <fo:table-column
            column-width="proportional-column-width(1)"
          />
                    <fo:table-body>
                        <fo:table-row keep-together.within-column="always">
                            <fo:table-cell
                xsl:use-attribute-sets="td indent_reset"
              >
                                <fo:block>
                                    <fo:instream-foreign-object
                    xmlns:svg="http://www.w3.org/2000/svg"
                  >
                                        <!--set the display-->
                                        <xsl:call-template name="pie_svg">
                                            <xsl:with-param
                        name="pieHeight"
                        select="$pieHeight"
                      />
                                            <xsl:with-param
                        name="pieTotal"
                        select="$pieTotal"
                      />
                                            <xsl:with-param
                        name="no_entries"
                        select="$no_entries"
                      />
                                            <xsl:with-param
                        name="pieHeightHalf"
                        select="$pieHeightHalf"
                      />
                                        </xsl:call-template>
                                    </fo:instream-foreign-object>
                                </fo:block>
                            </fo:table-cell>
                            <!-- PIE CHART LEGEND -->
                            <fo:table-cell>
                                <fo:block>
                                    <fo:table
                    xsl:use-attribute-sets="pieLegendTable fwtable"
                  >
                                        <fo:table-column column-width="22px" />
                                        <fo:table-column
                      column-width="proportional-column-width(1)"
                    />
                                        <fo:table-body>
                                            <xsl:for-each
                        select="$pieTable/pieEntry"
                      >
                                                <xsl:variable
                          name="pieEntryLabelClean"
                          select="translate(pieEntryLabel, '/', '_')"
                        />
                                                <xsl:variable
                          name="pieEntryLabel"
                        >
                                                  <xsl:sequence
                            select="
                                                            string-join(for $x in tokenize(pieEntryLabel, '_')
                                                            return
                                                               $x, ' ')"
                          />
                                                </xsl:variable>
                                                <fo:table-row>
                                                  <fo:table-cell
                            xsl:use-attribute-sets="pieLegendTableCell"
                          >
                                                  <fo:block>
                                                  <fo:instream-foreign-object>
                                                  <svg:svg
                                  height="13"
                                  width="13"
                                >
                                                  <svg:rect
                                    stroke="#706f6f"
                                    stroke-width="1"
                                    stroke-linejoin="round"
                                    height="11"
                                    width="11"
                                  >
                                                  <xsl:attribute name="fill">
                                                  <xsl:call-template
                                        name="selectColor"
                                      >
                                                  <xsl:with-param
                                          name="position"
                                          select="position()"
                                        />
                                                  <xsl:with-param
                                          name="label"
                                          select="pieEntryLabel"
                                        />
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                  </svg:rect>
                                                  </svg:svg>
                                                  </fo:instream-foreign-object>
                                                  </fo:block>
                                                  </fo:table-cell>
                                                  <fo:table-cell
                            xsl:use-attribute-sets="pieLegendTableCell"
                          >
                                                  <fo:block>
                                                  <xsl:value-of
                                select="$pieEntryLabel"
                              />
                                                  <xsl:text> (</xsl:text>
                                                  <!-- for threatLevel legend, link to finding summary table -->
                                                  <xsl:choose>
                                                  <xsl:when
                                  test="$pieAttr = 'threatLevel'"
                                >
                                                  <fo:basic-link
                                    xsl:use-attribute-sets="link"
                                  >
                                                  <xsl:attribute
                                      name="internal-destination"
                                    >summaryTableThreatLevel<xsl:value-of
                                        select="$pieEntryLabelClean"
                                      /></xsl:attribute>
                                                  <xsl:value-of
                                      select="pieEntryCount"
                                    />
                                                  </fo:basic-link>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                    select="pieEntryCount"
                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <xsl:text>)</xsl:text>
                                                  </fo:block>
                                                  </fo:table-cell>
                                                </fo:table-row>
                                            </xsl:for-each>
                                        </fo:table-body>
                                    </fo:table>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>

            </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template name="pie_percentage_large_slice_style">
        <xsl:param name="text_angle" />
        <xsl:param name="middle_x" />
        <xsl:param name="text_line_x" />
        <xsl:param name="percentage" />
        <xsl:param name="part_half" />
        <xsl:param name="middle_y" />
        <xsl:param name="text_line_y" />
        <svg:text xsl:use-attribute-sets="PieFont">
            <xsl:call-template name="pie_percentage_large_slice_content">
                <xsl:with-param name="text_angle" select="$text_angle" />
                <xsl:with-param name="middle_x" select="$middle_x" />
                <xsl:with-param name="text_line_x" select="$text_line_x" />
                <xsl:with-param name="percentage" select="$percentage" />
                <xsl:with-param name="part_half" select="$part_half" />
                <xsl:with-param name="middle_y" select="$middle_y" />
                <xsl:with-param name="text_line_y" select="$text_line_y" />
            </xsl:call-template>
        </svg:text>
    </xsl:template>
    
    
    
    <xsl:template name="pie_percentage_small_slice_style">
        <xsl:param name="text_x_relative_to_line" />
        <xsl:param name="middle_y" />
        <xsl:param name="text_line_y" />
        <xsl:param name="percentage" />
        <svg:text text-anchor="end" xsl:use-attribute-sets="PieFont">
            <xsl:call-template name="pie_percentage_small_slice_content">
                <xsl:with-param
          name="text_x_relative_to_line"
          select="$text_x_relative_to_line"
        />
                <xsl:with-param name="middle_y" select="$middle_y" />
                <xsl:with-param name="text_line_y" select="$text_line_y" />
                <xsl:with-param name="percentage" select="$percentage" />
            </xsl:call-template>
        </svg:text>
    </xsl:template>
</xsl:stylesheet>
