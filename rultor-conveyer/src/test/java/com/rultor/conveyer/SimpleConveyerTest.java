/**
 * Copyright (c) 2009-2013, rultor.com
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
package com.rultor.conveyer;

import com.jcabi.urn.URN;
import com.rultor.spi.Conveyer;
import com.rultor.spi.Instance;
import com.rultor.spi.Queue;
import com.rultor.spi.Repo;
import com.rultor.spi.Spec;
import com.rultor.spi.User;
import com.rultor.spi.Users;
import com.rultor.spi.Work;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import org.hamcrest.MatcherAssert;
import org.hamcrest.Matchers;
import org.junit.Test;
import org.mockito.Mockito;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

/**
 * Test case for {@link SimpleConveyer}.
 * @author Yegor Bugayenko (yegor@tpc2.com)
 * @version $Id$
 */
public final class SimpleConveyerTest {

    /**
     * SimpleConveyer can start and stop.
     * @throws Exception If some problem inside
     */
    @Test
    public void startsAndStops() throws Exception {
        final Queue queue = Mockito.mock(Queue.class);
        final URN owner = new URN("urn:facebook:1");
        final AtomicBoolean pulled = new AtomicBoolean();
        Mockito.doAnswer(
            new Answer<Work>() {
                @Override
                public Work answer(final InvocationOnMock inv)
                    throws Exception {
                    if (pulled.get()) {
                        TimeUnit.DAYS.sleep(1);
                    }
                    pulled.set(true);
                    return new Work.Simple(owner, "unit", new Spec.Simple());
                }
            }
        ).when(queue).pull();
        final Repo repo = Mockito.mock(Repo.class);
        final Instance instance = Mockito.mock(Instance.class);
        final CountDownLatch made = new CountDownLatch(1);
        Mockito.doAnswer(
            new Answer<Instance>() {
                @Override
                public Instance answer(final InvocationOnMock invocation)
                    throws Exception {
                    made.countDown();
                    return instance;
                }
            }
        ).when(repo).make(Mockito.any(User.class), Mockito.any(Spec.class));
        final Users users = Mockito.mock(Users.class);
        final Conveyer.Log log = Mockito.mock(Conveyer.Log.class);
        final Conveyer conveyer = new SimpleConveyer(queue, repo, users, log);
        try {
            conveyer.start();
            MatcherAssert.assertThat(
                made.await(2, TimeUnit.SECONDS), Matchers.is(true)
            );
        } finally {
            conveyer.close();
        }
        Mockito.verify(queue, Mockito.atLeast(1)).pull();
        Mockito.verify(users, Mockito.atLeast(1)).fetch(owner);
        Mockito.verify(instance, Mockito.atLeast(1)).pulse();
    }

}
