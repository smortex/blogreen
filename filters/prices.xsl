<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" version="1.0">

	<xsl:include href="../core/string-utils.xsl" />

	<!--

	<xsl:param name="currency" select="'€'" />
	<xsl:param name="LC_MONETARY" />

	<bgn:price [vat="included|not-included"]>value</bgn:price>

	Parameters:
							currency (string)
							Default: '€'

							LC_MONETARY (string)
							Default: 'en'
	Attributes:
							vat="included|not-included"
							Default: not set

	Value:
							Price to format


  <bgn:price>10</bgn:price>
	€ 10
  <bgn:price>10.00</bgn:price>
	€ 10.00

	-->

	<!--
	FIXME: Read i18n is missing.
	  - Add format strings in the -i18n.xml file and use them (see
		  date-time fomatting).
	-->
	<xsl:param name="currency" select="'€'" />
	<xsl:param name="LC_MONETARY" select="'C'" />

	<xsl:decimal-format name="en" decimal-separator="." grouping-separator="," />
	<xsl:decimal-format name="fr" decimal-separator="," grouping-separator="&#160;" />

	<xsl:template match="bgn:price">
		<xsl:choose>
			<xsl:when test="starts-with($LC_MONETARY, 'en')">
				<xsl:variable name="format">
					<xsl:text>###,###</xsl:text>
					<xsl:if test="contains(text(), '.')">
						<xsl:text>.00</xsl:text>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="concat($currency, ' ', format-number(text(), $format, substring($LC_MONETARY, 1, 2)))" />
			</xsl:when>
			<xsl:when test="starts-with($LC_MONETARY, 'fr')">
				<xsl:variable name="format">
					<xsl:value-of select="concat('###',$unbreakable-space,'###')" />
					<xsl:if test="contains(text(), '.')">
						<xsl:text>,00</xsl:text>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="concat(format-number(text(), $format, substring($LC_MONETARY, 1, 2)),' ', $currency)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">ERROR: Don't know how to format prices for LC_MONETARY="<xsl:value-of select="$LC_MONETARY" />".</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
			<xsl:if test="@vat">
				<xsl:value-of select="$unbreakable-space" />
				<xsl:choose>
					<xsl:when test="@vat = 'included'">
						<xsl:value-of select="document('prices-i18n.xml')/i18n/prices[lang = $LC_MONETARY]/vat-included" />
					</xsl:when>
					<xsl:when test="@vat = 'not-included'">
						<xsl:value-of select="document('prices-i18n.xml')/i18n/prices[lang = $LC_MONETARY]/vat-not-included" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:message terminate="yes">ERROR: Valid VAT values are 'included' and 'not-included' (found <xsl:value-of select="@vat" />).</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

	</xsl:template>

</xsl:stylesheet>
