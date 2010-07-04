<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" xmlns:hcard="http://microformats.org/profile/hcard" version="1.0">

	<!--
	TODO: Cleanup required:
	      - Allow more tan one map in a page;
				- Pick bubble info from the bgn:google-map element and not
				  from any other hCard in the page.
	-->

	<xsl:template match="bgn:page-javascript">
		<xsl:apply-imports />
		<xsl:if test="//bgn:google-map">
			<!--
			TODO: Read key from configuration
			-->
			<xsl:element name="script">
				<xsl:attribute name="type">text/javascript</xsl:attribute>
				<xsl:attribute name="src">http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=<xsl:value-of select="'ABQIAAAAOJwILudhgqQIVD2XSjGdsxQTAK8myc1BOYGDdZVDdt4JA65VsRSncpDRHNsJA_7F-kFuQe-bvt5dfg'" />&amp;hl=<xsl:value-of select="$LC_MESSAGES" /></xsl:attribute>
				<xsl:comment />
			</xsl:element>
			<script type="text/javascript"><xsl:comment><![CDATA[
function foo() {

	if (GBrowserIsCompatible()) {
		var e = document.getElementById("map");
		var map = new GMap2(document.getElementById("map"));
		map.setCenter(new GLatLng(]]><xsl:value-of select="//bgn:google-map/@latitude" />,<xsl:value-of select="//bgn:google-map/@longitude" /><![CDATA[), 5);

		var point = map.getCenter();

		var marker = new GMarker(point, {});
		GEvent.addListener(marker, "click", function() {
		marker.openInfoWindowHtml("<strong>]]><xsl:copy-of select="//xhtml:div[@class='vcard']/*[@class='fn']" /><![CDATA[</strong>");
		});
		map.addOverlay(marker);
		map.setUIToDefault();
		//e.style.width = '0';
		// $('map').morph('width: 300px;');
	}
}
//]]></xsl:comment></script>
		</xsl:if>
	</xsl:template>

	<xsl:template match="bgn:body-onload">
		<xsl:if test="//bgn:google-map">
			<xsl:text>foo();</xsl:text>
		</xsl:if>
		<xsl:apply-imports />
	</xsl:template>

	<xsl:template match="bgn:google-map">
		<xsl:element name="div">
			<xsl:attribute name="id">map</xsl:attribute>
			<xsl:comment />
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
