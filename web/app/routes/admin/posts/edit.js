import Route from '@ember/routing/route';
import Post from 'web/models/post';
import ENV from 'web/config/environment';

export default class AdminPostsEditRoute extends Route {
  async model({ post_id }) {
    const post = await fetch(`${ENV.apiURL}/posts/${post_id}`).then((res) =>
      res.json(),
    );

    return Post.fromJSON(post);
  }
}
