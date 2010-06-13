<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bgn="http://blogreen.org" version="1.0">

	<!--
	Identity template
	-->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	
	<!--
	Do not copy bgn:* elements.  Plugins should catch it and add
	content.
	-->
	<xsl:template match="bgn:*" />

</xsl:stylesheet>
