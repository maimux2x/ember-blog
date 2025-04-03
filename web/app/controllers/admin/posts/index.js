import Controller from '@ember/controller';
import { action } from '@ember/object';
import { service } from '@ember/service';

export default class AdminPostsIndexController extends Controller {
  @service router;
  @service session;

  @action
  logout() {
    this.session.deleteToken();

    this.router.transitionTo('login');
  }
}
