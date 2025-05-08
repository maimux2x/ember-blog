import Route from '@ember/routing/route';
import ENV from 'web/config/environment';

export default class IndexRoute extends Route {
  queryParams = {
    page: {
      refreshModel: true,
    },
  };

  async model(args) {
    const url = new URL(`${ENV.apiURL}/posts`);
    url.searchParams.set('page', args.page);

    return await fetch(url, {
      headers: {
        Accept: 'application/json',
      },
    }).then((res) => res.json());
  }
}
