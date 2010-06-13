<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">


	<xsl:template match="*" mode="plugin-breadcrumbs">
		<xsl:param name="context" />
		<xsl:param name="root-label" />

		<div class="breadcrumbs">
			<xsl:choose>
				<xsl:when test="not(@uri = '/')">
					<span class="path">
						<a href="/"><xsl:value-of select="$root-label" /></a>
						<xsl:text> → </xsl:text>
						<xsl:apply-templates select=".." mode="private-plugin-breadcrumbs-link" />
					</span>
					<h1>
						<xsl:apply-templates select="." mode="title-short">
							<xsl:with-param name="context">
								<xsl:value-of select="plugin-breadcrumbs" />
							</xsl:with-param>
						</xsl:apply-templates>
					</h1>
				</xsl:when>
				<xsl:otherwise>
					<h1><xsl:value-of select="$root-label" /></h1>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="*" mode="private-plugin-breadcrumbs-link">
		<xsl:param name="context" />

		<xsl:if test="@uri">
			<xsl:if test="../@uri">
				<xsl:apply-templates select=".." mode="private-plugin-breadcrumbs-link">
				</xsl:apply-templates>
			</xsl:if>

			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of select="@uri" />
				</xsl:attribute>
				<xsl:apply-templates select="." mode="title-short">
					<xsl:with-param name="context">
						<xsl:value-of select="plugin-breadcrumbs" />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:element>

			<xsl:text> → </xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
