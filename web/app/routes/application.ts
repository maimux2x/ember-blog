import Route from '@ember/routing/route';
import { service } from '@ember/service';

import type SessionService from 'web/services/session';

export default class ApplicationRoute extends Route {
  @service declare session: SessionService;

  beforeModel() {
    this.session.restoreToken();
  }
}
