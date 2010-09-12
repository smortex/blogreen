<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:res="http://blogreen.org/TR/Resources" xmlns:bgn="http://blogreen.org" version="1.0">


	<xsl:template match="*" mode="plugin-navigation">
		<xsl:param name="root" select="'res:resources'" />
		<xsl:param name="display-root" select='no' />
		<xsl:param name="root-label" />
		<xsl:variable name="uri" select="@uri" />

		<!-- FIXME The way to select what to bind on the menu. er.. sucks -->
		<xsl:for-each select="ancestor-or-self::*[name(.) = $root]">

			<xsl:if test="$display-root = 'yes'">
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:value-of select="@uri" /></xsl:attribute>
					<xsl:attribute name="class">
						<xsl:text>menu-item</xsl:text>
						<xsl:if test="$uri = @uri">
							<xsl:text> selected</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="$root-label">
							<xsl:value-of select="$root-label" />
						</xsl:when>
						<xsl:otherwise>
						<xsl:apply-templates select="/res:resources" mode="title" />
						</xsl:otherwise>
					</xsl:choose>
					</xsl:element>
					<bgn:navigation-separator />
			</xsl:if>

			<xsl:for-each select="res:*[@uri]">
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
					<bgn:navigation-separator />
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
