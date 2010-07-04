<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="http://blogreen.org/TR/DateTime" version="1.0">

	<xsl:param name="LC_TIME" select="'C'" />

	<xsl:key name="i18n-date-time" match="date-time" use="lang" />

	<xsl:template match="dt:date">

		<xsl:call-template name="strftime">
			<xsl:with-param name="format">
				<xsl:for-each select="document('date-time-i18n.xml')">
					<xsl:value-of select="key('i18n-date-time', $LC_TIME)/format" />
				</xsl:for-each>
			</xsl:with-param>
			<xsl:with-param name="date">
				<xsl:value-of select="text()" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="date-time-get-yyyy">
		<xsl:param name="date" />
		<xsl:value-of select="substring($date, 1, 4)" />
	</xsl:template>
	<xsl:template name="date-time-get-mm">
		<xsl:param name="date" />
		<xsl:value-of select="substring($date, 6, 2)" />
	</xsl:template>
	<xsl:template name="date-time-get-dd">
		<xsl:param name="date" />
		<xsl:value-of select="substring($date, 9, 2)" />
	</xsl:template>

	<xsl:template name="strftime">
		<xsl:param name="date" />
		<xsl:param name="format" />

		<xsl:choose>
			<xsl:when test="starts-with($format, '%')">
				<xsl:choose>
					<xsl:when test="starts-with($format, '%B')">
						<xsl:variable name="mm">
							<xsl:call-template name="date-time-get-mm">
								<xsl:with-param name="date" select="$date" />
							</xsl:call-template>
						</xsl:variable>

						<xsl:for-each select="document('date-time-i18n.xml')">
							<xsl:value-of select="key('i18n-date-time', $LC_TIME)/month[position() = number($mm)]" />
						</xsl:for-each>

					</xsl:when>
					<xsl:when test="starts-with($format, '%d')">
						<xsl:call-template name="date-time-get-dd">
							<xsl:with-param name="date" select="$date" />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="starts-with($format, '%e')">
						<xsl:variable name="dd">
							<xsl:call-template name="date-time-get-dd">
								<xsl:with-param name="date" select="$date" />
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="number($dd)" />
					</xsl:when>
					<xsl:when test="starts-with($format, '%m')">
						<xsl:call-template name="date-time-get-mm">
							<xsl:with-param name="date" select="$date" />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="starts-with($format, '%Y')">
						<xsl:call-template name="date-time-get-yyyy">
							<xsl:with-param name="date" select="$date" />
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message terminate="yes">Unsuported conversion specifications « <xsl:value-of select="substring($format, 1, 2)" /> »</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="strftime">
					<xsl:with-param name="date" select="$date" />
					<xsl:with-param name="format" select="substring ($format, 3)" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length($format)">
					<xsl:value-of select="substring ($format, 1, 1)" />
					<xsl:call-template name="strftime">
						<xsl:with-param name="date" select="$date" />
						<xsl:with-param name="format" select="substring ($format, 2)" />
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
