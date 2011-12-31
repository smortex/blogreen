<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" xmlns:c="http://blogreen.org/TR/Config" xmlns="http://www.w3.org/1999/xhtml" version="1.0">

	<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

	<xsl:include href="build-utils.xsl" />

	<xsl:param name="filename" />

	<xsl:template match="/">

		<xsl:call-template name="check-required-parameter">
			<xsl:with-param name="name" select="'filename'" />
			<xsl:with-param name="value" select="$filename" />
		</xsl:call-template>

		<xsl:call-template name="progress">
			<xsl:with-param name="filename" select="$filename" />
		</xsl:call-template>

		<xsl:document href="{$filename}" method="xml" indent="yes">
			<axsl:stylesheet version="1.0" xmlns:bgn="http://blogreen.org" xmlns:xhtml="http://www.w3.org/1999/xhtml">
				<axsl:import href="{$BLOGREEN}/finish-pages.xsl" />

				<!-- Load plugin filters -->
				<xsl:for-each select="//c:filters/c:filter">
					<xsl:choose>
						<xsl:when test="@scope = 'system'">
							<axsl:import href="{$BLOGREEN}/../filters/{@name}.xsl" />
						</xsl:when>
						<xsl:when test="@scope = 'user'">
							<axsl:import href="{$SRCDIR}/filters/{@name}.xsl" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="error">
								<xsl:with-param name="message">
									<xsl:text>The filter '</xsl:text>
									<xsl:value-of select="@name" />
									<xsl:text>' has an unexpected scope '</xsl:text>
									<xsl:value-of select="@scope" />
									<xsl:text>' (expected 'system' or 'user').</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>

				<axsl:include href="{$BLOGREEN}/build-utils.xsl" />

				<axsl:param name="filename" />

				<!--
				Specify both axsl: prefix (TransformAlias) and namespace
				(Transform).  This weird combinaison work-around a xsltproc
				bug / inconsistent behaviour and produce the output element in
				the Transform namespace in the resulting fragment.
				-->
				<xsl:element name="axsl:output" namespace="http://www.w3.org/1999/XSL/Transform">
					<xsl:attribute name="method">text</xsl:attribute>
					<xsl:if test="/c:config/c:cdata-section-elements">
						<!--
						Because of a limitation in xslproc, cdata-section-elements
						can be set ONLY at the beginning of a stylesheet and not
						when creating a document.  For this reason, we set this
						attribute here, while we define the output as being plain
						text (website construction progress diagnostic).
						-->
						<xsl:attribute name="cdata-section-elements">
							<xsl:value-of select="/c:config/c:cdata-section-elements" />
						</xsl:attribute>
					</xsl:if>
				</xsl:element>

				<axsl:template match="/">
					<axsl:call-template name="check-required-parameter">
						<axsl:with-param name="name" select="'filename'" />
						<axsl:with-param name="value" select="$filename" />
					</axsl:call-template>

					<axsl:call-template name="progress">
						<axsl:with-param name="filename" select="$filename" />
					</axsl:call-template>

					<axsl:choose>
						<axsl:when test="/xhtml:html">
							<axsl:document href="{{$filename}}" method="xml" indent="yes" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
								<axsl:copy>
									<axsl:apply-templates select="*" />
								</axsl:copy>
							</axsl:document>
						</axsl:when>
						<axsl:when test="/xhtml:div[@id='raw-content']">
							<axsl:document href="{{$filename}}" method="text" indent="no">
								<axsl:apply-templates select="*" />
							</axsl:document>
						</axsl:when>
						<axsl:otherwise>
							<axsl:document href="{{$filename}}" method="xml" indent="yes">
								<axsl:copy>
									<axsl:apply-templates select="*" />
								</axsl:copy>
							</axsl:document>
						</axsl:otherwise>
					</axsl:choose>
				</axsl:template>

				<axsl:template match="@*|node()">
					<axsl:if test="not((@class = 'drop-if-empty') and not (node()) or name(.) = 'class' and . = 'drop-if-empty' )">
						<axsl:apply-imports />
					</axsl:if>
				</axsl:template>

				<axsl:template match="bgn:body-onload">
					<axsl:variable name="onload-list"><axsl:apply-imports /></axsl:variable>

					<axsl:if test="$onload-list != ''">
						<axsl:attribute name="onload">javascript: <axsl:value-of select="$onload-list" /></axsl:attribute>
					</axsl:if>
				</axsl:template>
			</axsl:stylesheet>
		</xsl:document>

	</xsl:template>

</xsl:stylesheet>
