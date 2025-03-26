import Route from '@ember/routing/route';

export default class AdminPostsEditRoute extends Route {
  async model({ post_id }) {
    return await fetch(`http://localhost:3000/posts/${post_id}`).then((res) =>
      res.json(),
    );
  }
}
