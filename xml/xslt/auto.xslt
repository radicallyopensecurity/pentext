<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:my="http://www.radical.sexy" extension-element-prefixes="math my">

    <xsl:template match="generate_targets">
        <xsl:call-template name="generate_targets_xslt"/>
    </xsl:template>

    <xsl:template name="generate_targets_xslt">
        <xsl:param name="Ref" select="@Ref"/>
        <fo:list-block xsl:use-attribute-sets="list" provisional-distance-between-starts="0.75cm"
            provisional-label-separation="2.5mm" space-after="12pt" start-indent="1cm">
            <xsl:for-each
                select="/*/meta/targets/target[@Ref = $Ref] | /*/meta/targets/target[not(@Ref)]">
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
                            <xsl:value-of select="."/>
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:for-each>
        </fo:list-block>
    </xsl:template>

    <xsl:template match="generate_teammembers">
        <xsl:call-template name="generate_teammembers_xslt"/>
    </xsl:template>

    <xsl:template name="generate_teammembers_xslt">

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
        <xsl:variable name="Ref" select="@Ref"/>
        <xsl:variable name="statusSequence" as="item()*">
            <xsl:for-each select="@status">
                <xsl:for-each select="tokenize(., ' ')">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="unsortedFindingSummaryTable">
            <xsl:for-each-group select="//finding" group-by="@threatLevel">
                <xsl:for-each select="current-group()">
                    <findingEntry>
                        <xsl:attribute name="Ref">
                            <xsl:value-of select="@Ref"/>
                        </xsl:attribute>
                        <xsl:attribute name="status">
                            <xsl:value-of select="@status"/>
                        </xsl:attribute>
                        <xsl:attribute name="findingId">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <findingNumber>
                            <xsl:apply-templates select="." mode="number"/>
                        </findingNumber>
                        <findingType>
                            <xsl:value-of select="@type"/>
                        </findingType>
                        <findingDescription>
                            <xsl:choose>
                                <xsl:when test="description_summary">
                                    <xsl:value-of select="description_summary"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="description" mode="summarytable"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </findingDescription>
                        <findingThreatLevel>
                            <xsl:value-of select="current-grouping-key()"/>
                        </findingThreatLevel>
                    </findingEntry>
                </xsl:for-each>
            </xsl:for-each-group>
        </xsl:variable>
        <xsl:variable name="findingSummaryTable">
            <xsl:for-each select="$unsortedFindingSummaryTable/findingEntry">
                <xsl:sort data-type="number" order="descending"
                    select="
                        (number(findingThreatLevel = 'Extreme') * 10)
                        + (number(findingThreatLevel = 'High') * 9)
                        + (number(findingThreatLevel = 'Elevated') * 8)
                        + (number(findingThreatLevel = 'Moderate') * 7)
                        + (number(findingThreatLevel = 'Low') * 6)
                        + (number(findingThreatLevel = 'Unknown') * 3)
                        + (number(findingThreatLevel = 'N/A') * 1)"/>
                <xsl:variable name="findingThreatLevelClean"
                                                  select="translate(findingThreatLevel, '/', '_')"/>
                <findingEntry>
                    <xsl:attribute name="Ref">
                        <xsl:value-of select="@Ref"/>
                    </xsl:attribute>
                    <xsl:attribute name="status">
                        <xsl:value-of select="@status"/>
                    </xsl:attribute>
                    <xsl:attribute name="findingId">
                        <xsl:value-of select="@findingId"/>
                    </xsl:attribute>
                    <!-- add an id for the first entry of each type so that we can link to it -->
                    <xsl:if
                        test="not(preceding-sibling::findingEntry/findingThreatLevel = findingThreatLevel)">
                        <xsl:attribute name="id">summaryTableThreatLevel<xsl:value-of
                                select="$findingThreatLevelClean"/></xsl:attribute>
                    </xsl:if>
                    <findingNumber>
                        <xsl:value-of select="findingNumber"/>
                    </findingNumber>
                    <findingType>
                        <xsl:value-of select="findingType"/>
                    </findingType>
                    <findingDescription>
                        <xsl:value-of select="findingDescription"/>
                    </findingDescription>
                    <findingThreatLevel>
                        <xsl:value-of select="findingThreatLevel"/>
                    </findingThreatLevel>
                </findingEntry>
            </xsl:for-each>
        </xsl:variable>
        <fo:block>
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="table borders">
                <xsl:call-template name="checkIfLast"/>
                <fo:table-column column-width="proportional-column-width(12)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(22)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(50)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(16)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <fo:table-row xsl:use-attribute-sets="bg-orange borders">
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>ID</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Type</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Description</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Threat level</fo:block>
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
                            <xsl:for-each select="$findingSummaryTable/findingEntry">
                                <xsl:call-template name="findingsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template name="findingsSummaryContent">
        <fo:table-row xsl:use-attribute-sets="borders TableFont">
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <fo:basic-link color="blue">
                        <xsl:attribute name="internal-destination">
                            <xsl:value-of select="@findingId"/>
                        </xsl:attribute>
                        <xsl:value-of select="findingNumber"/>
                    </fo:basic-link>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:value-of select="findingType"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:value-of select="findingDescription"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:value-of select="findingThreatLevel"/>
                </fo:block>
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
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="table borders">
                <xsl:call-template name="checkIfLast"/>
                <fo:table-column column-width="proportional-column-width(12)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(22)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(66)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <fo:table-row xsl:use-attribute-sets="bg-orange borders">
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>ID</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Type</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
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
        <fo:table-row xsl:use-attribute-sets="TableFont borders">
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <fo:basic-link color="blue">
                        <xsl:attribute name="internal-destination">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="." mode="number"/>
                    </fo:basic-link>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:value-of select="@type"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:choose>
                        <xsl:when test="recommendation_summary">
                            <xsl:value-of select="recommendation_summary"/>
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
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="borders">
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

    <xsl:template match="generate_offer_signature_box">

        <xsl:call-template name="generateSignatureBox">
            <xsl:with-param name="latestVersionDate" select="$latestVersionDate"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="generateSignatureBox">
        <xsl:param name="latestVersionDate"/>
        <fo:block keep-together.within-page="always" xsl:use-attribute-sets="signaturebox">
            <fo:block xsl:use-attribute-sets="title-client">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringID" select="'signed_dupe'"/>
                </xsl:call-template>
            </fo:block>
            <fo:block>
                <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="borders">
                    <fo:table-column column-width="proportional-column-width(50)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-column column-width="proportional-column-width(50)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:value-of select="$latestVersionDate"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:value-of select="$latestVersionDate"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:value-of select="/*/meta/permission_parties/client/city"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:value-of select="/*/meta/company/city"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>&#160;</fo:block>
                                <fo:block>&#160;</fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>&#160;</fo:block>
                                <fo:block>&#160;</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test="/offerte">

                                            <xsl:value-of
                                                select="/*/meta/permission_parties/client/legal_rep"/>

                                        </xsl:when>
                                        <xsl:when test="/quickscope">

                                            <xsl:value-of select="/*/customer/legal_rep"/>

                                        </xsl:when>
                                    </xsl:choose>

                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test="/offerte">

                                            <xsl:value-of select="/*/meta/company/legal_rep"/>

                                        </xsl:when>
                                        <xsl:when test="/quickscope">

                                            <xsl:value-of select="/*/company/legal_rep"/>

                                        </xsl:when>
                                    </xsl:choose>

                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block xsl:use-attribute-sets="bold">
                                    <xsl:choose>
                                        <xsl:when test="/offerte">

                                            <xsl:value-of
                                                select="/*/meta/permission_parties/client/full_name"/>

                                        </xsl:when>
                                        <xsl:when test="/quickscope">

                                            <xsl:value-of select="/*/customer/full_name"/>

                                        </xsl:when>
                                    </xsl:choose>

                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block xsl:use-attribute-sets="bold">
                                    <xsl:choose>
                                        <xsl:when test="/offerte">

                                            <xsl:value-of select="/*/meta/company/full_name"/>

                                        </xsl:when>
                                        <xsl:when test="/quickscope">

                                            <xsl:value-of select="/*/company/full_name"/>

                                        </xsl:when>
                                    </xsl:choose>

                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
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

    <xsl:template match="generate_piechart">
        <xsl:choose>
            <xsl:when test="//finding">
                <!-- only generate pie chart if there are findings in the report - otherwise we get into trouble with empty percentages and divisions by zero -->
                <xsl:call-template name="do_generate_piechart">
                    <xsl:with-param name="pieAttr" select="@pieAttr"/>
                    <xsl:with-param name="pieElem" select="@pieElem"/>
                    <xsl:with-param name="pieHeight" select="@pieHeight"/>
                    <xsl:with-param name="status" select="@status"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <fo:block xsl:use-attribute-sets="errortext">Pie chart can only be generated when
                    there are findings in the report. Get to work! ;)</fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="do_generate_piechart">
        <!-- Get the numbers -->
        <!-- generate_piechart @type="type" or "threatLevel" -->
        <xsl:param name="pieAttr" select="@pieAttr"/>
        <xsl:param name="pieElem" select="@pieElem"/>
        <xsl:param name="pieHeight" as="xs:integer" select="@pieHeight"/>
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
        <xsl:variable name="pieTable">
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
        <xsl:variable name="no_entries" select="count($pieTable/pieEntry)"/>
        <xsl:for-each select="$pieTable">
            <fo:block xsl:use-attribute-sets="p">
                <fo:table margin-top="15px">
                    <!-- need some margin to make space for percentages that can't fit in the pie... -->
                    <fo:table-column column-width="{$pieHeight + 50}px"/>
                    <fo:table-column/>
                    <fo:table-body>
                        <fo:table-row keep-together.within-column="always">
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <fo:instream-foreign-object
                                        xmlns:svg="http://www.w3.org/2000/svg">
                                        <!--set the display-->
                                        <svg:svg>
                                            <!-- width and height of the viewport -->
                                            <xsl:attribute name="width">
                                                <xsl:value-of select="$pieHeight"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="height">
                                                <xsl:value-of select="$pieHeight"/>
                                            </xsl:attribute>
                                            <!-- viewBox to scale -->
                                            <xsl:attribute name="viewBox">
                                                <xsl:value-of
                                                  select="concat('0 0 ', $pieHeight, ' ', $pieHeight)"
                                                />
                                            </xsl:attribute>
                                            <!--call the template starting at the last slice-->
                                            <xsl:call-template name="pie_chart_slice">
                                                <xsl:with-param name="pieTotal" select="$pieTotal"/>
                                                <xsl:with-param name="no_entries"
                                                  select="$no_entries"/>
                                                <xsl:with-param name="position" select="$no_entries"/>
                                                <xsl:with-param name="middle_x"
                                                  select="$pieHeightHalf"/>
                                                <xsl:with-param name="middle_y"
                                                  select="$pieHeightHalf"/>
                                                <xsl:with-param name="move_x" select="0"/>
                                                <xsl:with-param name="radius"
                                                  select="$pieHeightHalf"/>
                                            </xsl:call-template>
                                        </svg:svg>
                                    </fo:instream-foreign-object>
                                </fo:block>
                            </fo:table-cell>
                            <!-- PIE CHART LEGEND -->
                            <fo:table-cell>
                                <fo:block>
                                    <fo:table xsl:use-attribute-sets="pieLegendTable">
                                        <fo:table-column column-width="20px"/>
                                        <fo:table-column/>
                                        <fo:table-body>
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
                                                <fo:table-row>
                                                  <fo:table-cell xsl:use-attribute-sets="td">
                                                  <fo:block>
                                                  <fo:instream-foreign-object>
                                                  <svg:svg height="13" width="13">
                                                  <svg:rect stroke="black" stroke-width="1"
                                                  stroke-linejoin="round" height="11" width="11">
                                                  <xsl:attribute name="fill">
                                                  <xsl:call-template name="giveColor">
                                                  <xsl:with-param name="i" select="position()"/>
                                                  <xsl:with-param name="pieEntryLabel"
                                                  select="pieEntryLabel"/>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                  </svg:rect>
                                                  </svg:svg>
                                                  </fo:instream-foreign-object>
                                                  </fo:block>
                                                  </fo:table-cell>
                                                  <fo:table-cell xsl:use-attribute-sets="td">
                                                  <fo:block>
                                                  <xsl:value-of select="$pieEntryLabel"/>
                                                  <xsl:text> (</xsl:text>
                                                  <!-- for threatLevel legend, link to finding summary table -->
                                                  <xsl:choose>
                                                  <xsl:when test="$pieAttr = 'threatLevel'">
                                                  <fo:basic-link text-decoration="underline">
                                                  <xsl:attribute name="internal-destination"
                                                  >summaryTableThreatLevel<xsl:value-of
                                                  select="$pieEntryLabelClean"/></xsl:attribute>
                                                  <xsl:value-of select="pieEntryCount"/>
                                                  </fo:basic-link>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="pieEntryCount"/>
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
            select="concat($middle, ' ', $first_line, ' ', 'a', $radius, ',', $radius, ' ', $arc_move, ' ', $x, ',', $radius - $y, ' ', 'z')"/>
        <!--put it all together-->
        <svg:path stroke="black" stroke-width="1" stroke-linejoin="round">
            <xsl:attribute name="fill">
                <xsl:call-template name="giveColor">
                    <xsl:with-param name="i" select="$position"/>
                    <xsl:with-param name="pieEntryLabel"
                        select="//pieEntry[position() = $position]/pieEntryLabel"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="d">
                <xsl:value-of select="$d"/>
            </xsl:attribute>
        </svg:path>
        <!--now the percentage-->
        <xsl:variable name="percentage" as="xs:double"
            select="(//pieEntry[position() = $position]/pieEntryCount div sum(//pieEntry/pieEntryCount)) * 100"/>
        <xsl:variable name="part_half" as="xs:double"
            select="(//pieEntry[position() = $position]/pieEntryCount div sum(//pieEntry/pieEntryCount)) div 2 * 360"/>
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
                <svg:text text-anchor="middle" xsl:use-attribute-sets="TableFont">
                    <xsl:attribute name="x">
                        <xsl:value-of select="$middle_x + $text_line_x"/>
                    </xsl:attribute>
                    <xsl:attribute name="y">
                        <xsl:value-of select="$middle_y - $text_line_y"/>
                    </xsl:attribute>
                    <xsl:value-of select="format-number($percentage, '##,##0.0')"/>
                    <xsl:text>%</xsl:text>
                </svg:text>
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
                <svg:path stroke="black" stroke-width="1" stroke-linejoin="round">
                    <xsl:attribute name="fill">none</xsl:attribute>
                    <xsl:attribute name="d">
                        <xsl:value-of
                            select="concat('M', ' ', $middle_x + $text_x, ',', $middle_y - $text_y, ' ', 'L', ' ', $middle_x + $text_line_x, ',', $middle_y - $text_line_y, ' ', 'H', ' ', $middle_x + $text_line_x + $line_dir)"
                        />
                    </xsl:attribute>
                </svg:path>
                <svg:text text-anchor="end" xsl:use-attribute-sets="TableFont">
                    <xsl:attribute name="x">
                        <!-- placement of text depends on where extra line is pointing -->
                        <xsl:value-of select="$text_x_relative_to_line"/>
                    </xsl:attribute>
                    <xsl:attribute name="y">
                        <xsl:value-of select="$middle_y - $text_line_y + 1"/>
                    </xsl:attribute>
                    <xsl:value-of select="format-number($percentage, '##,##0.0')"/>
                    <xsl:text>%</xsl:text>
                </svg:text>
            </xsl:otherwise>
        </xsl:choose>
        <!--<svg:text text-anchor="middle" xsl:use-attribute-sets="DefaultFont">
                    <xsl:attribute name="x">
                        <xsl:value-of select="$middle_x + $text_line_x"/>
                    </xsl:attribute>
                    <xsl:attribute name="y">
                        <xsl:value-of select="$middle_y - $text_line_y"/>
                    </xsl:attribute>
                    <xsl:value-of select="format-number($percentage, '##,##0.0')"/>
                    <xsl:text>%</xsl:text>
                </svg:text>-->
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
    <xsl:template name="giveColor">
        <xsl:param name="i"/>
        <xsl:param name="pieEntryLabel"/>
        <xsl:choose>
            <!-- specific cases -->
            <!-- threat level -->
            <xsl:when test="$pieEntryLabel = 'Extreme'">#CC4900</xsl:when>
            <xsl:when test="$pieEntryLabel = 'High'">#FF5C00</xsl:when>
            <xsl:when test="$pieEntryLabel = 'Elevated'">#FE9920</xsl:when>
            <xsl:when test="$pieEntryLabel = 'Moderate'">#ffbf7f</xsl:when>
            <xsl:when test="$pieEntryLabel = 'Low'">#ffed7f</xsl:when>
            <xsl:when test="$pieEntryLabel = 'N/A'">#FFFFFF</xsl:when>
            <xsl:when test="$pieEntryLabel = 'Unknown'">#CCCCCC</xsl:when>
            <!-- status -->
            <xsl:when test="$pieEntryLabel = 'new'">#CC4900</xsl:when>
            <xsl:when test="$pieEntryLabel = 'unresolved'">#FF5C00</xsl:when>
            <xsl:when test="$pieEntryLabel = 'not_retested'">#FE9920</xsl:when>
            <xsl:when test="$pieEntryLabel = 'resolved'">#e5d572</xsl:when>
            <xsl:otherwise>
                <!-- generic pie chart -->
                <xsl:choose>
                    <!-- Going with shades of green and blue in all cases here so as not to imply severity levels -->
                    <xsl:when test="$i = 1">#D9D375</xsl:when>
                    <xsl:when test="$i = 2">#B9A44C</xsl:when>
                    <xsl:when test="$i = 3">#BEC5AD</xsl:when>
                    <xsl:when test="$i = 4">#7CA982</xsl:when>
                    <xsl:when test="$i = 5">#566E3D</xsl:when>
                    <xsl:when test="$i = 6">#5B5F97</xsl:when>
                    <xsl:when test="$i = 7">#C200FB</xsl:when>
                    <xsl:when test="$i = 8">#A9E5BB</xsl:when>
                    <xsl:when test="$i = 9">#98C1D9</xsl:when>
                    <xsl:when test="$i = 10">#5B5F97</xsl:when>
                    <xsl:when test="$i = 11">burlywood</xsl:when>
                    <xsl:when test="$i = 12">cornflowerblue</xsl:when><!-- that's right people, cornflower blue -->
                    <xsl:when test="$i = 13">cornsilk</xsl:when>
                    <xsl:otherwise>black</xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="generate_average_rate">
        <xsl:if
            test="not(//meta//client/rates/rate[@title = 'juniorpentester']) or not(//meta//client/rates/rate[@title = 'mediorpentester'])">
            <fo:block xsl:use-attribute-sets="errortext">Generated average rate is based on
                'juniorpentester' and 'mediorpentester' roles, which cannot be found in
                client_info.xml</fo:block>
        </xsl:if>
        <xsl:variable name="juniorrate"
            select="//meta//client/rates/rate[@title = 'juniorpentester'] * 1"/>
        <xsl:variable name="mediorrate"
            select="//meta//client/rates/rate[@title = 'mediorpentester'] * 1"/>
        <xsl:variable name="avg" select="($juniorrate + $mediorrate) div 2"/>
        <xsl:variable name="roundedavg" select="round($avg div 5) * 5"/>
        <xsl:call-template name="getDenomination"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:value-of select="$roundedavg - 10"/>
        <xsl:text> - </xsl:text>
        <xsl:call-template name="getDenomination"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:value-of select="$roundedavg + 10"/>
    </xsl:template>

    <xsl:function name="my:titleCase" as="xs:string">
        <xsl:param name="s" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="lower-case($s) = ('and', 'or')">
                <xsl:value-of select="lower-case($s)"/>
            </xsl:when>
            <xsl:when test="$s = upper-case($s)">
                <xsl:value-of select="$s"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat(upper-case(substring($s, 1, 1)), lower-case(substring($s, 2)))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
