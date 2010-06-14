<?xml version="1.0" encoding="utf-8"?>
<!--
	This stylesheet recursively group XHTML partial templates into a single
	self-contained so-called aggregated-template.
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xhtml="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" xmlns:bat="http://blogreen.org/TR/AggregatedTemplate" xmlns:xhtml="http://www.w3.org/1999/xhtml" version="1.0">
	<xsl:output type="text" />

	<xsl:include href="build-utils.xsl" />

	<xsl:param name="filename" />

	<xsl:template match="/">
		<xsl:call-template name="check-required-parameter">
			<xsl:with-param name="name" select="'filename'" />
			<xsl:with-param name="value" select="$filename" />
		</xsl:call-template>

		<xsl:call-template name="progress">
			<xsl:with-param name="filename" select="$filename" />
		</xsl:call-template>

		<xsl:document href="{$filename}" method="xml" indent="yes">
			<bat:templates>
				<xsl:apply-templates select="." mode="process" />
			</bat:templates>
		</xsl:document>
	</xsl:template>

	<xsl:template match="/" mode="process">
		<bat:template>
				<xsl:apply-templates select="node()|@*" mode="copy" />
		</bat:template>
		<xsl:if test="xhtml:html/xhtml:head/xhtml:meta[@name='extends']">
			<xsl:apply-templates select="document(concat($SRCDIR, '/templates/', xhtml:html/xhtml:head/xhtml:meta[@name='extends']/@content, '.xml'))" mode="process" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()|@*" mode="copy">
			<xsl:copy>
				<xsl:apply-templates mode="copy" select="node()|@*" />
			</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
