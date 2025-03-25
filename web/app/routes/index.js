import Route from '@ember/routing/route';

export default class IndexRoute extends Route {
  async model() {
    return await fetch('http://localhost:3000/posts').then((res) => res.json());
  }
}
