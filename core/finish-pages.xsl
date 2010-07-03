<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgn="http://blogreen.org" version="1.0">

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
	
	<!--
	Do not copy bgn:* elements.  Plugins should catch it and add
	content.
	-->
	<xsl:template match="bgn:*" />

</xsl:stylesheet>
