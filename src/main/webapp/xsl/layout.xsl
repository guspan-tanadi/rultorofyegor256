<?xml version="1.0"?>
<!--
 * Copyright (c) 2009-2014, rultor.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met: 1) Redistributions of source code must retain the above
 * copyright notice, this list of conditions and the following
 * disclaimer. 2) Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided
 * with the distribution. 3) Neither the name of the rultor.com nor
 * the names of its contributors may be used to endorse or promote
 * products derived from this software without specific prior written
 * permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 * NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" version="2.0" exclude-result-prefixes="xs">
    <xsl:include href="./common.xsl"/>
    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <xsl:apply-templates select="page"/>
    </xsl:template>
    <xsl:template match="page">
        <html lang="en">
            <head>
                <meta charset="UTF-8"/>
                <meta name="description" content="Programmable Enforcer of a Software Development Process"/>
                <meta name="keywords" content="continuous integration, continuous delivery, software development process, revision control"/>
                <meta name="author" content="rultor.com"/>
                <!-- JavaScript exception/error logger to qbaka.com -->
                <script type="text/javascript"><![CDATA[
                    window.qbaka || (function (a, c) {
                        a.__qbaka_eh = a.onerror;
                        a.__qbaka_reports = [];
                        a.onerror = function () {
                            a.__qbaka_reports.push(arguments);
                            if (a.__qbaka_eh)try {
                                a.__qbaka_eh.apply(a, arguments)
                            } catch (b) {
                            }
                        };
                        a.onerror.qbaka = 1;
                        a.qbaka = {report: function () {
                            a.__qbaka_reports.push([arguments, new Error()]);
                        }, customParams: {}, set: function (a, b) {
                            qbaka.customParams[a] = b
                        }, exec: function (a) {
                            try {
                                a()
                            } catch (b) {
                                qbaka.reportException(b)
                            }
                        }, reportException: function () {
                        }};
                        var b = c.createElement("script"), e = c.getElementsByTagName("script")[0], d = function () {
                            e.parentNode.insertBefore(b, e)
                        };
                        b.type = "text/javascript";
                        b.async = !0;
                        b.src = "//cdn.qbaka.net/reporting.js";
                        "[object Opera]" == a.opera ? c.addEventListener("DOMContentLoaded", d) : d();
                        qbaka.key = "e59595737b70f68465b6dc1971692095"
                    })(window, document);
                    qbaka.options = {autoStacktrace: 1, trackEvents: 1};
                    ]]></script>
                <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"/>
                <link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css"/>
                <link rel="stylesheet" type="text/css" media="all" href="/css/style.css?{version/revision}"/>
                <link rel="icon" type="image/gif" href="//img.rultor.com/favicon.ico?{version/revision}"/>
                <script type="text/javascript" src="js/layout.js?{version/revision}">
                    <xsl:text> </xsl:text>
                </script>
                <script type="text/javascript"><![CDATA[
                    var _gaq = _gaq || [];
                    _gaq.push(['_setAccount', 'UA-1963507-28']);
                    _gaq.push(['_trackPageview']);
                    (function () {
                        var ga = document.createElement('script');
                        ga.type = 'text/javascript';
                        ga.async = true;
                        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                        var s = document.getElementsByTagName('script')[0];
                        s.parentNode.insertBefore(ga, s);
                    })();
                    ]]></script>
                <script type="text/javascript"><![CDATA[
                    var _prum = [
                        ['id', '51fcbb82abe53dcf27000000'],
                        ['mark', 'firstbyte', (new Date()).getTime()]
                    ];
                    (function () {
                        var s = document.getElementsByTagName('script')[0], p = document.createElement('script');
                        p.async = 'async';
                        p.src = '//rum-static.pingdom.net/prum.min.js';
                        s.parentNode.insertBefore(p, s);
                    })();
                    ]]></script>
                <xsl:apply-templates select="." mode="head"/>
            </head>
            <body>
                <xsl:if test="/page/nav/item">
                    <div class="overlay" onclick="$('.menu').hide();">
                        <!-- this is for W3C compliance -->
                        <xsl:text> </xsl:text>
                    </div>
                </xsl:if>
                <aside>
                    <a href="https://github.com/rultor/rultor" class="hidden-xs hidden-sm">
                        <img style="position: absolute; top: 0; right: 0; border: 0; width: 100px; height: 100px;"
                            src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png"
                            alt="Fork me on GitHub"/>
                    </a>
                </aside>
                <ul class="list-inline">
                    <li class="logo">
                        <xsl:if test="/page/nav/item">
                            <xsl:attribute name="onclick">
                                <xsl:text>$('.menu').toggle();</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="contains(/page/version/name, 'SNAPSHOT')">
                                <xsl:text>R</xsl:text>
                                <!--
                                Would be nice to show a different logo for a SNAPSHOT version,
                                but now we deploy so often that all versions are snapshots. Let's
                                enable this feature in the future
                                -->
                                <!-- <xsl:text>b</xsl:text> -->
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>R</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </li>
                    <li>
                        <a href="//doc.rultor.com/">
                            <xsl:text>how it works?</xsl:text>
                        </a>
                    </li>
                    <xsl:apply-templates select="breadcrumbs/crumb"/>
                    <xsl:apply-templates select="identity"/>
                </ul>
                <xsl:if test="nav">
                    <aside class="menu panel panel-default">
                        <div class="panel-body">
                            <xsl:apply-templates select="nav"/>
                        </div>
                    </aside>
                </xsl:if>
                <xsl:apply-templates select="flash"/>
                <article>
                    <xsl:apply-templates select="." mode="body"/>
                </article>
                <xsl:apply-templates select="version"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="crumb">
        <li>
            <xsl:variable name="title" select="concat('/',.)"/>
            <xsl:variable name="rel" select="@rel"/>
            <xsl:choose>
                <xsl:when test="/page/links/link[@rel=$rel]">
                    <a href="{/page/links/link[@rel=$rel]/@href}">
                        <xsl:value-of select="$title"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$title"/>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>
    <xsl:template match="nav">
        <ul class="nav nav-pills nav-stacked">
            <xsl:apply-templates select="item"/>
        </ul>
    </xsl:template>
    <xsl:template match="item">
        <xsl:variable name="rel" select="@rel"/>
        <xsl:if test="/page/links/link[@rel=$rel]">
            <li>
                <xsl:if test="/page/links/link[@rel=$rel]/@href = /page/links/link[@rel='self']/@href">
                    <xsl:attribute name="class">
                        <xsl:text>active</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <a href="{/page/links/link[@rel=$rel]/@href}">
                    <xsl:value-of select="."/>
                </a>
            </li>
        </xsl:if>
    </xsl:template>
    <xsl:template match="version">
        <aside class="version hidden-xs hidden-sm" style="padding: 0.2em 0.5em;">
            <ul class="list-inline">
                <li>
                    <xsl:attribute name="class">
                        <xsl:if test="contains(name, 'SNAPSHOT')">
                            <xsl:text> text-danger</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:value-of select="name"/>
                </li>
                <li>
                    <a href="https://github.com/rultor/rultor/commit/{revision}"
                        title="{revision}">
                        <i class="icon-github">
                            <xsl:comment>github icon</xsl:comment>
                        </i>
                    </a>
                </li>
                <li>
                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="/page/millis &gt; 5000">
                                <xsl:text> text-danger</xsl:text>
                            </xsl:when>
                            <xsl:when test="/page/millis &gt; 1000">
                                <xsl:text> text-warning</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:call-template name="millis">
                        <xsl:with-param name="millis" select="/page/millis"/>
                    </xsl:call-template>
                </li>
            </ul>
        </aside>
    </xsl:template>
    <xsl:template match="flash">
        <p>
            <xsl:attribute name="class">
                <xsl:text>alert</xsl:text>
                <xsl:choose>
                    <xsl:when test="level = 'INFO'">
                        <xsl:text> alert-success</xsl:text>
                    </xsl:when>
                    <xsl:when test="level = 'WARNING'">
                        <xsl:text> alert-info</xsl:text>
                    </xsl:when>
                    <xsl:when test="level = 'SEVERE'">
                        <xsl:text> alert-danger</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> alert-default</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <span class="markdown">
                <xsl:value-of select="message"/>
            </span>
            <xsl:if test="msec &gt; 0">
                <xsl:text> (in </xsl:text>
                <xsl:call-template name="millis">
                    <xsl:with-param name="millis" select="msec"/>
                </xsl:call-template>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </p>
    </xsl:template>
    <xsl:template match="identity">
        <li>
            <img style="width: 25px; height: 25px;" class="img-rounded"
                src="{photo}" alt="{name}"/>
        </li>
        <li title="{urn}">
            <xsl:value-of select="name"/>
        </li>
        <li>
            <i title="{urn}">
                <xsl:attribute name="class">
                    <xsl:text>icon-</xsl:text>
                    <xsl:choose>
                        <xsl:when test="starts-with(urn, 'urn:facebook:')">
                            <xsl:text>facebook-sign</xsl:text>
                        </xsl:when>
                        <xsl:when test="starts-with(urn, 'urn:github:')">
                            <xsl:text>github-sign</xsl:text>
                        </xsl:when>
                        <xsl:when test="starts-with(urn, 'urn:google:')">
                            <xsl:text>google-plus-sign</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:comment>authenticated</xsl:comment>
            </i>
        </li>
        <li class="icon">
            <a title="log out" href="{/page/links/link[@rel='rexsl:logout']/@href}">
                <i class="icon-signout">
                    <xsl:comment>signout icon</xsl:comment>
                </i>
            </a>
        </li>
    </xsl:template>
</xsl:stylesheet>