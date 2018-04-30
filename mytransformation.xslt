<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    <xsl:template match="/">
        <html>
            <body>
                <xsl:variable name="index" select="1" />
                <h2>SANITARY CONDITION OF WORKSHOPS AND FACTORIES</h2> <!-- Top header of the html -->
                <h3>Table 1</h3>
                <table border="1" bgcolor="white"> <!-- Table 1 creation -->
                    <tr bgcolor="cyan">
                        <!--Table Header creation-->
                        <th style="text-align:left">Number</th>
                        <th style="text-align:centre">Question</th>
                        <th style="text-align:left">Yes</th>
                        <th style="text-align:left">No</th>
                        <th style="text-align:left">Blank</th>
                        <th style="text-align:left">Total</th>
                        <th style="text-align:left">Comment ID</th>
                    </tr>
                    <!--Goes through all the question nodes -->
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
                                <td>
                                    <xsl:if test="comment">
                                        <xsl:value-of select="comment/@id"/>
                                    </xsl:if>
                                    <xsl:if test="not(comment)">
                                        <text>No comment</text>
                                    </xsl:if>
                                    
                                </td>
                                
                            </tr>
                            
                        </xsl:if>
                        
                    </xsl:for-each>
                <!--Second table creation -->
                </table>
                <h4>Table 2</h4>
                <table border="1">
                    <tr bgcolor="cyan">
                        <th style="text-align:centre">Question</th>
                        <th style="text-align:left">Sit</th>
                        <th style="text-align:left">Stand</th>
                        <th style="text-align:left">Blank</th>
                        <th style="text-align:left">Optional</th>
                        <th style="text-align:left">Total</th>
                        <th style="text-align:left">Comment ID</th>
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
                            <td>
                                <xsl:value-of select="comment/@id"/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
                <!-- Third table creation-->
                <h4>Table 3</h4>
                <table border="1" bgcolor="white">
                	<tr bgcolor="cyan">
                        <th style="text-align:left">Comment ID</th>
                		<th style="text-align:centre">Comments</th>
                	</tr>
           
                    <!-- goes through the xml element and gets the comments id and content -->
                	<xsl:for-each select="questionList/question/comment">
                        
                        <tr>
                            <td>
                                <xsl:value-of select="@id"/>
                            </td>
                            <td>
                                <xsl:value-of select="content"/>
                            </td>
                            
                        </tr>
                    </xsl:for-each>

                </table>
                <xsl:variable name="yesSum"> <!-- sum of all the yes answers-->
                            <xsl:value-of select="sum(//yes)"/>
                </xsl:variable>
                <xsl:variable name="noSum"> <!-- sum of all the no answers-->
                    <xsl:value-of select="sum(//no)"/>
                </xsl:variable>
                <xsl:variable name="blankSum"> <!-- sum of all the blank answers-->
                    <xsl:value-of select="sum(//blank)"/>
                </xsl:variable>
                <xsl:variable name="totalSum"> <!-- total sum of all answers within the xml -->
                    <xsl:value-of select="sum(//yes) + sum(//no) + sum(//blank) + sum(//optional) + sum(//stand) + sum(//sit)"/>
                </xsl:variable>
                <xsl:variable name="othersSum">
                    <xsl:value-of select="$totalSum - $yesSum - $noSum - $blankSum"/>
                </xsl:variable>
                <!-- Fourth table creation -->
                <h4>Table 4</h4>
                <table border="1" bgcolor="white">
                    <tr bgcolor="cyan">
                        <th style="text-align:left">Number of people that answered "Yes"</th>
                        <th style="text-align:left">Number of people that answered "No"</th>
                        <th style="text-align:left">Number of people that didn't provide an answer</th>
                        <th style="text-align:left">Number of total answers</th>
                    </tr>
                    <tr>
                        <td>
                            <xsl:value-of select="$yesSum"/>
                        </td>
                        <td>
                            <xsl:value-of select="$noSum"/>
                        </td>
                        <td>
                            <xsl:value-of select="$blankSum"/>
                        </td>
                        <td>
                            <xsl:value-of select="$totalSum"/>
                        </td>
                    </tr>
                    <tr bgcolor="cyan">
                        <th style="text-align:left">Percentage of people that answered "Yes"</th>
                        <th style="text-align:left">Percentage of people that answered "No"</th>
                        <th style="text-align:left">Percentage of people that didn't'answer</th>
                        <th style="text-align:left">Percentage of other answers</th>
                    </tr>
                    <tr>
                        <td>
                            <xsl:value-of select="round($yesSum div $totalSum * 100)"></xsl:value-of>%
                        </td>
                        <td>
                            <xsl:value-of select="round($noSum div $totalSum * 100)"></xsl:value-of>%
                        </td>
                        <td>
                            <xsl:value-of select="round($blankSum div $totalSum * 100)"></xsl:value-of>%
                        </td>
                        <td>
                            <xsl:value-of select="round($othersSum div $totalSum * 100)"></xsl:value-of>%
                        </td>
                    </tr>
                    
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
