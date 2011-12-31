<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:bgn="http://blogreen.org" xmlns:xhtml="http://www.w3.org/1999/xhtml">

	<xsl:template match="xhtml:script[@type = 'text/javascript']">
		<xsl:element name="{name(.)}">
			<xsl:apply-templates select="@*" />
			<xsl:text disable-output-escaping="yes">
// &lt;![CDATA[
</xsl:text>
			<xsl:apply-templates select="*|text()" />
			<xsl:text disable-output-escaping="yes">
// ]]&gt;
</xsl:text>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
