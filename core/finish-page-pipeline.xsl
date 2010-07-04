<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" version="1.0">

	<xsl:import href="finish-pages.xsl" />

	<xsl:import href="../filters/date-time.xsl" />
	<xsl:import href="../filters/lightbox2.xsl" />
	<xsl:import href="../filters/prices.xsl" />

	<xsl:include href="build-utils.xsl" />


	<xsl:param name="filename" />

	<xsl:output method="text" />

	<xsl:template match="/">
			<xsl:call-template name="check-required-parameter">
				<xsl:with-param name="name" select="'filename'" />
				<xsl:with-param name="value" select="$filename" />
			</xsl:call-template>

			<xsl:call-template name="progress">
				<xsl:with-param name="filename" select="$filename" />
			</xsl:call-template>

			<xsl:document href="{$filename}" method="xml" indent="yes" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" >
				<xsl:copy>
					<xsl:apply-templates select="*" />
				</xsl:copy>
			</xsl:document>
	</xsl:template>

	<!--
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	-->
	<xsl:template match="@*|node()">
		<xsl:if test="not((@class = 'drop-if-empty') and not (node()) or name(.) = 'class' and . = 'drop-if-empty' )">
			<xsl:apply-imports />
		</xsl:if>
	</xsl:template>

	<xsl:template match="bgn:body-onload">
		<xsl:variable name="onload-list"><xsl:apply-imports /></xsl:variable>

		<xsl:if test="$onload-list != ''">
			<xsl:attribute name="onload">javascript: <xsl:value-of select="$onload-list" /></xsl:attribute>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
