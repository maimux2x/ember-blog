import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class SessionService extends Service {
  @tracked token?: string;

  storeToken(token: string) {
    this.token = token;
    localStorage.setItem('token', token);
  }

  restoreToken() {
    this.token = localStorage.getItem('token') ?? undefined;
  }

  deleteToken() {
    this.token = undefined;
    localStorage.removeItem('token');
  }

  get isLogedIn() {
    return !!this.token;
  }
}
