import Route from '@ember/routing/route';

import ENV from 'web/config/environment';
import Post from 'web/models/post';

import type { PostJSON } from 'web/models/post';

export default class AdminPostsEditRoute extends Route {
  async model({ post_id }: { post_id: string }) {
    const res = await fetch(`${ENV.appURL}/api/posts/${post_id}`);
    const post = (await res.json()) as PostJSON;

    return Post.fromJSON(post);
  }
}
