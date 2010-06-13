<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">


	<xsl:template match="*" mode="plugin-main-navigation">
		<p>
			<!--
			<xsl:for-each select="document(concat($OBJDIR, '/sitemap.xml'))/sitemap/url[not(contains(substring-after(@uri, '/'), '/'))]">
				-->
				<xsl:for-each select="//*[@uri and not(contains(substring-after(@uri, '/'), '/'))]">
				<xsl:sort data-type="number" select="@order" />
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="@uri" />
					</xsl:attribute>
					<xsl:apply-templates select="." mode="title" />
					<!--
					<xsl:value-of select="text()" />
					-->
				</xsl:element>
				<xsl:if test="not(position() = last())">
					<xsl:text> | </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</p>
	</xsl:template>
</xsl:stylesheet>
