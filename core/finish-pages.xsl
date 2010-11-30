<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgn="http://blogreen.org" xmlns:c="http://blogreen.org/TR/Config" version="1.0">

	<xsl:param name="uri" />

	<!--
	Ensure XHTML elements have a start-tag and a end-tag unless they can
	be self-closed (see bellow).
	-->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
			<xsl:comment />
		</xsl:copy>
	</xsl:template>

	<!--
	Some XHTML elements can be self-closed so only copy their
	attributes.
	-->
	<xsl:template match="xhtml:br|xhtml:hr|xhtml:img|xhtml:input|xhtml:link|xhtml:meta">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template name="self-uri">
		<xsl:value-of select="document(concat($SRCDIR, '/config.xml'))/c:config/c:RootUri" />
		<xsl:value-of select="$uri" />
	</xsl:template>
	<xsl:template match="bgn:self">
		<xsl:call-template name="self-uri" />
	</xsl:template>
	
	<!--
	Do not copy bgn:* elements.  Plugins should catch it and add
	content.
	-->
	<xsl:template match="bgn:*">
		<xsl:param name="warn" />
		<xsl:if test="not(@warn = 'no')">
			<xsl:if test="$warn = 'yes'">
				<xsl:message>Unhandled &lt;<xsl:value-of select="name(.)" />&gt;. Are you missing a plugin reference?</xsl:message>
			</xsl:if>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
