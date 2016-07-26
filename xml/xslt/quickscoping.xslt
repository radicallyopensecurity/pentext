<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:variable name="days">
        <xsl:value-of select="/quickscope/pentest_info/days * 1"/>
    </xsl:variable>
    <xsl:variable name="rate">
        <xsl:value-of select="/quickscope/pentest_info/rate * 1"/>
    </xsl:variable>
    <xsl:variable name="fee">
        <xsl:value-of select="$days * $rate"/>
    </xsl:variable>
    
    <xsl:template match="quickscope">
        <fo:block xsl:use-attribute-sets="graphics-block">
            <fo:external-graphic xsl:use-attribute-sets="logo"/>
        </fo:block>
        <fo:block xsl:use-attribute-sets="for">
            <xsl:text>OFFER</xsl:text>
        </fo:block>
        <fo:block xsl:use-attribute-sets="title-0">
            <xsl:value-of select="upper-case(meta/requested_service)"/>
        </fo:block>
        <!-- NO DOCUMENT CONTROL, JUST THE DATE ON THE FP -->
        <fo:block xsl:use-attribute-sets="for last">
            <xsl:value-of select="$latestVersionDate"/>
        </fo:block>
        
        <!-- A4 Text -->
        <!-- SCOPE -->
        <fo:block xsl:use-attribute-sets="p"><fo:inline xsl:use-attribute-sets="bold">Scope:</fo:inline>&#160;&#8203;<xsl:value-of select="/quickscope/customer/full_name"/>&#160;&#8203;(hereafter “<fo:inline xsl:use-attribute-sets="bold"><xsl:value-of select="/quickscope/customer/short_name"/></fo:inline>”), with its registered offices at <xsl:value-of select="/quickscope/customer/address"/>, <xsl:value-of select="/quickscope/customer/postal_code"/>&#160;&#8203;<xsl:value-of select="/quickscope/customer/city"/>, <xsl:value-of select="/quickscope/customer/country"/>, has requested <xsl:value-of select="/quickscope/company/full_name"/> (hereafter “<fo:inline xsl:use-attribute-sets="bold"><xsl:value-of select="/quickscope/company/short_name"/></fo:inline>”) to <xsl:value-of select="/quickscope/meta/requested_service"/> on the following target<xsl:if test="/quickscope/meta/targets/target[2]">s</xsl:if>:</fo:block>
        
        <!-- TARGETS -->
        <xsl:call-template name="generate_targets_xslt"></xsl:call-template>
        
        <!-- TERMS -->
        <fo:block xsl:use-attribute-sets="p last">The ARBIT 2014 Terms and Conditions are applicable to this assignment.</fo:block>
        
        <!-- PLANNING & PAYMENT -->
        <fo:block xsl:use-attribute-sets="p"><fo:inline xsl:use-attribute-sets="bold">Planning &amp; Payment:</fo:inline>&#160;&#8203;<xsl:value-of select="/quickscope/company/short_name"/> shall perform a <xsl:value-of select="/quickscope/pentest_info/days"/>-day (<xsl:value-of select="/quickscope/pentest_info/days * 6"/> consulting hours), <xsl:value-of select="/quickscope/pentest_info/nature"/>, <xsl:value-of select="/quickscope/pentest_info/type"/> penetration test on the target<xsl:if test="/quickscope/meta/targets/target[2]">s</xsl:if> mentioned above.</fo:block>
        <fo:list-block xsl:use-attribute-sets="indented-list last">
      <fo:list-item xsl:use-attribute-sets="li">
            <fo:list-item-label end-indent="label-end()">
                <fo:block>&#8226;</fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    Pentesting will occur: <xsl:value-of select="/quickscope/pentest_info/planning"/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
            <fo:list-item xsl:use-attribute-sets="li">
            <fo:list-item-label end-indent="label-end()">
                <fo:block>&#8226;</fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    Pentest Report will be delivered: <xsl:value-of select="/quickscope/pentest_info/delivery"/>.
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
        </fo:list-block>
        
        <!-- FEE -->
        <fo:block xsl:use-attribute-sets="p">Our fixed-fee price quote for the above described penetration testing services is €<xsl:number value="$fee" grouping-separator="," grouping-size="3"/>, excl. VAT and out-of-pocket expenses incurred by <xsl:value-of select="/quickscope/company/short_name"/>, including but not limited to travel and accommodation. This reflects our fixed hourly rate of €<xsl:number value="$rate" grouping-separator="," grouping-size="3"/> for <xsl:value-of select="/quickscope/pentest_info/days"/> work days. <xsl:value-of select="/quickscope/company/short_name"/> will send an invoice after the completion of this assignment. <xsl:value-of select="/quickscope/customer/short_name"/> will pay the agreed amount within 30 days after the invoice date.</fo:block>
        <fo:block xsl:use-attribute-sets="p">Any additional services provided by <xsl:value-of select="/quickscope/company/short_name"/> will be billed separately. An hourly rate for additional services will be agreed upon before work begins.</fo:block>
        
        <!-- EXAMPLE & FAQ -->
        <fo:block xsl:use-attribute-sets="p" keep-with-next.within-page="always">A <fo:inline xsl:use-attribute-sets="bold">sample Pentest report</fo:inline>&#160;&#8203;can be found here:<fo:list-block xsl:use-attribute-sets="indented-list">
      <fo:list-item xsl:use-attribute-sets="li">
            <fo:list-item-label end-indent="label-end()">
                <fo:block>&#8226;</fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <fo:basic-link color="blue" external-destination="https://github.com/radicallyopensecurity/templates/blob/master/sample-
report/REP_SittingDuck-pentestreport-v10.pdf">https://github.com/radicallyopensecurity/templates/blob/master/sample-
report/REP_SittingDuck-pentestreport-v10.pdf</fo:basic-link>
                </fo:block>
            </fo:list-item-body>
      </fo:list-item>
        </fo:list-block> </fo:block>
        
        <fo:block xsl:use-attribute-sets="p" keep-with-next.within-page="always">Our page of <fo:inline xsl:use-attribute-sets="bold">Frequently Asked Questions (FAQs)</fo:inline>&#160;&#8203;can be found here: <fo:list-block xsl:use-attribute-sets="indented-list">
      <fo:list-item xsl:use-attribute-sets="li">
            <fo:list-item-label end-indent="label-end()">
                <fo:block>&#8226;</fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <fo:basic-link color="blue" external-destination="https://github.com/radicallyopensecurity/templates/blob/master/Offertes/FAQ.md">https://github.com/radicallyopensecurity/templates/blob/master/Offertes/FAQ.md</fo:basic-link>
                </fo:block>
            </fo:list-item-body>
      </fo:list-item>
        </fo:list-block></fo:block>
        
        <!-- CONTACT & SIGNATURE BOX -->
        <fo:block xsl:use-attribute-sets="p" keep-with-next.within-page="always">In order to agree to this offer, please sign this letter in duplicate and return it to:</fo:block>
        
        <fo:block xsl:use-attribute-sets="p indent">
            <fo:block><xsl:value-of select="/quickscope/company/legal_rep"/></fo:block>
            <fo:block><xsl:value-of select="/quickscope/company/full_name"/></fo:block>
            <fo:block><xsl:value-of select="/quickscope/company/address"/></fo:block>
            <fo:block><xsl:value-of select="/quickscope/company/postal_code"/>&#160;<xsl:value-of select="/quickscope/company/city"/></fo:block>
            <fo:block><xsl:value-of select="/quickscope/company/country"/></fo:block>
            <fo:block><fo:basic-link color="blue"><xsl:attribute name="external-destination">mailto:<xsl:value-of select="/quickscope/company/email"/></xsl:attribute><xsl:value-of select="/quickscope/company/email"/></fo:basic-link></fo:block>
        </fo:block>
        

<xsl:call-template name="generateSignatureBox">
    <xsl:with-param name="latestVersionDate"><xsl:value-of select="$latestVersionDate"/></xsl:with-param>
</xsl:call-template>
    </xsl:template>
    
    
</xsl:stylesheet>