import Route from '@ember/routing/route';
import Post from '../models/post';

export default class IndexRoute extends Route {
  queryParams = {
    page: {
      refreshModel: true,
    },
  };

  async model(args) {
    const url = new URL('http://localhost:3000/posts');
    url.searchParams.set('page', args.page);
    url.searchParams.set('query', args.query);

    const payload = await fetch(url, {
      headers: {
        Accept: 'application/json',
      },
    }).then((res) => res.json());
    payload.posts = payload.posts.map((post) => Post.fromJSON(post));

    return payload;
  }
}
