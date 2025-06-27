import Route from '@ember/routing/route';

import ENV from 'web/config/environment';
import Post from 'web/models/post';

import type { paths } from 'schema/openapi';

type Payload =
  paths['/posts']['get']['responses']['200']['content']['application/json'];

export default class IndexRoute extends Route {
  queryParams = {
    page: {
      refreshModel: true,
    },
  };

  async model({ page }: { page: number }) {
    const url = new URL(`${ENV.appURL}/api/posts`);

    url.searchParams.set('page', page.toString());

    const res = await fetch(url);
    const { posts, total_pages } = (await res.json()) as Payload;

    return {
      posts: posts.map((post) => Post.fromJSON(post)),
      totalPages: total_pages,
    };
  }
}
