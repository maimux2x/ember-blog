import Route from '@ember/routing/route';
import { tracked } from '@glimmer/tracking';

class Login {
  @tracked email;
  @tracked password;
  @tracked error;
}

export default class LoginRoute extends Route {
  model() {
    return new Login();
  }
}
