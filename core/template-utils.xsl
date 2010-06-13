<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgn="http://blogreen.org" version="1.0">

	<xsl:template match="*" mode="title">
		<xsl:param name="context" />

		<xsl:message>WARNING: No specialised 'title' template for entity '<xsl:value-of select="name()" />'.</xsl:message>
		<xsl:value-of select="concat('&lt;xsl:template match=&quot;',name(), '&quot; mode=&quot;title&quot; />')" />
	</xsl:template>

	<xsl:template match="*" mode="title-short">
		<xsl:param name="context" />

		<xsl:apply-templates select="." mode="title">
			<xsl:with-param name="context">
				<xsl:value-of select="context" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="title-long">
		<xsl:param name="context" />

		<xsl:apply-templates select="." mode="title">
			<xsl:with-param name="context">
				<xsl:value-of select="context" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="bgn:page-javascript">
		Hello
	</xsl:template>

</xsl:stylesheet>
