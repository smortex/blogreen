<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" version="1.0">


	<xsl:template match="*" mode="plugin-breadcrumbs">
		<xsl:param name="context" />
		<xsl:param name="root-label" />

				<xsl:if test="../@uri">
					<span class="path">
						<xsl:apply-templates select=".." mode="private-plugin-breadcrumbs-link" />
					</span>
				</xsl:if>
				<bgn:breadcrumbs-selected>
					<xsl:apply-templates select="." mode="title-short">
						<xsl:with-param name="context">
							<xsl:value-of select="plugin-breadcrumbs" />
						</xsl:with-param>
					</xsl:apply-templates>
				</bgn:breadcrumbs-selected>
	</xsl:template>

	<xsl:template match="*" mode="private-plugin-breadcrumbs-link">
		<xsl:param name="context" />

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

			<bgn:breadcrumbs-separator />
	</xsl:template>

</xsl:stylesheet>
