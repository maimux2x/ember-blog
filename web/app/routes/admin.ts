import Route from '@ember/routing/route';
import { service } from '@ember/service';

import type RouterService from '@ember/routing/router-service';
import type SessionService from 'web/services/session';

export default class AdminRoute extends Route {
  @service declare router: RouterService;
  @service declare session: SessionService;

  beforeModel() {
    if (!this.session.isLogedIn) {
      this.router.transitionTo('index');
    }
  }
}
