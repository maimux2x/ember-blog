import Route from '@ember/routing/route';
import Post from '../../models/post';
import ENV from 'web/config/environment';

export default class PostsShowRoute extends Route {
  async model({ post_id }) {
    const post = await fetch(`${ENV.appURL}/api/posts/${post_id}`).then((res) =>
      res.json(),
    );

    return Post.fromJSON(post);
  }
}
