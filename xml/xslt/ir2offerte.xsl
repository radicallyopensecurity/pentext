<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="localisation.xslt"/>
    <xsl:import href="snippets.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


    <xsl:variable name="lang" select="/ir_quickscope/meta/offer_language/text()"/>
    <xsl:param name="snippetBase" select="'offerte'"/>
    <xsl:variable name="snippetSelectionRoot"
        select="document('../source/snippets/snippetselection.xml')/snippet_selection/document[@type = $docType]"/>

    <xsl:variable name="docType" select="'offerte'"/>
    <xsl:variable name="docSubType" select="/ir_quickscope/meta/offer_type"/>

    <!-- ROOT -->
    <xsl:template match="/">

        <offerte xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="../dtd/offerte.xsd"
            xmlns:xi="http://www.w3.org/2001/XInclude">
            <xsl:attribute name="xml:lang">
                <xsl:value-of select="$lang"/>
            </xsl:attribute>
            <xsl:comment>document meta information; to be filled in by the offerte writer</xsl:comment>
            <meta>
                <title>PROPOSAL</title>
                <offered_service_long>
                    <!-- if known type, use long service name from localisationstrings.xml; otherwise, use long service name provided in quickscope -->
                    <xsl:choose>
                        <xsl:when test="/ir_quickscope/meta/offer_type != 'other'">
                            <xsl:call-template name="getString">
                                <xsl:with-param name="stringID"
                                    select="concat('coverpage_service_', /ir_quickscope/meta/offer_type)"
                                />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="/ir_quickscope/meta/requested_service"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </offered_service_long>
                <xsl:comment>if there is a shorter way of saying the same thing, you can type it here (it makes for more dynamic offerte text). If not, just repeat the long name.</xsl:comment>
                <offered_service_short>
                    <!-- if known type, use short service name from localisationstrings.xml; otherwise, use short service name provided in quickscope -->
                    <xsl:choose>
                        <xsl:when test="/ir_quickscope/meta/offer_type != 'other'">
                            <xsl:call-template name="getString">
                                <xsl:with-param name="stringID"
                                    select="concat('coverpage_service_', /*/meta/offer_type, '_short')"
                                />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="/*/meta/requested_service"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </offered_service_short>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">snippets/company_info.xml</xsl:attribute>
                </xsl:element>
                <permission_parties>
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">client_info.xml</xsl:attribute>
                    </xsl:element>
                </permission_parties>
                <activityinfo>
                    <xsl:for-each select="//activity_info/*">
                        <xsl:copy>
                            <xsl:copy-of select="node()"/>
                        </xsl:copy>
                    </xsl:for-each>
                </activityinfo>
                <version_history>
                    <xsl:comment>needed for date on frontpage and in signature boxes; it is possible to add a new &lt;version> after each review; in that case, make sure to update the date/time</xsl:comment>
                    <version number="auto">
                        <xsl:attribute name="date"><xsl:value-of
                                select="format-date(current-date(), '[Y]-[M,2]-[D,2]', 'en', (), ())"
                            />T10:00:00</xsl:attribute>
                        <xsl:comment>actual date-time here; you can leave the number attribute alone</xsl:comment>
                        <v_author>ROS Writer</v_author>
                        <xsl:comment>name of the author here; for internal use only</xsl:comment>
                        <v_description>Initial draft</v_description>
                        <xsl:comment>for internal use only</xsl:comment>
                    </version>
                </version_history>
            </meta>

            <xsl:for-each
                select="$snippetSelectionRoot/selection[@subtype = $docSubType]/snippet_group[@set = 'group1']/snippet">
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">
                        <xsl:call-template name="docCheck">
                            <xsl:with-param name="fileNameBase" select="."/>
                            <xsl:with-param name="snippetDirectory" select="$snippetBase"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>

            <xsl:if test="//activity_info/organizational_readiness_assessment">
                <xsl:for-each
                    select="$snippetSelectionRoot/selection[@subtype = $docSubType]/snippet_group[@set = 'organizational_readiness_assessment']/snippet">
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">
                            <xsl:call-template name="docCheck">
                                <xsl:with-param name="fileNameBase" select="."/>
                                <xsl:with-param name="snippetDirectory" select="$snippetBase"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>

            <xsl:for-each
                select="$snippetSelectionRoot/selection[@subtype = $docSubType]/snippet_group[@set = 'group2']/snippet">
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">
                        <xsl:call-template name="docCheck">
                            <xsl:with-param name="fileNameBase" select="."/>
                            <xsl:with-param name="snippetDirectory" select="$snippetBase"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>


            <!--<xsl:comment>Introduction and Scope</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">introandscope</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>
            <xsl:comment>Project overview section</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">projectoverview</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>
            <xsl:comment>Prerequisites section</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">prerequisites</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>
            <xsl:comment>Disclaimer section</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">disclaimer</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>
            <xsl:comment>Methodology section</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">methodology</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>-->
            <!--<xsl:if test="/*/activity_info/codeaudit/@perform = 'yes'">
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">
                        <xsl:call-template name="docCheck">
                            <xsl:with-param name="fileNamePart"
                                >codeauditmethodology</xsl:with-param>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:element>
            </xsl:if>-->
            <!--<xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">teamandreporting</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>
            <xsl:comment>Planning and payment section</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">planningandpayment</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>
            <xsl:comment>About Us section</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">aboutus</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>
            <xsl:comment>Work condition section</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">conditions</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>
            <xsl:comment>General terms and conditions section</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart"
                            >generaltermsandconditions</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>


            <xsl:comment>Waivers</xsl:comment>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">
                    <xsl:call-template name="docCheck">
                        <xsl:with-param name="fileNamePart">waiver</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:element>-->
        </offerte>


    </xsl:template>

    <!--<xsl:template name="docCheck">
        <xsl:param name="fileNamePart" select="'none'"/>
        <xsl:param name="typeSuffix">
            <xsl:choose>
                <xsl:when test="/*/meta/offer_type = 'pentest' or /*/meta/offer_type = 'other'"/>
                <xsl:otherwise>
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="/*/meta/offer_type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:param name="fileNameStandard"
            select="concat('snippets/offerte/', $lang, '/', $fileNamePart, '.xml')"/>
        <xsl:param name="fileNameExtended"
            select="concat('snippets/offerte/', $lang, '/', $fileNamePart, $typeSuffix, '.xml')"/>
        <xsl:choose>
            <xsl:when test="doc-available(concat('../source/', $fileNameExtended))">
                <xsl:value-of select="$fileNameExtended"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$fileNameStandard"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->

</xsl:stylesheet>
