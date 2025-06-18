import Route from '@ember/routing/route';

import Post from 'web/models/post';
import ENV from 'web/config/environment';

import type { PostJSON } from 'web/models/post';

export default class IndexRoute extends Route {
  queryParams = {
    page: {
      refreshModel: true,
    },
  };

  async model({ page, query }: { page: number; query: string }) {
    const url = new URL(`${ENV.appURL}/api/posts`);

    url.searchParams.set('page', page.toString());
    url.searchParams.set('query', query);

    const res = await fetch(url);
    const { posts, total_pages } = (await res.json()) as {
      posts: PostJSON[];
      total_pages: number;
    };

    return {
      posts: posts.map((post) => Post.fromJSON(post)),
      totalPages: total_pages,
    };
  }
}
