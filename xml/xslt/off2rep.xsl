<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs xlink fo" version="2.0">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="clientShort" select="normalize-space(//client/short_name)"/>
    <xsl:variable name="stringLength" select="string-length($clientShort)"/>
    <xsl:variable name="stringLengthNoSpaces" select="translate($clientShort, ' ', '')"/>
    <xsl:variable name="wordCount" select="$stringLength - string-length($stringLengthNoSpaces) + 1"/>
    <xsl:variable name="noVowels"
        select="substring(translate($clientShort, 'AaEeIiOoUuYy', ''), 2, string-length(translate($clientShort, 'AaEeIiOoUu', '')) - 1)"/>
    <xsl:variable name="findingCodeSuggestion">
        <xsl:choose>
            <xsl:when test="normalize-space(//client/short_code)">
                <xsl:value-of select="normalize-space(//client/short_code)"/>
            </xsl:when>
            <xsl:when test="$clientShort">
                <xsl:choose>
                    <!-- If client name should start with a three-letter abbreviation, pick that -->
                    <xsl:when
                        test="(string-length(substring-before($clientShort, ' ')) = 3) and substring-before($clientShort, ' ') = upper-case(substring-before($clientShort, ' '))">
                        <xsl:value-of select="substring-before($clientShort, ' ')"/>
                    </xsl:when>
                    <!-- One-word client name -->
                    <xsl:when test="$wordCount = 1">
                        <xsl:choose>
                            <xsl:when test="$stringLength = 3">
                                <xsl:value-of select="$clientShort"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Get first letter -->
                                <xsl:value-of select="substring($clientShort, 1, 1)"/>
                                <!-- Then add two more -->
                                <xsl:choose>
                                    <xsl:when test="string-length($noVowels) &lt; 2">
                                        <!-- not enough consonants remaining, just get letter 2 and 3 -->
                                        <xsl:value-of select="substring($clientShort, 2, 2)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- we have at least two more consonants; add those -->
                                        <xsl:value-of select="substring($noVowels, 1, 2)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- Two-word client name: pick first letter of each word + last letter -->
                    <xsl:when test="$wordCount = 2">
                        <xsl:sequence
                            select="
                                string-join(for $x in tokenize($clientShort, ' ')
                                return
                                    substring($x, 1, 1), '')"/>
                        <xsl:value-of select="substring($noVowels, string-length($noVowels), 1)"/>
                    </xsl:when>
                    <xsl:when test="$wordCount = 3">
                        <!-- Three words! Abbreviate! -->
                        <xsl:sequence
                            select="
                                string-join(for $x in tokenize($clientShort, ' ')
                                return
                                    substring($x, 1, 1), '')"
                        />
                    </xsl:when>
                    <!-- More than 3 words: pick the first letters of the first three words -->
                    <xsl:otherwise>???</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- if there's no shortcode or client name to work with, give up -->
            <xsl:otherwise>???</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- ROOT -->
    <xsl:template match="/">
        <pentest_report xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="../dtd/pentestreport.xsd"
            xmlns:xi="http://www.w3.org/2001/XInclude" xml:lang="en"
            findingCode="{upper-case($findingCodeSuggestion)}" secrets="show">
            <meta>
                <title>Penetration Test Report</title>
                <targets>
                    <xsl:comment>one target element per target</xsl:comment>
                    <xsl:for-each select="/*/meta/targets/target">
                        <xsl:copy copy-namespaces="no">
                            <xsl:copy-of select="node()" copy-namespaces="no"/>
                        </xsl:copy>
                    </xsl:for-each>
                </targets>
                <activityinfo>
                    <xsl:for-each select="/offerte/meta/activityinfo/*">
                        <xsl:if
                            test="not(self::fee) and not(self::planning) and not(self::duration)">
                            <xsl:copy copy-namespaces="no">
                                <xsl:copy-of select="node()" copy-namespaces="no"/>
                            </xsl:copy>
                        </xsl:if>
                        <xsl:if test="self::persondays">
                        <xsl:comment>0 means 'computed automatically from service breakdown' so leave at 0 unless there is a clear reason not to</xsl:comment>
                        </xsl:if>
                    </xsl:for-each>
                    <planning>
                        <xsl:comment>start and end dates, in ISO format: YYYY-MM-DD</xsl:comment>
                        <xsl:for-each select="/offerte/meta/activityinfo/planning/*">
                            <xsl:copy copy-namespaces="no">
                                <xsl:copy-of select="node()" copy-namespaces="no"/>
                            </xsl:copy>
                        </xsl:for-each>
                    </planning>
                </activityinfo>
                <permission_parties>
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">client_info.xml</xsl:attribute>
                    </xsl:element>
                    <xsl:for-each select="/offerte/meta/permission_parties/party">
                        <xsl:copy copy-namespaces="no">
                            <xsl:copy-of select="node()" copy-namespaces="no"/>
                        </xsl:copy>
                    </xsl:for-each>
                </permission_parties>

                <collaborators>
                    <reviewers>
                        <reviewer>FirstName LastName</reviewer>
                    </reviewers>
                    <approver>
                        <name>Melanie Rieback</name>
                        <bio>Melanie Rieback is a former Asst. Prof. of Computer Science from the
                            VU, who is also the co-founder/CEO of Radically Open Security.</bio>
                    </approver>
                    <pentesters>
                        <pentester>
                            <name>FirstName LastName</name>
                            <bio>Info</bio>
                        </pentester>
                    </pentesters>
                </collaborators>
                <classification>Confidential</classification>
                <version_history>
                    <xsl:comment>needed for date on frontpage and in signature boxes; it is possible to add a new &lt;version> after each review; in that case, make sure to update the date/time</xsl:comment>
                    <version number="auto">
                        <xsl:attribute name="date"><xsl:value-of
                                select="format-date(current-date(), '[Y]-[M,2]-[D,2]', 'en', (), ())"
                            />T10:00:00</xsl:attribute>
                        <xsl:comment>actual date-time here; you can leave the number attribute alone</xsl:comment>
                        <v_author>ROS Writer</v_author>
                        <xsl:comment>name of the author here</xsl:comment>
                        <v_description>Initial draft</v_description>
                    </version>
                </version_history>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">snippets/company_info.xml</xsl:attribute>
                </xsl:element>
            </meta>

            <generate_index/>

            <section id="executiveSummary" inexecsummary="yes">
                <title>Executive Summary</title>
                <section id="introduction">
                    <title>Introduction</title>
                    <p>Between <p_startdate/> and <p_enddate/>, <company_long/> carried out a
                        penetration test for <client_long/></p>
                    <p>This report contains our findings as well as detailed explanations of exactly
                        how <company_short/> performed the penetration test.</p>
                </section>
                <section id="scope">
                    <title>Scope of work</title>
                    <p>The scope of the penetration test was limited to the following target(s):</p>
                    <generate_targets/>
                    <p>The scoped services are broken down as follows: </p>
                    <generate_service_breakdown format="list"/>
                </section>
                <section id="objectives">
                    <title>Project objectives</title>
                    <p>
                        <company_short/> will perform a penetration test of
                        <todo desc="INSERT-THE-SCOPE"/> with <client_short/> in order to assess the security of
                        <todo desc="INSERT-THE-SCOPE"/>. To do so <company_short/> will access 
                        <todo desc="INSERT-THE-SCOPE"/> and guide <client_short/> in attempting to find
                        vulnerabilities, exploiting any such found to try and gain further access and elevated privileges.</p>
                </section>
                <section id="timeline">
                    <title>Timeline</title>
                    <p>The Security Audit took place between <p_startdate/> and <p_enddate/>.</p>
                </section>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">resultsinanutshell.xml</xsl:attribute>
                </xsl:element>
                <section id="findingSummary">
                    <title>Summary of Findings</title>
                    <generate_findings/>
                    <xsl:comment> generated from Findings section </xsl:comment>
                    <section id="threatlevelpie">
                        <title>Findings by Threat Level</title>
                        <generate_piechart pieAttr="threatLevel" pieElem="finding"/>
                    </section>
                    <section id="typepie">
                        <title>Findings by Type</title>
                        <generate_piechart pieAttr="type" pieElem="finding"/>
                    </section>
                </section>
                <section id="recommendationSummary">
                    <title>Summary of Recommendations</title>
                    <generate_recommendations/>
                    <xsl:comment> generated from Findings section </xsl:comment>
                </section>
            </section>

            <xsl:element name="xi:include">
                <xsl:attribute name="href">snippets/report/methodology.xml</xsl:attribute>
            </xsl:element>

            <section id="recon" inexecsummary="no">
                <title>Reconnaissance and Fingerprinting</title>
                <p>We were able to gain information about the software and infrastructure through the following automated
         scans. Any relevant scan output will be referred to in the findings.</p>

                    <ul>
                        <xsl:comment>
                            <li>analyze_hosts - <a href="https://github.com/PeterMosmans/security-scripts">https://github.com/PeterMosmans/security-scripts</a></li>
                        </xsl:comment>
                        <li>nmap – <a href="http://nmap.org">http://nmap.org</a></li>
                        <xsl:comment>
                      <li>OWASP Zed Attack Proxy - <a href="https://github.com/zaproxy/zaproxy">https://github.com/zaproxy/zaproxy</a></li>
                      <li>Skipfish – <a href="https://code.google.com/p/skipfish/">https://code.google.com/p/skipfish/</a></li>
                      <li>sqlmap – <a href="https://github.com/sqlmapproject/sqlmap">https://github.com/sqlmapproject/sqlmap</a></li>
                      <li>testssl.sh –
        <a href="https://github.com/drwetter/testssl.sh">https://github.com/drwetter/testssl.sh</a></li>
                            <li>SSLscan –
               <a href="https://github.com/rbsec/sslscan">https://github.com/rbsec/sslscan</a></li>
                        </xsl:comment>
                    </ul>
            </section>

            <section id="findings">
                <title>Findings</title>

                <p>We have identified the following issues:</p>
                <xsl:comment> Listing of Findings (written by pentesters) </xsl:comment>

                <xsl:comment> Extreme </xsl:comment>

                <xsl:comment> High </xsl:comment>

                <xsl:comment> Elevated </xsl:comment>

                <xsl:comment> Moderate </xsl:comment>

                <xsl:comment> Low </xsl:comment>
            </section>

            <section id="nonFindings">
                <title>Non-Findings</title>
                <p>In this section we list some of the things that were tried but turned out to be
                    dead ends.</p>
                <xsl:comment> Listing of Non-Findings (written by pentesters) </xsl:comment>
            </section>

            <xsl:element name="xi:include">
                <xsl:attribute name="href">futurework.xml</xsl:attribute>
            </xsl:element>
            <xsl:element name="xi:include">
                <xsl:attribute name="href">conclusion.xml</xsl:attribute>
            </xsl:element>

            <appendix id="testteam">
                <title>Testing team</title>
                <generate_testteam/>
            </appendix>

        </pentest_report>


    </xsl:template>



</xsl:stylesheet>
