<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" xmlns:res="http://blogreen.org/TR/Resources" version="1.0">

	<xsl:template match="*" mode="title">
		<xsl:param name="context" />

		<xsl:message>WARNING: No specialised 'title' template for entity '<xsl:value-of select="name()" />'.</xsl:message>
		<xsl:value-of select="concat('&lt;xsl:template match=&quot;',name(), '&quot; mode=&quot;title&quot; />')" />
	</xsl:template>

	<xsl:template name="no-template-for-placeholder">
		<xsl:param name="placeholder" />

		<xsl:message terminate="no">WARNING: No specialised '<xsl:value-of select="$placeholder" />' template for node '<xsl:value-of select="name(.)" />'.</xsl:message>
		<div style="border: 1px solid #f00; padding: 1ex 3ex; color: #f00; background-color: #fff8f8;">
			<p><strong>Warning</strong>: No specialised <q><xsl:value-of select="$placeholder" /></q> template for node <q><xsl:value-of select="name(.)" /></q>.</p>
			<pre><![CDATA[<xsl:template match="]]><xsl:value-of select="name(.)" /><![CDATA[" mode="]]><xsl:value-of select="$placeholder" /><![CDATA[">
</xsl:template>]]></pre>
		</div>
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
