<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:res="http://blogreen.org/TR/Resources" version="1.0">


	<xsl:template match="*" mode="plugin-main-navigation">
		<xsl:param name="display-root" select='no' />
			<xsl:if test="$display-root = 'yes'">
					<xsl:element name="a">
						<xsl:attribute name="href">/</xsl:attribute>
						<xsl:apply-templates select="/res:resources" mode="title" />
					</xsl:element>
					<xsl:text> | </xsl:text>
			</xsl:if>
			<xsl:for-each select="/res:resources/res:*[@uri]">
				<xsl:sort data-type="number" select="@order" />
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="@uri" />
					</xsl:attribute>
					<xsl:apply-templates select="." mode="title" />
				</xsl:element>
				<xsl:if test="not(position() = last())">
					<xsl:text> | </xsl:text>
				</xsl:if>
			</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
