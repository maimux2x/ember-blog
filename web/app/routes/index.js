import Route from '@ember/routing/route';

export default class IndexRoute extends Route {
  queryParams = {
    page: {
      refreshModel: true,
    },
  };

  async model(args) {
    const url = new URL('http://localhost:3000/posts');
    url.searchParams.set('page', args.page);

    return await fetch(url).then((res) => res.json());
  }
}
