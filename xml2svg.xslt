<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
xmlns="http://www.w3.org/2000/svg">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/questionList">
	<svg width="1000" height="1000">
		<rect width="100%" height="100%" style="fill:rgb(245,245,245);stroke:rgb(0,0,0);stroke-width:0"/> <!-- bg creation -->
		
		<text id="header" x="100px" y ="40px" style="fill:rgb(0,0,0);font-size:18;font-family:Arial">SANITARY CONDITION OF WORKSHOPS AND FACTORIES</text>
		<!-- axis creation-->
        <g id="axis">
            <!-- y axis creation-->
			<line id="axis-y" x1="45" y1="70" x2="45" y2="465" style="fill:none;stroke:rgb(0,0,0);stroke-width:2"/>
            <!-- x axis creation-->
			<line id="axis-x" x1="45" y1="465" x2="645" y2="465" style="fill:none;stroke:rgb(0,0,0);stroke-width:2"/>
            <!-- axis percentages-->
			<text id="half" x="5px" y="27.5%" style="fill:rgb(0,0,0);font-size:14;font-family:Arial">50%</text>
            <text id="full" x="5px" y="7%" style="fill:rgb(0,0,0);font-size:14;font-family:Arial">100%</text>
		</g>
		<!-- legend creation -->
		<g id="legend">
            <!-- legend header-->
			<text x="700" y="150" style="fill:rgb(0,0,0);font-size:16;font-family:Arial">Legend: Survey Responses</text>
            <!-- legend choices-->
			<text x="750px" y="180px"  style="fill:rgb(0,0,0);font-size:18;font-family:Arial">Blank</text>
            <text x="750px" y="200px"  style="fill:rgb(0,0,0);font-size:18;font-family:Arial">No</text>
            <text x="750px" y="220px"  style="fill:rgb(0,0,0);font-size:18;font-family:Arial">Yes</text>
            <rect id="Blank" x="700px" y="168px" width="25" height="10" style="fill:rgb(135,135,135);stroke:rgb(0,0,0);stroke-width:1"/>
            <rect id="No" x="700px" y="188px" width="25" height="10" style="fill:rgb(250,10,10);stroke:rgb(0,0,0);stroke-width:1"/>
            <rect id="Yes" x="700px" y="208px" width="25" height="10" style="fill:rgb(100,200,0);stroke:rgb(0,0,0);stroke-width:1"/>
		</g>
		<!-- bar char creation; goes through each question sorted by the yes element-->
		<xsl:for-each select="question/answer[yes]">		
			<xsl:sort select="yes" order="descending"/>
			<xsl:variable  name="position" select="position()"/> <!-- variable to hold the position of elements; gets updated as the loop iterates through the elements-->
			<xsl:variable name="total" select="yes+no+blank"/> <!-- sum of yes,no and blank answers-->
			<xsl:variable name="margin" select="50"/> <!-- variable for the default margin-->
			<g>
            <!-- yes bars creation-->
			<rect x="{$position*$margin}" y="70" width="40" height="{yes div 2}" style="fill:rgb(100,200,0);stroke:rgb(0,0,0);stroke-width:0"/>
			<text x="{$position*$margin + 7}" y="{yes div 4 +70}" style="fill:rgb(0,0,0);font-size:12;font-family:Arial">
			<xsl:value-of select="round(yes div $total *100)"/>%</text> 
			</g>
			<g>
            <!-- no bars creation -->
			<rect x="{$position*$margin}" y="{(yes div 2) +50}" width="40" height="{no div 2}" style="fill:rgb(250,10,10);stroke:rgb(0,0,0);stroke-width:0"/>
			<text x="{$position*$margin + 7}" y="{yes div 2 +90}" style="fill:rgb(0,0,0);font-size:12;font-family:Arial">
			<xsl:value-of select="round(no div $total *100)"/>%</text> 
			</g>
			<g>
            <!-- blank bars creation-->
			<rect x="{$position*$margin}" y="{((yes+no) div 2)+50}" width="40" height="{blank div 2}" style="fill:rgb(135,135,135);stroke:rgb(0,0,0);stroke-width:0"/>
			<text x="{$position*$margin + 7}" y="{(yes+no) div 2 +85}" style="fill:rgb(0,0,0);font-size:12;font-family:Arial">
			<xsl:value-of select="round(blank div $total *100)"/>%</text> 
			</g>
			
		</xsl:for-each>
		<!-- position headings -->
		<xsl:for-each select="question[answer[yes]]">
            <xsl:sort select="question[answer[yes]]" order="descending"/>
			<xsl:variable name="position" select="position()"/>
			<text x="120" y="{($position -4)*49 -15}" transform="rotate(90 50,400)" style="text=anchor:middle;fill:rgb(0,0,0);font-size:10;font-family:Arial">
			Q
			<xsl:value-of select="position()"/>
			:
			</text>	
		</xsl:for-each>
		<!-- queries -->
		<xsl:for-each select="question">
			<xsl:sort select="answer[yes]"/>
			<xsl:variable name="position" select="position()"/>
			<text x="150" y="{($position -5)*49 -15}" transform="rotate(90 50,400)" style="text=anchor:middle;fill:rgb(0,0,0);font-size:10;font-family:Arial">
			<xsl:if test="answer/yes"> <!-- if it has a yes answer -->
			<xsl:value-of select="string(query)"/>
			</xsl:if>
			</text>	
		</xsl:for-each>
	</svg>
</xsl:template>
</xsl:stylesheet>
