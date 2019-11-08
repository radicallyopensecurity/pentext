<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:my="http://www.radical.sexy" exclude-result-prefixes="xs math" version="2.0">


    <!-- Note: any svg here should be output as <svg xmlns:svg="http://www.w3.org/2000/svg"> rather than <svg:svg> to make the result readable both by xsl-fo parsers and html5 parsers (fop and browsers, specifically ;) -->

    <xsl:template match="generate_piechart">
        <xsl:choose>
            <xsl:when test="//finding">
                <!-- only generate pie chart if there are findings in the report - otherwise we get into trouble with empty percentages and divisions by zero -->
                <xsl:call-template name="do_generate_piechart">
                    <xsl:with-param name="pieAttr" select="@pieAttr"/>
                    <xsl:with-param name="pieElem" select="@pieElem"/>
                    <xsl:with-param name="status" select="@status"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string">Pie chart can only be generated when there are
                        findings in the report. Get to work! ;)</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="do_generate_piechart">
        <!-- Get the numbers -->
        <!-- generate_piechart @type="type" or "threatLevel" -->
        <xsl:param name="pieAttr" select="@pieAttr"/>
        <xsl:param name="pieElem" select="@pieElem"/>
        <xsl:param name="pieHeight" as="xs:integer" select="200"/>
        <xsl:param name="status" select="@status"/>
        <xsl:variable name="statusSequence" as="item()*">
            <xsl:for-each select="$status">
                <xsl:for-each select="tokenize(., ' ')">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="pieTotal">
            <xsl:choose>
                <xsl:when test="not(@status)">
                    <xsl:value-of select="count(//*[local-name() = $pieElem])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="count(//*[local-name() = $pieElem][@status = $statusSequence])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Create generic nodeset with values -->
        <xsl:variable name="unsortedPieTable">
            <xsl:choose>
                <xsl:when test="not(@status)">
                    <xsl:for-each-group select="//*[local-name() = $pieElem]"
                        group-by="@*[name() = $pieAttr]">
                        <pieEntry>
                            <pieEntryLabel>
                                <xsl:value-of select="current-grouping-key()"/>
                            </pieEntryLabel>
                            <pieEntryCount>
                                <xsl:value-of
                                    select="count(//*[local-name() = $pieElem][@*[name() = $pieAttr]][@* = current-grouping-key()])"
                                />
                            </pieEntryCount>
                        </pieEntry>
                    </xsl:for-each-group>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each-group
                        select="//*[local-name() = $pieElem][@status = $statusSequence]"
                        group-by="@*[name() = $pieAttr]">
                        <pieEntry>
                            <pieEntryLabel>
                                <xsl:value-of select="current-grouping-key()"/>
                            </pieEntryLabel>
                            <pieEntryCount>
                                <xsl:value-of
                                    select="count(//*[local-name() = $pieElem][@*[name() = $pieAttr]][@status = $statusSequence][@* = current-grouping-key()])"
                                />
                            </pieEntryCount>
                        </pieEntry>
                    </xsl:for-each-group>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pieHeightHalf" as="xs:double" select="$pieHeight div 2"/>
        <!-- Now we need to sort that pieTable - custom order for threat levels, 'count' descending order for all other types -->
        <xsl:variable name="sortedPieTable">
            <xsl:choose>
                <xsl:when test="$pieElem = 'finding' and $pieAttr = 'threatLevel'">
                    <xsl:for-each select="$unsortedPieTable/pieEntry">
                        <xsl:sort data-type="number" order="descending"
                            select="
                                (number(pieEntryLabel = 'Extreme') * 10)
                                + (number(pieEntryLabel = 'High') * 9)
                                + (number(pieEntryLabel = 'Elevated') * 8)
                                + (number(pieEntryLabel = 'Moderate') * 7)
                                + (number(pieEntryLabel = 'Low') * 6)
                                + (number(pieEntryLabel = 'Unknown') * 3)
                                + (number(pieEntryLabel = 'N/A') * 1)"/>
                        <pieEntry>
                            <pieEntryLabel>
                                <xsl:value-of select="pieEntryLabel"/>
                            </pieEntryLabel>
                            <pieEntryCount>
                                <xsl:value-of select="pieEntryCount"/>
                            </pieEntryCount>
                        </pieEntry>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$pieElem = 'finding' and $pieAttr = 'status'">
                    <xsl:for-each select="$unsortedPieTable/pieEntry">
                        <xsl:sort data-type="number" order="descending"
                            select="
                                (number(pieEntryLabel = 'new') * 10)
                                + (number(pieEntryLabel = 'unresolved') * 9)
                                + (number(pieEntryLabel = 'not_retested') * 8)
                                + (number(pieEntryLabel = 'resolved') * 7)"/>
                        <pieEntry>
                            <pieEntryLabel>
                                <xsl:value-of select="pieEntryLabel"/>
                            </pieEntryLabel>
                            <pieEntryCount>
                                <xsl:value-of select="pieEntryCount"/>
                            </pieEntryCount>
                        </pieEntry>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="$unsortedPieTable/pieEntry">
                        <xsl:sort data-type="number" order="descending" select="pieEntryCount"/>
                        <pieEntry>
                            <pieEntryLabel>
                                <xsl:value-of select="pieEntryLabel"/>
                            </pieEntryLabel>
                            <pieEntryCount>
                                <xsl:value-of select="pieEntryCount"/>
                            </pieEntryCount>
                        </pieEntry>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="threshold" as="xs:integer">
            <!-- threshold is usually 2 (everything below it gets thrown in 'other' bin if they get too numerous)
            sometimes it's three if the 2-type slices also get too numerous and take up too much space -->
            <xsl:choose>
                <!--  -->
                <xsl:when
                    test="(count($sortedPieTable/pieEntry) > 16) and (count($sortedPieTable/pieEntry/pieEntryCount[. = 2]) &gt; 5) and ((1 div $pieTotal * 100) &lt; 2.5) and (sum($sortedPieTable/pieEntry/pieEntryCount[. &lt; 3]) div $pieTotal * 100 &lt; 50)"
                    >3</xsl:when>
                <xsl:otherwise>2</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sumBelowThreshold">
            <xsl:value-of select="sum($sortedPieTable/pieEntry/pieEntryCount[. &lt; $threshold])"/>
        </xsl:variable>
        <xsl:variable name="pieTable">
            <xsl:choose>
                <xsl:when
                    test="(not($pieAttr = 'threatLevel') and $sumBelowThreshold > 4 and (1 div $pieTotal * 100) &lt; 5 and ($sumBelowThreshold div $pieTotal * 100) &lt; 50) or (not($pieAttr = 'threatLevel') and count($sortedPieTable/pieEntry) > 16)">
                    <!-- Group below-threshold pie slices into 'Other' if: 
                    - there are more than 4 single-type slices and 
                    - they are small percentages (i.e. 1 single-type slice is less than 5%) and
                    - they take up less than 50% of the chart 
                (otherwise just print them out) -->
                    <xsl:for-each
                        select="$sortedPieTable/pieEntry[child::pieEntryCount &gt;= $threshold]">
                        <pieEntry>
                            <pieEntryLabel>
                                <xsl:value-of select="pieEntryLabel"/>
                            </pieEntryLabel>
                            <pieEntryCount>
                                <xsl:value-of select="pieEntryCount"/>
                            </pieEntryCount>
                        </pieEntry>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$sortedPieTable" copy-namespaces="no"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if
                test="(not($pieAttr = 'threatLevel') and $sumBelowThreshold > 4 and (1 div $pieTotal * 100) &lt; 5 and ($sumBelowThreshold div $pieTotal * 100) &lt; 50) or (not($pieAttr = 'threatLevel') and count($sortedPieTable/pieEntry) > 16)">
                <pieEntry>
                    <pieEntryLabel>
                        <xsl:text>Other</xsl:text>
                    </pieEntryLabel>
                    <pieEntryCount>
                        <xsl:value-of select="$sumBelowThreshold"/>
                    </pieEntryCount>
                </pieEntry>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="no_entries" select="count($pieTable/pieEntry)"/>
        <xsl:if
            test="($pieAttr = 'type' and //finding[not(@type)]) or ($pieAttr = 'type' and //finding[@type = ''])">
            <xsl:call-template name="displayErrorText">
                <xsl:with-param name="string"> WARNING: Piechart may look weird - the following
                    findings are missing a type attribute:<xsl:for-each
                        select="//finding[@type = ''] | //finding[not(@type)]"> [<xsl:value-of
                            select="@id"/>] </xsl:for-each>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="output_piechart_with_legend">
            <xsl:with-param name="pieTable" select="$pieTable"/>
            <xsl:with-param name="pieHeight" select="$pieHeight"/>
            <xsl:with-param name="pieTotal" select="$pieTotal"/>
            <xsl:with-param name="no_entries" select="$no_entries"/>
            <xsl:with-param name="pieHeightHalf" select="$pieHeightHalf"/>
            <xsl:with-param name="pieAttr" select="$pieAttr"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="pie_svg">
        <xsl:param name="pieHeight"/>
        <xsl:param name="pieTotal"/>
        <xsl:param name="no_entries"/>
        <xsl:param name="pieHeightHalf"/>
        <svg xmlns="http://www.w3.org/2000/svg" width="300" height="225" viewBox="-40 -20 300 250">
            <!-- The bit below tried to configure the piechart size but basically nobody ever changes it and it just makes it all way too difficult -->
            <!-- width and height of the viewport -->
            <!--<xsl:attribute name="width">
                <xsl:value-of select="$pieHeight + $spacing_for_percentage_labels * 2"/>
            </xsl:attribute>
            <xsl:attribute name="height">
                <xsl:value-of select="$pieHeight + $spacing_for_percentage_labels * 2"/>
            </xsl:attribute>
            <!-\- viewBox to scale -\->
            <xsl:attribute name="viewBox">
                <!-\- start viewbox 15px to the left and make it 15px larger to catch svg's cutoff text -\->
                <xsl:value-of select="concat(-$spacing_for_percentage_labels, ' 0 ', $pieHeight + $spacing_for_percentage_labels * 2, ' ', $pieHeight + ($spacing_for_percentage_labels * 3))"
                />
            </xsl:attribute>-->
            <!--call the template starting at the last slice-->
            <xsl:call-template name="pie_chart_slice">
                <xsl:with-param name="pieTotal" select="$pieTotal"/>
                <xsl:with-param name="no_entries" select="$no_entries"/>
                <xsl:with-param name="position" select="$no_entries"/>
                <xsl:with-param name="middle_x" select="$pieHeightHalf"/>
                <xsl:with-param name="middle_y" select="$pieHeightHalf"/>
                <xsl:with-param name="move_x" select="0"/>
                <xsl:with-param name="radius" select="$pieHeightHalf div 100 * 85"/>
            </xsl:call-template>
        </svg>
    </xsl:template>


    <xsl:template name="pie_chart_slice">
        <xsl:param name="pieTotal"/>
        <xsl:param name="position"/>
        <xsl:param name="no_entries"/>
        <xsl:param name="middle_x"/>
        <xsl:param name="middle_y"/>
        <xsl:param name="move_x"/>
        <xsl:param name="radius"/>
        <!--prepare the middle part of the arc command-->
        <xsl:variable name="middle" select="concat('M', ' ', $middle_x, ',', $middle_y)"/>
        <xsl:variable name="part" as="xs:double"
            select="sum(//pieEntry[position() &lt;= $position]/pieEntryCount)"/>
        <!-- sum of pieEntryCounts up to this point -->
        <xsl:variable name="angle" select="($part div $pieTotal) * 360"/>
        <xsl:variable name="x" select="math:sin(3.1415292 * $angle div 180.0) * $radius"/>
        <xsl:variable name="y" select="math:cos(3.1415292 * $angle div 180.0) * $radius"/>
        <xsl:variable name="move_y" select="-$radius"/>
        <xsl:variable name="first_line" select="concat('l', ' ', $move_x, ',', $move_y)"/>
        <xsl:variable name="arc_move1" select="'0'"/>
        <xsl:variable name="arc_move2">
            <xsl:choose>
                <!--check the direction of the arc: inward or outward-->
                <xsl:when test="$angle &lt;= 180">0</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="arc_move3" select="'1'"/>
        <xsl:variable name="arc_move" select="concat($arc_move1, ' ', $arc_move2, ',', $arc_move3)"/>
        <xsl:variable name="d"
            select="concat($middle, ' ', $first_line, ' ', 'a ', $radius, ',', $radius, ' ', $arc_move, ' ', $x, ',', $radius - $y, ' ', 'z')"/>
        <!--put it all together-->
        <path xmlns="http://www.w3.org/2000/svg" stroke="white" stroke-width="1"
            stroke-linejoin="round">
            <xsl:attribute name="fill">
                <xsl:call-template name="selectColor">
                    <xsl:with-param name="position" select="$position"/>
                    <xsl:with-param name="label"
                        select="//pieEntry[position() = $position]/pieEntryLabel"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="d">
                <xsl:value-of select="$d"/>
            </xsl:attribute>
        </path>
        <!--now the percentage-->
        <xsl:variable name="percentage" as="xs:double"
            select="(//pieEntry[position() = $position]/pieEntryCount div sum(//pieEntry/pieEntryCount)) * 100"/>
        <xsl:variable name="part_half" as="xs:double"
            select="(//pieEntry[position() = $position]/pieEntryCount div sum(//pieEntry/pieEntryCount)) div 2 * 360"/>
        <xsl:variable name="text_angle" as="xs:double" select="$angle - $part_half"/>
        <xsl:variable name="text_x"
            select="math:sin(3.1415292 * (($angle - $part_half) div 180.0)) * ($radius * 0.8)"/>
        <xsl:variable name="text_y"
            select="math:cos(3.1415292 * (($angle - $part_half) div 180.0)) * ($radius * 0.8)"/>
        <xsl:variable name="text_line_x"
            select="math:sin(3.1415292 * (($angle - $part_half) div 180.0)) * ($radius * 1.15)"/>
        <xsl:variable name="text_line_y"
            select="math:cos(3.1415292 * (($angle - $part_half) div 180.0)) * ($radius * 1.15)"/>
        <!--we either put it on the edge of the pie directly or have a line pointing into the slice, depending on how thick the slice is-->
        <xsl:choose>
            <xsl:when test="$percentage >= 3.5">
                <!--on the edge-->
                <xsl:call-template name="pie_percentage_large_slice_style">
                    <xsl:with-param name="text_angle" select="$text_angle"/>
                    <xsl:with-param name="middle_x" select="$middle_x"/>
                    <xsl:with-param name="text_line_x" select="$text_line_x"/>
                    <xsl:with-param name="percentage" select="$percentage"/>
                    <xsl:with-param name="part_half" select="$part_half"/>
                    <xsl:with-param name="middle_y" select="$middle_y"/>
                    <xsl:with-param name="text_line_y" select="$text_line_y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!--extra line pointing into the slice-->
                <xsl:variable name="line_dir">
                    <xsl:choose>
                        <!--when in the first half of the pie, have the line point to the right, otherwise to the left -->
                        <xsl:when test="$angle &lt;= 180">+10</xsl:when>
                        <xsl:otherwise>-10</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="text_x_relative_to_line">
                    <xsl:choose>
                        <!--when in the first half of the pie, have the text be on the right of the line, otherwise on the left -->
                        <xsl:when test="$angle &lt;= 180">
                            <xsl:value-of select="$middle_x + $text_line_x + $line_dir * 2 + 11"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$middle_x + $text_line_x - 11"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <path xmlns="http://www.w3.org/2000/svg" stroke="black" stroke-width="1"
                    stroke-linejoin="round">
                    <xsl:attribute name="fill">none</xsl:attribute>
                    <xsl:attribute name="d">
                        <xsl:value-of
                            select="concat('M', ' ', $middle_x + $text_x, ',', $middle_y - $text_y, ' ', 'L', ' ', $middle_x + $text_line_x, ',', $middle_y - $text_line_y, ' ', 'H', ' ', $middle_x + $text_line_x + $line_dir)"
                        />
                    </xsl:attribute>
                </path>
                <xsl:call-template name="pie_percentage_small_slice_style">
                    <xsl:with-param name="text_x_relative_to_line" select="$text_x_relative_to_line"/>
                    <xsl:with-param name="middle_y" select="$middle_y"/>
                    <xsl:with-param name="text_line_y" select="$text_line_y"/>
                    <xsl:with-param name="percentage" select="$percentage"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <!--loop until we reach the first part-->
        <xsl:if test="$position > 1">
            <xsl:call-template name="pie_chart_slice">
                <xsl:with-param name="pieTotal" select="$pieTotal"/>
                <xsl:with-param name="position" select="$position - 1"/>
                <xsl:with-param name="no_entries" select="$no_entries"/>
                <xsl:with-param name="middle_x" select="$middle_x"/>
                <xsl:with-param name="middle_y" select="$middle_y"/>
                <xsl:with-param name="move_x" select="$move_x"/>
                <xsl:with-param name="radius" select="$radius"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="pie_percentage_small_slice_content">
        <xsl:param name="text_x_relative_to_line"/>
        <xsl:param name="middle_y"/>
        <xsl:param name="text_line_y"/>
        <xsl:param name="percentage"/>
        <xsl:attribute name="x">
            <!-- placement of text depends on where extra line is pointing -->
            <xsl:value-of select="$text_x_relative_to_line"/>
        </xsl:attribute>
        <xsl:attribute name="y">
            <xsl:value-of select="$middle_y - $text_line_y + 1"/>
        </xsl:attribute>
        <xsl:value-of select="format-number($percentage, '##,##0.0')"/>
        <xsl:text>%</xsl:text>
    </xsl:template>

    <xsl:template name="pie_percentage_large_slice_content">
        <xsl:param name="text_angle"/>
        <xsl:param name="middle_x"/>
        <xsl:param name="text_line_x"/>
        <xsl:param name="percentage"/>
        <xsl:param name="part_half"/>
        <xsl:param name="middle_y"/>
        <xsl:param name="text_line_y"/>
        <xsl:attribute name="x">
            <xsl:choose>
                <!-- try for some better placement of percentages than the standard -->
                <xsl:when test="$text_angle &lt;= 22.5">
                    <xsl:value-of select="$middle_x + $text_line_x"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 45 and $text_angle &gt; 22.5">
                    <xsl:value-of select="$middle_x + $text_line_x"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 67.5 and $text_angle &gt; 45">
                    <xsl:value-of select="$middle_x + $text_line_x - 8"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 85 and $text_angle &gt; 67.5">
                    <xsl:value-of select="$middle_x + $text_line_x - 8"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 95 and $text_angle &gt; 85">
                    <xsl:value-of select="$middle_x + $text_line_x - 8"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 112.5 and $text_angle &gt; 95">
                    <xsl:value-of select="$middle_x + $text_line_x - 8"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 135 and $text_angle &gt; 112.5">
                    <xsl:value-of select="$middle_x + $text_line_x - 8"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 157.5 and $text_angle &gt; 135">
                    <xsl:value-of select="$middle_x + $text_line_x"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 180 and $text_angle &gt; 157.5">
                    <xsl:value-of select="$middle_x + $text_line_x"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 202.5 and $text_angle &gt; 180">
                    <xsl:value-of select="$middle_x + $text_line_x"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 225 and $text_angle &gt; 202.5">
                    <xsl:value-of select="$middle_x + $text_line_x"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 247.5 and $text_angle &gt; 225">
                    <xsl:value-of select="$middle_x + $text_line_x + 8"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 265 and $text_angle &gt; 247.5">
                    <xsl:value-of select="$middle_x + $text_line_x + 8"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 275 and $text_angle &gt; 265">
                    <xsl:value-of select="$middle_x + $text_line_x + 8"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 292.5 and $text_angle &gt; 275">
                    <xsl:value-of select="$middle_x + $text_line_x + 8"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 315 and $text_angle &gt; 292.5">
                    <xsl:value-of select="$middle_x + $text_line_x + 6"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 337.5 and $text_angle &gt; 315">
                    <xsl:value-of select="$middle_x + $text_line_x"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 360 and $text_angle &gt; 337.5">
                    <xsl:value-of select="$middle_x + $text_line_x"/>
                    <xsl:call-template name="piechartdebug">
                        <xsl:with-param name="text_angle" select="$text_angle"/>
                        <xsl:with-param name="percentage" select="$percentage"/>
                        <xsl:with-param name="part_half" select="$part_half"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$middle_x + $text_line_x"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="y">
            <xsl:choose>
                <!-- when in top right/bottom left quarters of circle, bring percentage text a bit closer to the circle -->
                <xsl:when test="$text_angle &lt;= 22.5">
                    <xsl:value-of select="$middle_y - $text_line_y + 5"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 45 and $text_angle &gt; 22.5">
                    <xsl:value-of select="$middle_y - $text_line_y + 4"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 67.5 and $text_angle &gt; 45">
                    <xsl:value-of select="$middle_y - $text_line_y + 3"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 90 and $text_angle &gt; 67.5">
                    <xsl:value-of select="$middle_y - $text_line_y + 2"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 112.5 and $text_angle &gt; 90">
                    <xsl:value-of select="$middle_y - $text_line_y + 1"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 135 and $text_angle &gt; 112.5">
                    <xsl:value-of select="$middle_y - $text_line_y - 1"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 157.5 and $text_angle &gt; 135">
                    <xsl:value-of select="$middle_y - $text_line_y + 1"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 180 and $text_angle &gt; 157.5">
                    <xsl:value-of select="$middle_y - $text_line_y - 0"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 202.5 and $text_angle &gt; 180">
                    <xsl:value-of select="$middle_y - $text_line_y - 0"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 225 and $text_angle &gt; 202.5">
                    <xsl:value-of select="$middle_y - $text_line_y + 1"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 247.5 and $text_angle &gt; 225">
                    <xsl:value-of select="$middle_y - $text_line_y - 1"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 270 and $text_angle &gt; 247.5">
                    <xsl:value-of select="$middle_y - $text_line_y + 1"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 292.5 and $text_angle &gt; 270">
                    <xsl:value-of select="$middle_y - $text_line_y + 2"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 315 and $text_angle &gt; 292.5">
                    <xsl:value-of select="$middle_y - $text_line_y + 3"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 337.5 and $text_angle &gt; 315">
                    <xsl:value-of select="$middle_y - $text_line_y + 4"/>
                </xsl:when>
                <xsl:when test="$text_angle &lt;= 360 and $text_angle &gt; 337.5">
                    <xsl:value-of select="$middle_y - $text_line_y + 5"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$middle_y - $text_line_y"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="text-anchor">
            <xsl:choose>
                <!-- when in top/bottom quarters of circle, text is anchored in the middle, when left on end, when right on start -->
                <xsl:when
                    test="($text_angle &gt;= 315 or $text_angle &lt;= 45) or ($text_angle &lt;= 225 and $text_angle &gt;= 135)"
                    >middle</xsl:when>
                <xsl:when test="$text_angle &lt; 135 and $text_angle &gt; 45">start</xsl:when>
                <xsl:when test="$text_angle &lt; 315 and $text_angle &gt; 225">end</xsl:when>
                <xsl:otherwise>middle</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="format-number($percentage, '##,##0.0')"/>
        <xsl:text>%</xsl:text>
    </xsl:template>

    <xsl:template name="piechartdebug">
        <xsl:param name="text_angle"/>
        <xsl:param name="part_half"/>
        <xsl:param name="percentage"/>
        <!--<xsl:message>PERCENTAGE: <xsl:value-of select="$percentage"/></xsl:message>
        <xsl:message>TEXT ANGLE: <xsl:value-of select="$text_angle"/></xsl:message>-->
    </xsl:template>


</xsl:stylesheet>
