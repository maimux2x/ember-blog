import Route from '@ember/routing/route';

import ENV from 'web/config/environment';
import Post from 'web/models/post';

import type { paths } from 'schema/openapi';

type Payload =
  paths['/posts/{id}']['get']['responses']['200']['content']['application/json'];

export default class AdminPostsEditRoute extends Route {
  async model({ post_id }: { post_id: string }) {
    const res = await fetch(`${ENV.appURL}/api/posts/${post_id}`);
    const post = (await res.json()) as Payload;

    return Post.fromJSON(post);
  }
}
