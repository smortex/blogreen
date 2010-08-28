<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:res="http://blogreen.org/TR/Resources" xmlns:bgn="http://blogreen.org" version="1.0">


	<xsl:template match="*" mode="plugin-main-navigation">
		<xsl:param name="display-root" select='no' />
		<xsl:variable name="uri" select="@uri" />
			<xsl:if test="$display-root = 'yes'">
					<xsl:element name="a">
						<xsl:attribute name="href">/</xsl:attribute>
					<xsl:attribute name="class">
						<xsl:text>menu-item</xsl:text>
						<xsl:if test="@uri = '/'">
							<xsl:text> selected</xsl:text>
						</xsl:if>
					</xsl:attribute>
						<xsl:apply-templates select="/res:resources" mode="title" />
					</xsl:element>
					<bgn:main-navigation-separator />
			</xsl:if>
			<xsl:for-each select="/res:resources/res:*[@uri]">
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="@uri" />
					</xsl:attribute>
					<xsl:attribute name="class">
						<xsl:text>menu-item</xsl:text>
						<xsl:if test="starts-with($uri, @uri)">
							<xsl:text> selected</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:apply-templates select="." mode="title" />
				</xsl:element>
				<xsl:if test="not(position() = last())">
					<bgn:main-navigation-separator />
				</xsl:if>
			</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
