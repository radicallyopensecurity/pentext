<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <!-- ROOT -->
    <xsl:template match="/">

        <pentest_report xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="../dtd/pentestreport.xsd"
            xmlns:xi="http://www.w3.org/2001/XInclude" findingCode="???">
            <meta>
                <title>Penetration Test Report</title>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">client_info.xml</xsl:attribute>
                </xsl:element>
                <targets>
                    <xsl:comment>one target element per target</xsl:comment>
                    <xsl:for-each select="/*/meta/targets/target">
                        <xsl:copy>
                            <xsl:copy-of select="node()"/>
                        </xsl:copy>
                    </xsl:for-each>
                </targets>
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
                        <xsl:attribute name="date"><xsl:value-of select="format-date(current-date(), '[Y]-[M,2]-[D1]', 'en', (), ())"/>T10:00:00</xsl:attribute>
                        <xsl:comment>actual date-time here; you can leave the number attribute alone</xsl:comment>
                        <v_author>ROS Writer</v_author>
                        <xsl:comment>name of the author here; for internal use only</xsl:comment>
                        <v_description>Initial draft</v_description>
                        <xsl:comment>for internal use only</xsl:comment>
                    </version>
                </version_history>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">snippets/company_info.xml</xsl:attribute>
                </xsl:element>
            </meta>

            <generate_index/>

            <section id="executiveSummary">
                <title>Executive Summary</title>
                <section id="introduction">
                    <title>Introduction</title>
                    <p>...</p>
                    <p>This report contains our findings as well as detailed explanations of exactly
                        how ROS performed the penetration test.</p>
                </section>
                <section id="scope">
                    <title>Scope of work</title>
                    <p>The scope of the penetration test was limited to the following target:</p>
                    <generate_targets/>
                </section>
                <section id="objectives">
                    <title>Project objectives</title>
                    <p>...</p>
                </section>
                <section id="timeline">
                    <title>Timeline</title>
                    <p>The Security Audit took place between X and Y, 2016.</p>
                </section>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">resultsinanutshell.xml</xsl:attribute>
                </xsl:element>
                <section id="findingSummary">
                    <title>Summary of Findings</title>
                    <generate_findings/>
                    <xsl:comment> generated from Findings section </xsl:comment>
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

            <section id="recon">
                <title>Reconnaissance and Fingerprinting</title>
                <p>Through automated scans we were able to gain the following information about the
                    software and infrastructure. Detailed scan output can be found in the sections
                    below.</p>

                <section id="scans">
                    <title>Automated Scans</title>
                    <p>As part of our active reconnaissance we used the following automated
                        scans:</p>
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
                        </xsl:comment>
                    </ul>
                </section>
            </section>

            <section id="techSummary">
                <title>Pentest Technical Summary</title>
                <section id="findings">
                    <title>Findings</title>

                    <p>We have identified the following issues:</p>
                    <xsl:comment> Listing of Findings (written by pentesters) </xsl:comment>
                    <xsl:comment> Extreme </xsl:comment>

                    <xsl:comment> High </xsl:comment>

                    <xsl:comment> Moderate </xsl:comment>

                    <xsl:comment> Elevated </xsl:comment>

                    <xsl:comment> Low </xsl:comment>
                </section>

                <section id="nonFindings">
                    <title>Non-Findings</title>
                    <p>In this section we list some of the things that were tried but turned out to
                        be dead ends.</p>
                </section>
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
