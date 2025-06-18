import Route from '@ember/routing/route';

import Post from 'web/models/post';

export default class AdminPostsNewRoute extends Route {
  model() {
    return new Post();
  }
}
