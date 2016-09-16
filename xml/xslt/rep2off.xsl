<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="localisation.xslt"/>
    <xsl:import href="snippets.xslt"/>
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


    <xsl:variable name="lang" select="/pentest_report/@xml:lang"/>
    <xsl:param name="snippetBase" select="'offerte'"/>
    <xsl:variable name="snippetSelectionRoot"
        select="document('../source/snippets/snippetselection.xml')/snippet_selection/document[@type = $docType]"/>

    <xsl:variable name="docType" select="'offerte'"/>
    <xsl:variable name="docSubType" select="'retest'"/>

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
                <offered_service_long>
                    <xsl:call-template name="getString">
                                <xsl:with-param name="stringID"
                                    select="concat('coverpage_service_', $docSubType)"
                                />
                            </xsl:call-template>
                </offered_service_long>
                <xsl:comment>if there is a shorter way of saying the same thing, you can type it here (it makes for more dynamic offerte text). If not, just repeat the long name.</xsl:comment>
                <offered_service_short>
                    <xsl:call-template name="getString">
                                <xsl:with-param name="stringID"
                                    select="concat('coverpage_service_', $docSubType, '_short')"
                                />
                            </xsl:call-template>
                </offered_service_short>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">snippets/company_info.xml</xsl:attribute>
                </xsl:element>
                <targets>
                    <!-- copy targets from quickscope -->
                    <xsl:comment>one target element per target</xsl:comment>
                    <xsl:for-each select="/*/meta/targets/target">
                        <xsl:copy>
                            <xsl:copy-of select="node()"/>
                        </xsl:copy>
                    </xsl:for-each>
                </targets>
                <permission_parties>
                    <!-- copy permission parties from quickscope -->
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">client_info.xml</xsl:attribute>
                    </xsl:element>
                    <xsl:for-each select="/*/third_party"><!-- TODO add to report -->
                        <party>
                            <xsl:copy-of select="node()"/>
                        </party>
                    </xsl:for-each>
                </permission_parties>
                <pentestinfo>
                    <!-- copy various variables from quickscope -->
                    <duration>2</duration>
                    <xsl:comment>duration of pentest, in working days</xsl:comment>
                    <test_planning>
                        <xsl:choose>
                            <xsl:when test="/*/pentest_info/test_planning"><xsl:value-of select="/*/pentest_info/test_planning"/></xsl:when>
                            <xsl:otherwise>TBD</xsl:otherwise>
                        </xsl:choose>
                    </test_planning>
                    <xsl:comment>date or date range in text, e.g. May 18th until May 25th, 2015</xsl:comment>
                    <report_due>
                        <xsl:choose>
                            <xsl:when test="/*/pentest_info/report_due"><xsl:value-of select="/*/pentest_info/report_due"/></xsl:when>
                            <xsl:otherwise>TBD</xsl:otherwise>
                        </xsl:choose>
                    </report_due>
                    <xsl:comment>date or date range in text, e.g. May 18th until May 25th, 2015</xsl:comment>
                    <nature>
                        <xsl:choose>
                            <xsl:when test="/*/pentest_info/nature"><xsl:value-of select="/*/pentest_info/nature"/></xsl:when>
                            <xsl:otherwise>???</xsl:otherwise>
                        </xsl:choose>
                    </nature>
                    <type>
                        <xsl:choose>
                            <xsl:when test="/*/pentest_info/type"><xsl:value-of select="/*/pentest_info/type"/></xsl:when>
                            <xsl:otherwise>???-box</xsl:otherwise>
                        </xsl:choose>
                    </type>
                    <xsl:comment>please choose one of the following: black-box, grey-box, crystal-box</xsl:comment>
                    <fee denomination="eur">???</fee>
                    <xsl:comment>(eur|usd|gbp)</xsl:comment>
                    <xsl:if test="*/pentest_info/target_application">
                        <target_application>
                            <xsl:value-of select="/*/pentest_info/target_application"/>
                        </target_application>
                    </xsl:if>
                </pentestinfo>
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

        </offerte>


    </xsl:template>

   

</xsl:stylesheet>
