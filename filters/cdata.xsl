<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:bgn="http://blogreen.org">

	<xsl:template match="*[@bgn:cdata = 'yes']">
		<xsl:element name="{name(.)}">
			<xsl:for-each select="@*">
				<xsl:if test="not (name(.) = 'bgn:cdata')">
					<xsl:copy-of select="." />
				</xsl:if>
			</xsl:for-each>
			<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
			<xsl:apply-templates select="*|text()" />
			<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
