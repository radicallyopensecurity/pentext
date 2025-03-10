<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:template match="generate_targets">
        <xsl:call-template name="targets"/>
    </xsl:template>

    <xsl:template name="targets">
        <xsl:param name="Ref" select="@Ref"/>
        <fo:list-block xsl:use-attribute-sets="list">
            <xsl:for-each
                select="/*/meta/targets/target[@Ref = $Ref] | /*/meta/targets/target[not(@Ref)]">
                <fo:list-item xsl:use-attribute-sets="li">
                    <!-- insert a bullet -->
                    <fo:list-item-label end-indent="label-end()">
                        <fo:block>
                            <fo:inline>&#8226;</fo:inline>
                        </fo:block>
                    </fo:list-item-label>
                    <!-- list text -->
                    <fo:list-item-body start-indent="body-start()">
                        <fo:block>
                            <xsl:apply-templates/>
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:for-each>
        </fo:list-block>
    </xsl:template>

    <xsl:template match="generate_teammembers">
        <xsl:call-template name="teammembers"/>
    </xsl:template>

    <xsl:template name="teammembers">
        <fo:list-block xsl:use-attribute-sets="list" provisional-distance-between-starts="0.75cm"
            provisional-label-separation="2.5mm" space-after="12pt" start-indent="1cm">
            <xsl:for-each select="//activityinfo//team/member">
                <fo:list-item>
                    <!-- insert a bullet -->
                    <fo:list-item-label end-indent="label-end()">
                        <fo:block>
                            <fo:inline>&#8226;</fo:inline>
                        </fo:block>
                    </fo:list-item-label>
                    <!-- list text -->
                    <fo:list-item-body start-indent="body-start()">
                        <fo:block>
                            <fo:inline xsl:use-attribute-sets="bold"><xsl:apply-templates
                                    select="name"/>: </fo:inline>
                            <xsl:apply-templates select="expertise"/>
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:for-each>
        </fo:list-block>
    </xsl:template>

    <xsl:template match="generate_findings">
        <xsl:variable name="match-labels" select="@match-labels"/>
        <xsl:variable name="Ref" select="@Ref"/>
        <xsl:variable name="statusSequence" as="item()*">
            <xsl:for-each select="@status">
                <xsl:for-each select="tokenize(., ' ')">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <fo:block>
            <fo:table xsl:use-attribute-sets="fwtable table borders">
                <xsl:call-template name="checkIfLast"/>
                <fo:table-column column-width="proportional-column-width(16)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(50)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <fo:table-row keep-with-next.within-column="always">
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Info</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Description</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:choose>
                        <xsl:when test="@status and @Ref">
                            <!-- Only generate a table for findings in the section with this status AND this Ref -->
                            <xsl:for-each
                                select="$findingSummaryTable/findingEntry[@status = $statusSequence][ancestor::*[@id = $Ref]]">
                                <xsl:call-template name="findingsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@status and not(@Ref)">
                            <!-- Only generate a table for findings in the section with this status -->
                            <xsl:for-each
                                select="$findingSummaryTable/findingEntry[@status = $statusSequence]">
                                <xsl:call-template name="findingsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@Ref and not(@status)">
                            <!-- Only generate a table for findings in the section with this Ref -->
                            <xsl:for-each
                                select="$findingSummaryTable/findingEntry[ancestor::*[@id = $Ref]]">
                                <xsl:call-template name="findingsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="$findingSummaryTable/findingEntry[matches(concat('//', string-join(findingLabel, '//')), concat('//', $match-labels))]">
                                <xsl:call-template name="findingsSummaryContent" />
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template name="findingsSummaryContent">
        <fo:table-row xsl:use-attribute-sets="TableFont" keep-together.within-column="always">
            <xsl:if test="position() mod 2 != 0">
                <xsl:attribute name="background-color">#ededed</xsl:attribute>
            </xsl:if>
            
            <!-- First Table Cell -->
            <fo:table-cell xsl:use-attribute-sets="td">
               <fo:block>
                    <fo:inline>
                        <!-- attach id to first finding so internal links can point to it -->
                        <xsl:if test="@id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="@id"/>
                            </xsl:attribute>
                        </xsl:if>
                        <fo:basic-link xsl:use-attribute-sets="link">
                            <xsl:attribute name="internal-destination">
                                <xsl:value-of select="@findingId"/>
                            </xsl:attribute>
                            <xsl:value-of select="findingNumber"/>
                        </fo:basic-link>
                    </fo:inline>
                </fo:block>

                <fo:block>
                    <fo:inline xsl:use-attribute-sets="bold">
                        <xsl:value-of select="findingThreatLevel"/>
                    </fo:inline>
                </fo:block>
                <fo:block>
                    <fo:inline xsl:use-attribute-sets="bold">Type: </fo:inline>
                    <xsl:value-of select="findingType"/>
                </fo:block>
   
                <!-- Status Section -->
                <xsl:if test="@status">
                    <fo:block>
                        <fo:inline xsl:use-attribute-sets="bold">Status: </fo:inline>
                        <xsl:choose>
                            <xsl:when test="@status = 'new' or @status = 'unresolved'">
                                <fo:inline>
                                    <xsl:attribute name="color">
                                        <xsl:value-of select="$color_new"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@status"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:when test="@status = 'not_retested'">
                                <fo:inline>
                                    <xsl:attribute name="color">
                                        <xsl:value-of select="$color_notretested"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@status"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:when test="@status = 'resolved'">
                                <fo:inline>
                                    <xsl:attribute name="color">
                                        <xsl:value-of select="$color_resolved"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@status"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:otherwise>
                                <fo:inline>
                                    <xsl:value-of select="@status"/>
                                </fo:inline>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                </xsl:if>

                <!-- Labels Section -->
                <fo:block>
                    <fo:block xsl:use-attribute-sets="labels p">
                        <xsl:for-each select="findingLabel">
                            <fo:inline xsl:use-attribute-sets="label">
                                <xsl:attribute name="background-color">
                                    <xsl:value-of select="@color"/>
                                </xsl:attribute>
                                <xsl:attribute name="color">
                                    <xsl:value-of select="@text"/>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </fo:inline>
                            <xsl:text> </xsl:text>
                        </xsl:for-each>
                    </fo:block>
                </fo:block>
            </fo:table-cell>

            <!-- Second Table Cell -->
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block xsl:use-attribute-sets="p">
                    <xsl:value-of select="findingDescription"/>
                </fo:block>
                <xsl:if test="findingImpact">
                    <fo:block xsl:use-attribute-sets="p">
                        <fo:inline xsl:use-attribute-sets="bold">Impact:</fo:inline>
                        <xsl:value-of select="findingImpact"/>
                    </fo:block>
                </xsl:if>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="generate_recommendations">
        <xsl:variable name="Ref" select="@Ref"/>
        <xsl:variable name="statusSequence" as="item()*">
            <xsl:for-each select="@status">
                <xsl:for-each select="tokenize(., ' ')">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <fo:block>
            <fo:table xsl:use-attribute-sets="fwtable table borders">
                <xsl:call-template name="checkIfLast"/>
                <fo:table-column column-width="proportional-column-width(16)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(50)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <fo:table-row keep-with-next.within-column="always">
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Info</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Recommendation</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:choose>
                        <xsl:when test="@status and @Ref">
                            <!-- Only generate a table for findings in the section with this status AND this Ref -->
                            <xsl:for-each
                                select="/pentest_report/descendant::finding[@status = $statusSequence][ancestor::*[@id = $Ref]]">
                                <xsl:call-template name="recommendationsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@status and not(@Ref)">
                            <!-- Only generate a table for findings in the section with this status -->
                            <xsl:for-each
                                select="/pentest_report/descendant::finding[@status = $statusSequence]">
                                <xsl:call-template name="recommendationsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@Ref and not(@status)">
                            <!-- Only generate a table for findings in the section with this Ref -->
                            <xsl:for-each
                                select="/pentest_report/descendant::finding[ancestor::*[@id = $Ref]]">
                                <xsl:call-template name="recommendationsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="/pentest_report/descendant::finding">
                                <xsl:call-template name="recommendationsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template name="recommendationsSummaryContent">
        <fo:table-row xsl:use-attribute-sets="TableFont" keep-together.within-column="always">
            <xsl:if test="position() mod 2 != 0">
                <xsl:attribute name="background-color">#ededed</xsl:attribute>
            </xsl:if>

            <!-- First Table Cell -->
            <fo:table-cell xsl:use-attribute-sets="td">
                <!-- ID as a Link -->
                <fo:block>
                    <fo:basic-link xsl:use-attribute-sets="link">
                        <xsl:attribute name="internal-destination">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="." mode="number"/>
                    </fo:basic-link>
                </fo:block>

                <!-- Threat Level -->
                <xsl:if test="@threatLevel">
                    <fo:block>
                        <fo:inline xsl:use-attribute-sets="bold">
                            <xsl:choose>
                                <xsl:when test="@threatLevel">
                                    <xsl:value-of select="@threatLevel"/>
                                </xsl:when>
                            </xsl:choose>
                        </fo:inline>                            
                    </fo:block>
                </xsl:if>

                <!-- Type -->
                <xsl:if test="@type">
                    <fo:block>
                        <fo:inline xsl:use-attribute-sets="bold">Type: </fo:inline>
                        <xsl:value-of select="@type"/>
                    </fo:block>
                </xsl:if>

                <!-- Status -->
                <xsl:if test="@status">
                    <fo:block>
                        <fo:inline xsl:use-attribute-sets="bold">Status: </fo:inline>
                        <xsl:choose>
                            <xsl:when test="@status = 'new' or @status = 'unresolved'">
                                <fo:inline>
                                    <xsl:attribute name="color">
                                        <xsl:value-of select="$color_new"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@status"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:when test="@status = 'not_retested'">
                                <fo:inline>
                                    <xsl:attribute name="color">
                                        <xsl:value-of select="$color_notretested"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@status"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:when test="@status = 'resolved'">
                                <fo:inline>
                                    <xsl:attribute name="color">
                                        <xsl:value-of select="$color_resolved"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@status"/>
                                </fo:inline>
                            </xsl:when>
                            <xsl:otherwise>
                                <fo:inline>
                                    <xsl:value-of select="@status"/>
                                </fo:inline>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                </xsl:if>

                <!-- Labels Section -->
                <xsl:if test="labels/label">
                    <fo:block>
                        <xsl:for-each select="labels/label">
                            <fo:inline xsl:use-attribute-sets="label">
                                <xsl:attribute name="background-color">
                                    <xsl:value-of select="/pentest_report/meta/labels/label[@name = current()]/@color"/>
                                </xsl:attribute>
                                <xsl:attribute name="color">
                                    <xsl:value-of select="/pentest_report/meta/labels/label[@name = current()]/@text"/>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </fo:inline>
                            <xsl:text> </xsl:text> <!-- Add space between labels -->
                        </xsl:for-each>
                    </fo:block>
                </xsl:if>

            </fo:table-cell>

            <!-- Second Table Cell: Recommendation -->
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <!-- Check for recommendation_summary first -->
                    <xsl:choose>
                        <xsl:when test="recommendation_summary">
                            <xsl:apply-templates select="recommendation_summary" mode="summarytable"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="recommendation" mode="summarytable"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>


    <xsl:template match="generate_testteam">
        <fo:block>
            <fo:table xsl:use-attribute-sets="fwtable borders">
                <fo:table-column column-width="proportional-column-width(25)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(75)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <xsl:for-each select="/pentest_report/meta/collaborators/pentesters/pentester">
                        <xsl:if
                            test="not(./name = /pentest_report/meta/collaborators/approver/name)">
                            <fo:table-row xsl:use-attribute-sets="borders">
                                <fo:table-cell xsl:use-attribute-sets="td">
                                    <fo:block>
                                        <xsl:apply-templates select="name"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="td">
                                    <fo:block>
                                        <xsl:apply-templates select="bio"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="/pentest_report/meta/collaborators/approver">
                        <fo:table-row xsl:use-attribute-sets="borders">
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:apply-templates select="name"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:apply-templates select="bio"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template match="generate_permission_parties">
        <xsl:for-each select="/*/meta/permission_parties/client | /*/meta/permission_parties/party">
            <xsl:if test="self::party and not(following-sibling::party)">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringID" select="'permission_and'"/>
                </xsl:call-template>
                <xsl:text>&#x20;</xsl:text>
            </xsl:if>
            <xsl:value-of select="full_name"/>
            <xsl:if test="../party[2]">, </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="generate_service_breakdown">
        <xsl:choose>
            <xsl:when test="@format = 'list'">
                <fo:list-block xsl:use-attribute-sets="list">
                    <xsl:for-each select="$serviceNodeSet/entry[@type = 'service']">
                        <xsl:if test="d">
                            <fo:list-item xsl:use-attribute-sets="li">
                                <!-- insert a bullet -->
                                <fo:list-item-label end-indent="label-end()">
                                    <fo:block>
                                        <fo:inline>&#8226;</fo:inline>
                                    </fo:block>
                                </fo:list-item-label>
                                <!-- list text -->
                                <fo:list-item-body start-indent="body-start()">
                                    <fo:block>
                                        <xsl:value-of select="desc"/>
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="d"/>
                                    </fo:block>
                                </fo:list-item-body>
                            </fo:list-item>
                        </xsl:if>
                    </xsl:for-each>
                    <fo:list-item xsl:use-attribute-sets="li">
                        <!-- insert a bullet -->
                        <fo:list-item-label end-indent="label-end()">
                            <fo:block>
                                <fo:inline>&#8226;</fo:inline>
                            </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="body-start()">
                            <fo:block xsl:use-attribute-sets="bold">
                                <xsl:text>Total effort: </xsl:text>
                                <xsl:call-template name="calculatePersonDays"/>
                                <xsl:text> days</xsl:text>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </fo:list-block>
            </xsl:when>
            <xsl:when test="@format = 'table'">
                <fo:block xsl:use-attribute-sets="keep-together"><fo:table xsl:use-attribute-sets="breakdowntable">
                    <fo:table-column column-width="proportional-column-width(6)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-column column-width="proportional-column-width(2)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-column column-width="proportional-column-width(3)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-column column-width="proportional-column-width(4)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="th">
                                <fo:block> Description </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="th">
                                <fo:block> Effort </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="th">
                                <fo:block> Hourly rate </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="th">
                                <fo:block> Fee </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <xsl:for-each select="$serviceNodeSet/entry">
                            <fo:table-row>
                                <xsl:if test="position() mod 2 != 0">
                                    <xsl:attribute name="background-color">#ededed</xsl:attribute>
                                </xsl:if>
                                <fo:table-cell xsl:use-attribute-sets="td">
                                    <xsl:if
                                        test="not(normalize-space(d)) and not(normalize-space(h))">
                                        <xsl:attribute name="number-columns-spanned"
                                            >3</xsl:attribute>
                                    </xsl:if>
                                    <fo:block>
                                        <xsl:value-of select="desc"/>
                                    </fo:block>
                                </fo:table-cell>
                                <xsl:if test="d">
                                    <fo:table-cell xsl:use-attribute-sets="td">
                                        <fo:block>
                                            <xsl:value-of select="d"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <xsl:choose>
                                        <xsl:when test="normalize-space(h)">
                                            <fo:table-cell xsl:use-attribute-sets="td">
                                                <fo:block text-align="right">
                                                  <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="."/>
                                                  </xsl:call-template>
                                                  <xsl:call-template name="prettyMissingDecimal">
                                                  <xsl:with-param name="n" select="h"/>
                                                  </xsl:call-template>
                                                  <xsl:text> excl. VAT</xsl:text>
                                                </fo:block>
                                            </fo:table-cell>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <fo:table-cell xsl:use-attribute-sets="td">
                                                <fo:block text-align="right">-</fo:block>
                                            </fo:table-cell>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                                <fo:table-cell xsl:use-attribute-sets="td">
                                    <fo:block text-align="right">
                                        <xsl:choose>
                                            <xsl:when test="not(f/min = f/max)">
                                                <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="."/>
                                                </xsl:call-template>
                                                <xsl:number value="f/min" grouping-separator=","
                                                  grouping-size="3"/>
                                                <xsl:text> - </xsl:text>
                                                <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="."/>
                                                </xsl:call-template>
                                                <xsl:call-template name="prettyMissingDecimal">
                                                  <xsl:with-param name="n" select="f/max"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="."/>
                                                </xsl:call-template>
                                                <xsl:call-template name="prettyMissingDecimal">
                                                  <xsl:with-param name="n" select="f/min"/>
                                                </xsl:call-template>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:text> excl. VAT</xsl:text>
                                        <xsl:if test="@estimate = true()">*</xsl:if>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:for-each>
                        <fo:table-row xsl:use-attribute-sets="totalRow">
                            <fo:table-cell number-columns-spanned="4" xsl:use-attribute-sets="td">
                                <fo:block xsl:use-attribute-sets="totalcell">
                                    <xsl:text>Total</xsl:text>
                                    <xsl:if test="$serviceNodeSet/entry/@estimate = true()">
                                        (estimate)</xsl:if>
                                    <xsl:text>:</xsl:text>
                                    <fo:leader leader-pattern="space"/>
                                    <xsl:call-template name="calculateTotal"/>
                                    <xsl:text> excl. VAT</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table></fo:block>


                <xsl:if test="$serviceNodeSet/entry/@estimate = true()">
                    <fo:block text-align="right">
                        <xsl:text>* Estimate</xsl:text>
                    </fo:block>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string">ERROR: unknown service breakdown format (use
                        'list' or 'table')</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="calculateTotal">
        <xsl:param name="denoms" tunnel="yes">
            <xsl:for-each-group select="$serviceNodeSet/entry" group-by="@denomination">
                <denom denomination="{current-grouping-key()}"/>
            </xsl:for-each-group>
        </xsl:param>
        <xsl:variable name="allDenominationsAreEqual" select="count($denoms/denom) = 1"/>
        <xsl:variable name="minmaxesPresent"
            select="boolean($serviceNodeSet/entry/f/min and $serviceNodeSet/entry/f/max)"/>
        <xsl:variable name="estimatePresent" select="$serviceNodeSet/entry/@estimate"/>
        <xsl:variable name="totalMinFees" select="sum($serviceNodeSet/entry/f/min)"/>
        <xsl:variable name="totalMaxFees" select="sum($serviceNodeSet/entry/f/max)"/>
        <xsl:choose>
            <xsl:when test="not($totalMinFees = $totalMaxFees)">
                <!-- We have different min and max fees, print range -->
                <xsl:call-template name="checkDenomination">
                    <xsl:with-param name="allDenominationsAreEqual"
                        select="$allDenominationsAreEqual"/>
                    <xsl:with-param name="denoms" select="$denoms"/>
                </xsl:call-template>
                <xsl:number value="$totalMinFees" grouping-separator="," grouping-size="3"/>
                <xsl:text> - </xsl:text>
                <xsl:call-template name="checkDenomination">
                    <xsl:with-param name="allDenominationsAreEqual"
                        select="$allDenominationsAreEqual"/>
                    <xsl:with-param name="denoms" select="$denoms"/>
                </xsl:call-template>
                <xsl:call-template name="prettyMissingDecimal">
                    <xsl:with-param name="n" select="$totalMaxFees"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Min and max are equal; print single price -->
                <xsl:call-template name="checkDenomination">
                    <xsl:with-param name="allDenominationsAreEqual"
                        select="$allDenominationsAreEqual"/>
                    <xsl:with-param name="denoms" select="$denoms"/>
                </xsl:call-template>
                <xsl:call-template name="prettyMissingDecimal">
                    <xsl:with-param name="n" select="$totalMinFees"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="checkDenomination">
        <xsl:param name="allDenominationsAreEqual"/>
        <xsl:param name="denoms"/>
        <xsl:choose>
            <xsl:when test="$allDenominationsAreEqual">
                <xsl:call-template name="getDenomination">
                    <xsl:with-param name="placeholderElement" select="$denoms/denom"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string">Cannot print denomination: not all fees in
                        service_breakdown have an equal denomination (tip: if most services are in
                        eur but one is in usd, add the usd fee to the description for that service
                        and use an estimated eur for the hourly rate or fee).</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="calculatePersonDays">
        <xsl:variable name="totalMinDurations"
            select="sum($serviceNodeSet/entry[@type = 'service']/dh/min)"/>
        <xsl:variable name="totalMaxDurations"
            select="sum($serviceNodeSet/entry[@type = 'service']/dh/max)"/>
        <xsl:choose>
            <xsl:when test="not($totalMinDurations = $totalMaxDurations)">
                <xsl:value-of select="sum($totalMinDurations) div 8"/>
                <xsl:text> - </xsl:text>
                <xsl:value-of select="sum($totalMaxDurations) div 8"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="sum($totalMinDurations) div 8"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="prettyMissingDecimal">
        <xsl:param name="n"/>
        <xsl:if test="floor($n) = $n">
            <xsl:number value="$n" grouping-separator="," grouping-size="3"/>
            <xsl:text>.-</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="labels"/>

</xsl:stylesheet>