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
                <fo:table-column column-width="proportional-column-width(12)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(22)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(50)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(16)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <fo:table-row keep-with-next.within-column="always">
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>ID</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Type</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Description</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="th">
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
        <fo:table-row xsl:use-attribute-sets="TableFont">
            <xsl:if test="position() mod 2 != 0">
                <xsl:attribute name="background-color">#ededed</xsl:attribute>
            </xsl:if>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <!-- attach id to first finding of each threatLevel so pie charts can link to it -->
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
            <fo:table xsl:use-attribute-sets="fwtable table borders">
                <xsl:call-template name="checkIfLast"/>
                <fo:table-column column-width="proportional-column-width(12)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(22)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(66)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <fo:table-row keep-with-next.within-column="always">
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>ID</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Type</fo:block>
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
        <fo:table-row xsl:use-attribute-sets="TableFont">
            <xsl:if test="position() mod 2 != 0">
                <xsl:attribute name="background-color">#ededed</xsl:attribute>
            </xsl:if>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <fo:basic-link xsl:use-attribute-sets="link">
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
                            <xsl:apply-templates select="recommendation_summary" mode="summarytable"
                            />
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
                <fo:table xsl:use-attribute-sets="fwtable borders">
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

    <xsl:template match="generate_service_breakdown">
        <xsl:choose>
            <xsl:when test="@format = 'list'">
                <fo:list-block xsl:use-attribute-sets="list">
                    <xsl:for-each select="//service_list/service">
                        <xsl:if test="duration">
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
                                        <xsl:value-of select="description"/>
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="duration"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="duration/@in"/>
                                    </fo:block>
                                </fo:list-item-body>
                            </fo:list-item>
                        </xsl:if>
                    </xsl:for-each>
                </fo:list-block>
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string">TODO: total!</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@format = 'table'">
                <fo:block>
                    <fo:table xsl:use-attribute-sets="fwtable borders">
                        <fo:table-column column-width="proportional-column-width(70)"
                            xsl:use-attribute-sets="borders"/>
                        <fo:table-column column-width="proportional-column-width(10)"
                            xsl:use-attribute-sets="borders"/>
                        <fo:table-column column-width="proportional-column-width(10)"
                            xsl:use-attribute-sets="borders"/>
                        <fo:table-column column-width="proportional-column-width(10)"
                            xsl:use-attribute-sets="borders"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell xsl:use-attribute-sets="th">
                                    <fo:block> Description </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="th">
                                    <fo:block> Duration </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="th">
                                    <fo:block> Hourly rate </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="th">
                                    <fo:block> Fee </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <xsl:for-each select="//service_list/service">
                                <fo:table-row>
                                    <fo:table-cell xsl:use-attribute-sets="td">
                                        <fo:block>
                                            <xsl:value-of select="description"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell xsl:use-attribute-sets="td">
                                        <xsl:choose>
                                            <xsl:when test="duration and duration/@in">
                                                <fo:block>
                                                  <xsl:value-of select="duration"/>
                                                  <xsl:text> </xsl:text>
                                                  <xsl:value-of select="duration/@in"/>
                                                </fo:block>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="number-columns-spanned"
                                                  >2</xsl:attribute>
                                                <fo:block>(flat rate)</fo:block>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:table-cell>
                                    <xsl:if test="duration and hourly_rate">
                                        <fo:table-cell xsl:use-attribute-sets="td">
                                            <fo:block>
                                                <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="hourly_rate"/>
                                                </xsl:call-template>
                                                <xsl:value-of select="hourly_rate"/>
                                            </fo:block>
                                        </fo:table-cell>
                                    </xsl:if>
                                    <fo:table-cell xsl:use-attribute-sets="td">
                                        <xsl:choose>
                                            <xsl:when test="not(fee/computed)">
                                                <!-- hardcoded fee, we'll need a denomination -->
                                                <fo:block xsl:use-attribute-sets="moneycell">
                                                  <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="fee"/>
                                                  </xsl:call-template>
                                                  <fo:leader leader-pattern="space"/>
                                                  <xsl:value-of select="fee"/>
                                                </fo:block>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- computed fee; compute using duration and use hourly rate denomination -->
                                                <fo:block xsl:use-attribute-sets="moneycell">
                                                  <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="hourly_rate"/>
                                                  </xsl:call-template>
                                                  <fo:leader leader-pattern="space"/>
                                                  <xsl:choose>
                                                  <xsl:when test="duration/@in = 'hours'">
                                                  <!-- multiply with hourly rate -->
                                                  <xsl:value-of select="duration * hourly_rate"/>
                                                  </xsl:when>
                                                  <xsl:when test="duration/@in = 'days'">
                                                  <!-- multiply with hourly rate * 8 -->
                                                  <xsl:value-of select="duration * hourly_rate * 8"
                                                  />
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </fo:block>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>
                </fo:block>
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string">TODO total</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string">ERROR: unknown service breakdown format (use
                        'list' or 'table')</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
