<?xml version="1.0"?>
<!-- output Jira readable format: https://support.atlassian.com/jira-cloud-administration/docs/import-data-from-a-csv-file/ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="delimiter">&quot;,&quot;</xsl:variable>
    <xsl:variable name="quote" select="'&quot;'" />
    <xsl:template match="/pentest_report">
        <!-- Output headers so Jira understands what's going on -->
        <xsl:text>Title,Finding ID,Threat Level,Type,Retest Status,Impact,Recommendation,Short Description, Technical Description, Jira Formatted Description</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="//finding"/>
    </xsl:template>
    <!-- finding -->
    <xsl:template match="finding">
        <!-- variables -->
        <xsl:variable name="finding_id">
            <xsl:value-of select="concat(/pentest_report/@findingCode,'-',string(format-number(@number,'000')))"/>
        </xsl:variable>
        <xsl:variable name="impact">
            <xsl:value-of select="replace(normalize-space(impact), '&quot;', '&quot;&quot;')"/>
        </xsl:variable>
        <xsl:variable name="description">
            <xsl:for-each select="description/p">
                <xsl:text>&#xa;</xsl:text>
                <xsl:text>&#xa;</xsl:text>
                <xsl:value-of select="replace(normalize-space(.), '&quot;', '&quot;&quot;')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="technical_description">
            <xsl:for-each select="technicaldescription/p">
                <xsl:text>&#xa;</xsl:text>
                <xsl:text>&#xa;</xsl:text>
                <xsl:value-of select="replace(normalize-space(.), '&quot;', '&quot;&quot;')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="recommendation">
            <xsl:choose>
                <xsl:when test="string-length(recommendation/ul) &gt; 0">
                    <xsl:for-each select="recommendation/ul/li">
                        <xsl:text>* </xsl:text>
                        <xsl:value-of select="replace(normalize-space(.), '&quot;', '&quot;&quot;')"/>
                        <xsl:if test="position() &lt; last()">
                            <xsl:text></xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="string-length(recommendation/p) &gt; 0">
                    <xsl:value-of select="replace(normalize-space(recommendation/p), '&quot;', '&quot;&quot;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace(normalize-space(recommendation), '&quot;', '&quot;&quot;')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$quote"/>
        <!-- summary column -->
        <!-- jira allows multiline csv records, by wrapping in double quotes  -->
        <!-- this means actual double quotes need to be escaped by double double quotes  -->
        <xsl:value-of select="replace(normalize-space(title), '&quot;', '&quot;&quot;')"/>
        <xsl:value-of select="$delimiter"/>
        <!-- finding id column -->
        <xsl:value-of select="$finding_id"/>
        <xsl:value-of select="$delimiter"/>
        <!-- threat level column -->
        <xsl:value-of select="@threatLevel"/>
        <xsl:value-of select="$delimiter"/>
        <!-- type column -->
        <xsl:value-of select="@type"/>
        <xsl:value-of select="$delimiter"/>
        <!-- status column -->
        <xsl:value-of select="@status"/>
        <xsl:value-of select="$delimiter"/>
        <!-- impact column -->
        <xsl:value-of select="$impact"/>
        <xsl:value-of select="$delimiter"/>
        <!-- recommendation column -->
        <xsl:value-of select="$recommendation"/>
        <xsl:value-of select="$delimiter"/>
        <!-- description column -->
        <xsl:value-of select="$description"/>
        <xsl:value-of select="$delimiter"/>
        <!-- technical description column -->
        <xsl:value-of select="$technical_description"/>
        <xsl:value-of select="$delimiter"/>        
        <!-- jira formatted description column -->
        <!-- merges all the information contained in the finding -->
        <!-- images are skipped, as they have to be already hosted somewhere to import -->
        <xsl:text>*Finding ID:* </xsl:text>
        <xsl:value-of select="$finding_id"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>*Threat Level:* </xsl:text>
        <xsl:value-of select="@threatLevel"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>*Type:* </xsl:text>
        <xsl:value-of select="@type"/>
        <xsl:if test="string-length(impact) &gt; 0">
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>*Impact:* </xsl:text>
            <xsl:value-of select="$impact"/>
        </xsl:if>
        <xsl:if test="string-length(description) &gt; 0">
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>h2. Description: </xsl:text>
            <xsl:value-of select="$description" />
        </xsl:if>
        <xsl:if test="string-length(technicaldescription) &gt; 0">
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>h2. Technical Description: </xsl:text>
            <xsl:value-of select="$technical_description" />
        </xsl:if>
        <xsl:if test="string-length(recommendation) &gt; 0">
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>h2. Recommendation: </xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:value-of select="$recommendation" />
        </xsl:if>
        <xsl:text>&quot;&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
