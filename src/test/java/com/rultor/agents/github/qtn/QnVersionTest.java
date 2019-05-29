/**
 * Copyright (c) 2009-2019, Yegor Bugayenko
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
 */
package com.rultor.agents.github.qtn;

import com.jcabi.github.Comment;
import com.jcabi.github.Issue;
import com.jcabi.github.Repo;
import com.jcabi.github.mock.MkGithub;
import com.jcabi.manifests.Manifests;
import com.rultor.agents.github.Req;
import java.net.URI;
import org.hamcrest.MatcherAssert;
import org.hamcrest.Matchers;
import org.junit.Test;

/**
 * Tests for ${@link QnVersion}.
 *
 * @author Yegor Bugayenko (yegor256@gmail.com)
 * @version $Id$
 * @since 1.6
 * @checkstyle MultipleStringLiteralsCheck (500 lines)
 * @checkstyle ClassDataAbstractionCouplingCheck (500 lines)
 */
public final class QnVersionTest {

    /**
     * QnVersion can reply.
     * @throws Exception In case of error.
     */
    @Test
    public void repliesInGithub() throws Exception {
        final Repo repo = new MkGithub().randomRepo();
        final Issue issue = repo.issues().create("", "");
        issue.comments().post("version");
        MatcherAssert.assertThat(
            new QnVersion().understand(
                new Comment.Smart(issue.comments().get(1)), new URI("#")
            ),
            Matchers.is(Req.DONE)
        );
        MatcherAssert.assertThat(
            new Comment.Smart(issue.comments().get(2)).body(),
            Matchers.containsString("My current version is")
        );
    }

    /**
     * QnVersion reply contains link to revision.
     * @throws Exception In case of error.
     */
    @Test
    public void repliesWithLinkToRevision() throws Exception {
        final Repo repo = new MkGithub().randomRepo();
        final Issue issue = repo.issues().create("", "");
        issue.comments().post("version");
        MatcherAssert.assertThat(
            new QnVersion().understand(
                new Comment.Smart(issue.comments().get(1)), new URI("#")
            ),
            Matchers.is(Req.DONE)
        );
        MatcherAssert.assertThat(
            new Comment.Smart(issue.comments().get(2)).body(),
            Matchers.containsString(
                String.format(
                    "/commit/%s",
                    Manifests.read("Rultor-Revision")
                )
            )
        );
    }

}
