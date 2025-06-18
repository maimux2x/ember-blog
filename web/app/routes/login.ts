import Route from '@ember/routing/route';
import { tracked } from '@glimmer/tracking';

export class Login {
  @tracked email?: string;
  @tracked password?: string;
  @tracked error?: string;
}

export default class LoginRoute extends Route {
  model() {
    return new Login();
  }
}
