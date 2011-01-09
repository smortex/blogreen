<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" version="1.0">


	<xsl:template match="*" mode="plugin-breadcrumbs">
		<xsl:param name="display-root" select="'yes'" />
		<xsl:param name="root-label" />

		<xsl:if test="../@uri">
			<span class="path">
				<xsl:apply-templates select=".." mode="private-plugin-breadcrumbs-link">
					<xsl:with-param name="display-root" select="$display-root" />
					<xsl:with-param name="root-label" select="$root-label" />
				</xsl:apply-templates>
			</span>
		</xsl:if>
		<xsl:if test="../@uri or $display-root = 'yes'">
			<bgn:breadcrumbs-selected>
				<xsl:choose>
					<xsl:when test="../@uri or not($root-label)">
						<xsl:apply-templates select="." mode="title-short">
							<xsl:with-param name="context">
								<xsl:value-of select="plugin-breadcrumbs" />
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$root-label" />
					</xsl:otherwise>
				</xsl:choose>
			</bgn:breadcrumbs-selected>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="private-plugin-breadcrumbs-link">
		<xsl:param name="display-root" />
		<xsl:param name="root-label" />

		<xsl:if test="../@uri">
			<xsl:apply-templates select=".." mode="private-plugin-breadcrumbs-link">
				<xsl:with-param name="display-root" select="$display-root" />
				<xsl:with-param name="root-label" select="$root-label" />
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test="../@uri or $display-root = 'yes'">
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of select="@uri" />
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="../@uri or not($root-label)">
						<xsl:apply-templates select="." mode="title-short">
							<xsl:with-param name="context">
								<xsl:value-of select="plugin-breadcrumbs" />
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$root-label">
						<xsl:value-of select="$root-label" />
					</xsl:when>
				</xsl:choose>
			</xsl:element>

			<bgn:breadcrumbs-separator />
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
