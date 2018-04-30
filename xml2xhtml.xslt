<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
            <body>
                <xsl:variable name="index" select="1" />
                <h2>SANITARY CONDITION OF WORKSHOPS AND FACTORIES</h2> <!-- Top header of the html -->
                <h3>Table 1</h3>
                <table border="1"> <!-- Table 1 creation -->
                    <tr bgcolor="white">
                        <!--Table Header creation-->
                        <th style="text-align:left">Number</th>
                        <th style="text-align:centre">Question</th>
                        <th style="text-align:left">Yes</th>
                        <th style="text-align:left">No</th>
                        <th style="text-align:left">Blank</th>
                        <th style="text-align:left">Total</th>
                    </tr>
                    <!--Goes through all the quetion nodes -->
                    <xsl:for-each select="questionList/question">
                        <xsl:if test="answer/yes > 0"> <!-- if the question is of "type" Yes/No/Blank then-->
                            <tr>
                                <xsl:if test="answer/blank != 198"> <!-- if it's not the 13 question node -->
                                    <td>
                                        <xsl:value-of select="position()" /> <!-- get the position of each node and put that in the number column-->
                                    </td>
                                </xsl:if>
                                <xsl:if test="answer/blank = 198"> <!-- if it is the 13th node then-->
                                    <td>
                                        <xsl:value-of select="position()-1" /> <!-- set number as 12 -->
                                    </td>
                                </xsl:if>
                                <td>
                                    <xsl:value-of select="query" /> <!-- gets the query value-->
                                </td>
                                <td>
                                    <xsl:value-of select="answer/yes" /> <!-- gets the value of yes element-->
                                </td>
                                <td>
                                    <xsl:value-of select="answer/no" /> <!-- gets the value of no element -->
                                </td>
                                <td>
                                    <xsl:value-of select="answer/blank" /> <!-- gets the value of blank element -->
                                </td>
                                <td>
                                    <xsl:value-of select="answer/blank + answer/no + answer/yes" /> <!-- sum of yes, no and blank and put that at the total column -->
                                </td>
                                
                            </tr>
                            
                        </xsl:if>
                        
                    </xsl:for-each>
                <!--Second table creattion -->
                </table>
                <h4>Table 2</h4>
                <table border="1">
                    <tr bgcolor="white">
                        <th style="text-align:centre">Question</th>
                        <th style="text-align:left">Sit</th>
                        <th style="text-align:left">Stand</th>
                        <th style="text-align:left">Blank</th>
                        <th style="text-align:left">Optional</th>
                        <th style="text-align:left">Total</th>
                    </tr>
                    <xsl:for-each select="questionList/question[12]"> <!-- just goes through the 12th question node (sit/stand/blank/optional-->
                        <tr>
                            <td>
                                <xsl:value-of select="query" /> <!-- gets the query value-->
                            </td>
                            <td>
                                <xsl:value-of select="answer/sit" /> <!-- gets the value of sit element-->
                            </td>
                            
                            <td>
                                <xsl:value-of select="answer/stand" /> <!-- gets the value of stand element -->
                            </td>
                            <td>
                                <xsl:value-of select="answer/blank" /> <!-- gets the value of blank element -->
                            </td>
                            <td>
                                <xsl:value-of select="answer/optional" /> <!-- gets the value of optional element -->
                            </td>
                            <td>
                                <xsl:value-of select="answer/blank + answer/stand + answer/sit + answer/optional" />
                                <!--sum of sit, stand , blank and optional values -->
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
