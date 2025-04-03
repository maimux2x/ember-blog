import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class AdminRoute extends Route {
  @service router;
  @service session;

  beforeModel() {
    if (!this.session.isLogedIn) {
      this.router.transitionTo('index');
    }
  }
}
