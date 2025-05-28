import Controller from '@ember/controller';
import { action } from '@ember/object';
import { service } from '@ember/service';
import ENV from 'web/config/environment';

export default class LoginController extends Controller {
  @service router;
  @service session;

  @action
  setEmail(e) {
    this.model.email = e.target.value;
  }

  @action
  setPassword(e) {
    this.model.password = e.target.value;
  }

  @action
  async createToken(event) {
    event.preventDefault();

    const response = await fetch(`${ENV.apiURL}/token`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },

      body: JSON.stringify({
        email: this.model.email,
        password: this.model.password,
      }),
    });

    if (!response.ok) {
      this.model.error = 'Login failed';
    } else {
      const json = await response.json();
      this.session.storeToken(json.token);

      this.router.transitionTo('admin.posts');
    }
  }
}
