import Route from '@ember/routing/route';
import Post from 'web/models/post';

export default class AdminPostsEditRoute extends Route {
  async model({ post_id }) {
    const post = await fetch(`http://localhost:3000/posts/${post_id}`).then(
      (res) => res.json(),
    );

    return Post.fromJSON(post);
  }
}
