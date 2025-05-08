import Route from '@ember/routing/route';
import Post from '../../models/post';
import ENV from 'web/config/environment';

export default class PostsTagRoute extends Route {
  async model({ tag_name }) {
    const url = new URL(`${ENV.apiURL}/posts`);
    url.searchParams.set('tag_name', tag_name);

    const payload = await fetch(url, {
      headers: {
        Accept: 'application/json',
      },
    }).then((res) => res.json());
    payload.posts = payload.posts.map((post) => Post.fromJSON(post));
    payload.tagName = tag_name;

    return payload;
  }
}
