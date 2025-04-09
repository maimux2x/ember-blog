import Controller from '@ember/controller';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class AdminPostsIndexController extends Controller {
  queryParams = [
    {
      page: { type: 'number' },
    },
  ];

  @service router;
  @service session;

  @tracked page = 1;

  @action
  logout() {
    this.session.deleteToken();

    this.router.transitionTo('login');
  }
}
