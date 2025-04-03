import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class SessionService extends Service {
  @tracked token;

  storeToken(token) {
    this.token = token;
    localStorage.setItem('token', token);
  }

  restoreToken() {
    this.token = localStorage.getItem('token');
  }

  deleteToken() {
    this.token = null;
    localStorage.removeItem('token');
  }

  get isLogedIn() {
    return !!this.token;
  }
}
