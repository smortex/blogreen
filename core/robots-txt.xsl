<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:res="http://blogreen.org/TR/Resources" xmlns:c="http://blogreen.org/TR/Config" version="1.0">
	<xsl:output method="text" />

	<xsl:include href="build-utils.xsl" />
	<xsl:include href="string-utils.xsl" />

	<xsl:param name="filename" select="concat($PUBDIR, '/robots.txt')" />

	<xsl:param name="root-uri">
		<xsl:value-of select="document(concat($SRCDIR, '/config.xml'))/c:config/c:RootUri" />
	</xsl:param>

	<xsl:template match="/res:resources">
		<xsl:call-template name="check-required-parameter">
			<xsl:with-param name="name" select="'filename'" />
			<xsl:with-param name="value" select="$filename" />
		</xsl:call-template>

		<xsl:call-template name="progress">
			<xsl:with-param name="filename" select="$filename" />
		</xsl:call-template>

		<xsl:document href="{$filename}" method="text">
			<xsl:text>Sitemap: </xsl:text>
			<xsl:value-of select="concat($root-uri, '/sitemap.xml', $new-line)" />

			<!--
			TODO: Handle Disallows
			-->
		</xsl:document>
	</xsl:template>

</xsl:stylesheet>
