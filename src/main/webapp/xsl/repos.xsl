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
    <xsl:output method="xml" omit-xml-declaration="yes"/>
    <xsl:include href="./layout.xsl"/>
    <xsl:template match="page" mode="head">
        <title>
            <xsl:text>repos</xsl:text>
        </title>
    </xsl:template>
    <xsl:template match="page" mode="body">
        <div class="row">
            <div class="col-12 col-sm-6 col-lg-4">
                <form method="post" class="form-inline spacious"
                    action="{links/link[@rel='create']/@href}">
                    <fieldset>
                        <div class="input-group">
                            <input name="coords" type="text" class="form-control"
                                placeholder="Github repository name, e.g yegor256/test"/>
                            <span class="input-group-btn">
                                <button type="submit" class="btn btn-primary">
                                    <xsl:text>Create</xsl:text>
                                </button>
                            </span>
                        </div>
                    </fieldset>
                </form>
            </div>
        </div>
        <xsl:choose>
            <xsl:when test="repos/repo">
                <xsl:apply-templates select="repos/repo"/>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:text>Now create your first repo and configure it as </xsl:text>
                    <a href="//doc.rultor.com/start.html">
                        <xsl:text>this article</xsl:text>
                    </a>
                    <xsl:text> explains.</xsl:text>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="repo">
        <div class="spacious">
            <ul class="list-inline">
                <li>
                    <a title="view it" href="{links/link[@rel='open']/@href}">
                        <xsl:value-of select="coordinates"/>
                    </a>
                </li>
                <li class="icon">
                    <a onclick="return confirm('Are you sure?');"
                        href="{links/link[@rel='delete']/@href}"
                        title="delete this repo">
                        <i class="icon-remove"><xsl:comment>remove</xsl:comment></i>
                    </a>
                </li>
            </ul>
        </div>
    </xsl:template>
</xsl:stylesheet>