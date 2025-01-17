/**
 * Copyright (c) 2009-2023 Yegor Bugayenko
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
package com.rultor.agents.daemons;

import com.jcabi.aspects.Immutable;
import com.jcabi.log.Logger;
import com.jcabi.ssh.Shell;
import com.jcabi.ssh.Ssh;
import com.jcabi.xml.XML;
import com.rultor.Time;
import com.rultor.agents.AbstractAgent;
import com.rultor.agents.shells.TalkShells;
import java.io.IOException;
import java.util.concurrent.TimeUnit;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.xembly.Directive;
import org.xembly.Directives;
import org.xembly.Xembler;

/**
 * If the daemon is too old and the Docker container is already gone.
 *
 * @author Yegor Bugayenko (yegor256@gmail.com)
 * @version $Id$
 * @since 1.72
 */
@Immutable
@ToString
@EqualsAndHashCode(callSuper = false)
public final class DropsDaemon extends AbstractAgent {

    /**
     * Ctor.
     */
    public DropsDaemon() {
        // @checkstyle MagicNumber (1 line)
        this(TimeUnit.DAYS.toMinutes(10L));
    }

    /**
     * Ctor.
     * @param mins Maximum minutes per build
     */
    public DropsDaemon(final long mins) {
        super(
            "/talk/daemon[started and not(code) and not(ended)]",
            String.format(
                // @checkstyle LineLength (1 line)
                "/talk[(current-dateTime() - xs:dateTime(daemon/started)) div xs:dayTimeDuration('PT1M') > %d]",
                mins
            ),
            "/talk/shell[host and port and login and key]"
        );
    }

    @Override
    public Iterable<Directive> process(final XML xml) throws IOException {
        final Shell shell = new TalkShells(xml).get();
        final String talk = xml.xpath("/talk/@name").get(0);
        final String container = new Container(talk).toString();
        final int exit = new Shell.Empty(shell).exec(
            String.format(
                "docker ps | grep %s",
                Ssh.escape(container)
            )
        );
        final Directives dirs = new Directives();
        if (exit != 0) {
            Logger.warn(
                this,
                "Docker container %s is lost in %s, time to drop the daemon",
                container, talk
            );
            dirs.append(
                new Directives()
                    .xpath("/talk/daemon")
                    .strict(1)
                    .add("ended").set(new Time().iso()).up()
                    .add("code").set("1").up()
                    .add("tail").set(
                        Xembler.escape(
                            String.format(
                                "Docker container %s is lost",
                                container
                            )
                        )
                    )
            );
        }
        return dirs;
    }

}
